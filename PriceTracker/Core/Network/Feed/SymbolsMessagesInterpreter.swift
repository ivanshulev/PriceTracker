//
//  SymbolsMessagesInterpreter.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import Foundation
import Combine
internal import proto_gen
internal import SwiftProtobuf

class SymbolsMessagesInterpreter {
    private let messageHandler: MessageHandler
    @Published var response: SymbolsSnapshot?
    private var cancellables = Set<AnyCancellable>()
    
    init(messageHandler: MessageHandler) {
        self.messageHandler = messageHandler
        
        self.messageHandler.responsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                switch response {
                case .data(let data):
                    let protoSnapshot = try? proto_gen.SymbolsSnapshot(serializedBytes: data)
                    self?.response = protoSnapshot?.toSnapshot()
                case .text(let text):
                    guard let data = Data(base64Encoded: text) else {
                        print("Failed decoding base64 encoded response.")
                        return
                    }
                    
                    let sampleMessage = try? proto_gen.SymbolsSnapshot(serializedBytes: data)
                    self?.response = sampleMessage?.toSnapshot()
                }
            }
            .store(in: &cancellables)
    }
    
    func send(_ snapshot: SymbolsSnapshot) {
        do {
            let data = try snapshot.toProto().serializedData()
            let message = URLSessionWebSocketTask.Message.string(data.base64EncodedString())
            messageHandler.send(message)
        } catch {
            print("Failed to serialize snapshot, error \(error.localizedDescription)")
        }
    }
}

extension SymbolsSnapshot {
    func toProto() -> proto_gen.SymbolsSnapshot {
        var snapshot = proto_gen.SymbolsSnapshot()
        snapshot.items = self.items.map({ $0.toProto() })
        
        return snapshot
    }
}

extension SymbolItem {
    func toProto() -> proto_gen.SymbolItem {
        return proto_gen.SymbolItem.with { item in
            item.ticker = self.ticker
            item.name = self.name
            item.price = self.price
            item.changePercent24H = self.changePercent24H
        }
    }
}

extension proto_gen.SymbolsSnapshot {
    func toSnapshot() -> SymbolsSnapshot {
        SymbolsSnapshot(items: self.items.map({ $0.toItem() }))
    }
}

extension proto_gen.SymbolItem {
    func toItem() -> SymbolItem {
        SymbolItem(ticker: self.ticker,
                   name: self.name,
                   price: self.price,
                   changePercent24H: self.changePercent24H)
    }
}

extension SymbolsMessagesInterpreter: MessagesInterpreter {
    var responsePublisher: AnyPublisher<SymbolsSnapshot, Never> {
        return $response
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
}
