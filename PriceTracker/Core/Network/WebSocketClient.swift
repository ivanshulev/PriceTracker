//
//  WebSocketClient.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI
import Combine
import SwiftProtobuf
import proto_gen

class WebSocketClient: NSObject, ObservableObject, MessageHandler {
    let webSocketURL: URL
    private let sendRequests = PassthroughSubject<Request, Never>()
    @Published var isConnected = false
    @Published var response: Response?
    private var webSocketTask: URLSessionWebSocketTask?
    private var stateObserver: NSKeyValueObservation?
    private var cancellables = Set<AnyCancellable>()
    private var isStarted = false
    
    enum WebSocketError: Error {
        case failedSendingRequest(Error)
        case failedSerializingRequest(Error)
    }
    
    typealias Request = URLSessionWebSocketTask.Message
    
    init(webSocketURL: URL) {
        self.webSocketURL = webSocketURL
        super.init()
        
        sendRequests
            .flatMap({ [unowned self] message in
                guard self.webSocketTask?.state == .suspended else {
                    return Just<URLSessionWebSocketTask.Message>(message)
                        .eraseToAnyPublisher()
                }
                
                return self.$isConnected
                    .map { _ in
                        return message
                    }
                    .eraseToAnyPublisher()
            })
            .flatMap(maxPublishers: .max(2)) { [unowned self] message in
                self._send(message)
                    .retry(times: 2, delay: .seconds(1)) { error in
                        switch error {
                        case .failedSendingRequest:
                            return true
                        default:
                            return false
                        }
                    }
                    .catch { error in
                        print("Error sending request \(error.localizedDescription)")
                        return Just<Void>(())
                    }
            }
            .sink { completion in
            } receiveValue: { _ in
            }
            .store(in: &cancellables)
    }
    
    func connect() {
        guard !isStarted else {
            return
        }
        
        isStarted = true
        
        var request = URLRequest(url: webSocketURL)
        request.addValue("chat, websocket", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        request.addValue("permessage-deflate", forHTTPHeaderField: "Sec-WebSocket-Extensions")
        request.timeoutInterval = 10
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: request)
        
        stateObserver = webSocketTask?.observe(\.state, changeHandler: { [weak self] task, _ in
            DispatchQueue.main.async {
                self?.isConnected = task.state == .running
            }
        })
        
        webSocketTask?.resume()
        observeNextResponse()
    }
    
    func disconnect() {
        guard isStarted else {
            return
        }
        
        isStarted = false
        
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
    
    func send(_ request: Request) {
        guard isStarted else {
            return
        }
        
        sendRequests.send(request)
    }
    
    var responsePublisher: AnyPublisher<Response, Never> {
        $response
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
    
    private func _send(_ request: Request) -> AnyPublisher<Void, WebSocketError> {
        return Future<Void, WebSocketError> { [unowned self] promise in
            self.webSocketTask?.send(request) { error in
                if let error = error {
                    promise(.failure(.failedSendingRequest(error)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func observeNextResponse() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.response = .text(text)
                case .data(let data):
                    self?.response = .data(data)
                @unknown default:
                    break
                }
                
                self?.observeNextResponse()
            case .failure:
                self?.isConnected = false
            }
        }
    }
}

extension WebSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        isConnected = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isConnected = false
    }
}
