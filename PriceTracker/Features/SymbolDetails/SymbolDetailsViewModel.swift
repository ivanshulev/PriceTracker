//
//  SymbolDetailsViewModel.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation
import Combine

class SymbolDetailsViewModel: ObservableObject {
    private let ticker: String
    private let symbolsMessagesInterpreter: SymbolsMessagesInterpreter
    private let symbolDetailsProvider: SymbolDetailsProvider
    private var feedCancellable: AnyCancellable?
    @Published var priceFormatted: String = ""
    @Published var changeImageName: String = "arrow.up"
    @Published var isUp: Bool = false
    @Published var details: Details = .init(ticker: "", name: "", description: "")
    
    struct Details {
        var ticker: String
        var name: String
        var description: String
    }
    
    init(ticker: String,
         symbolsMessagesInterpreter: SymbolsMessagesInterpreter,
         symbolDetailsProvider: SymbolDetailsProvider) {
        self.ticker = ticker
        self.symbolsMessagesInterpreter = symbolsMessagesInterpreter
        self.symbolDetailsProvider = symbolDetailsProvider
    }
    
    func fetchDetails() {
        let stock = symbolDetailsProvider.fetchDetails(ticker: ticker)
        
        guard let stock = stock else {
            return
        }
        
        details = Details(ticker: stock.ticker,
                          name: stock.name,
                          description: stock.description)
    }
    
    func startObservingFeed() {
        guard feedCancellable == nil else {
            return
        }
        
        let ticker = self.ticker
        
        feedCancellable = self.symbolsMessagesInterpreter.$response
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                guard let self = self else {
                    return
                }
                
                guard let item = (snapshot?.items.first { $0.ticker == ticker }) else {
                    print("!!!! no ticker found")
                    return
                }
                
                self.priceFormatted = item.price.formattedPrice()
                self.changeImageName = item.changePercent24H > 0 ? "arrow.up" : "arrow.down"
                self.isUp = item.changePercent24H > 0
            }
    }
    
    func stopObservingFeed() {
        feedCancellable = nil
    }
}
