//
//  CustomMessagesInterpreter.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 4.12.25.
//

import Foundation
import Combine

class CustomMessagesInterpreter: MessagesInterpreter {
    private let messageHandler: MessageHandler
    @Published var response: SymbolsSnapshot?
    private var cancellables = Set<AnyCancellable>()
    fileprivate static let itemsSeparator = "#"
    fileprivate static let itemsFieldsSeparator = ";"
    
    init(messageHandler: MessageHandler) {
        self.messageHandler = messageHandler
        
        self.messageHandler.responsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                switch response {
                case .data(let data):
                    guard let responseString = String(data: data, encoding: .utf8) else {
                        return
                    }
                    
                    self?.response = responseString.toSnapshot()
                case .text(let responseString):
                    self?.response = responseString.toSnapshot()
                }
            }
            .store(in: &cancellables)
    }
    
    func send(_ snapshot: SymbolsSnapshot) {
        let message = URLSessionWebSocketTask.Message.string(snapshot.toString())
        messageHandler.send(message)
    }
    
    var responsePublisher: AnyPublisher<SymbolsSnapshot, Never> {
        return $response
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
}

private extension SymbolsSnapshot {
    func toString() -> String {
        return self.items.map { item in
            item.toString()
        }.joined(separator: CustomMessagesInterpreter.itemsSeparator)
    }
}

private extension SymbolItem {
    func toString() -> String {
        let s = CustomMessagesInterpreter.itemsFieldsSeparator
        return "\(self.ticker)\(s)\(self.name)\(s)\(self.price)\(s)\(self.changePercent24H)"
    }
}

private extension String {
    func toSnapshot() -> SymbolsSnapshot {
        let itemsStrings = self.split(separator: CustomMessagesInterpreter.itemsSeparator)
        
        let items = itemsStrings.compactMap { itemString -> SymbolItem? in
            let fieldsStrings = itemString.split(separator: CustomMessagesInterpreter.itemsFieldsSeparator)
            
            let ticker = fieldsStrings[0]
            let name = fieldsStrings[1]
            
            guard let price = Double(fieldsStrings[2]) else {
                return nil
            }
            
            guard let changePercent24H = Double(fieldsStrings[3]) else {
                return nil
            }
            
            return SymbolItem(ticker: String(ticker),
                              name: String(name),
                              price: price,
                              changePercent24H: changePercent24H)
        }
        
        return SymbolsSnapshot(items: items)
    }
}
