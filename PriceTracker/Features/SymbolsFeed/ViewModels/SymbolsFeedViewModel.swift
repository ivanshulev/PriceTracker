//
//  SymbolsFeedViewModel.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import Foundation
import Combine

class SymbolsFeedViewModel: ObservableObject {
    private let symbolsMessagesInterpreter: MessagesInterpreter
    private let webSocketClient: WebSocketConnectable
    @Published var viewState: ViewState = .inProgress
    @Published var rowViewModels: [FeedRowViewModel] = []
    @Published var connectionStatus: ConnectionStatus = .init(iconName: "🔴")
    @Published var feedControlButtonTitle = ""
    private var rowViewModelsMap: [String: FeedRowViewModel] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var feedCancellable: AnyCancellable?
    
    let progressStateMessage = "Loading..."
    
    enum ViewState {
        case inProgress
        case failure(String)
        case successful
    }
    
    struct ConnectionStatus {
        var iconName: String
    }
    
    init(symbolsMessagesInterpreter: MessagesInterpreter, webSocketClient: WebSocketConnectable) {
        self.symbolsMessagesInterpreter = symbolsMessagesInterpreter
        self.webSocketClient = webSocketClient
        
        feedControlButtonTitle = controlButtonTitle
        
        webSocketClient.connectedPublisher
            .receive(on: DispatchQueue.main)
            .map { isConnectedValue in
                return isConnectedValue ?  ConnectionStatus(iconName: "🟢") : ConnectionStatus(iconName: "🔴")
            }
            .sink { [weak self] value in
                guard let self = self else {
                    return
                }
                
                self.connectionStatus = value
                self.feedControlButtonTitle = controlButtonTitle
            }
            .store(in: &cancellables)
        
        startObservingFeed()
    }
    
    func connect() {
        webSocketClient.connect()
    }
    
    func disconnect() {
        webSocketClient.disconnect()
    }
    
    func toggleFeed() {
        if webSocketClient.isConnectedValue {
            webSocketClient.disconnect()
        } else {
            webSocketClient.connect()
        }
    }
    
    private var controlButtonTitle: String {
        webSocketClient.isConnectedValue ? "Stop" : "Start"
    }
    
    func startObservingFeed() {
        viewState = .inProgress
        
        guard feedCancellable == nil else {
            return
        }
        
        feedCancellable = self.symbolsMessagesInterpreter.responsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                guard let self = self else {
                    return
                }
                
                self.viewState = .successful
                
                let items = snapshot.items
                    .sorted(by: { lhs, rhs in
                        lhs.price > rhs.price
                    })
                
                self.rowViewModels = items.enumerated()
                    .map {
                        let isChanged = $0.element.price != self.rowViewModelsMap[$0.element.ticker]?.symbolItem.price
                        return FeedRowViewModel(index: $0.offset, symbolItem: $0.element, isChanged: isChanged)
                    }
                
                self.rowViewModels.forEach {
                    self.rowViewModelsMap[$0.ticker] = $0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.resetChange()
                })
            }
    }
    
    func stopObservingFeed() {
        feedCancellable = nil
    }
    
    private func resetChange() {
        for index in 0..<rowViewModels.count {
            rowViewModels[index].isChanged = false
        }
    }
}
