//
//  FeedsSimulator.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation
import Combine

class FeedsSimulator {
    private let symbolsMessagesInterpreter: SymbolsMessagesInterpreter
    private let stocksProvider: StocksProvider
    private let timer = DetachedTimer()
    private let customMode = RunLoop.Mode(rawValue: "com.priceTracker.customMode")
    private var cancellables = Set<AnyCancellable>()
    private var isStarted = false
    private var previousSnapshot: SymbolsSnapshot?
    
    init(symbolsMessagesInterpreter: SymbolsMessagesInterpreter, stocksProvider: StocksProvider) {
        self.symbolsMessagesInterpreter = symbolsMessagesInterpreter
        self.stocksProvider = stocksProvider
    }
    
    func start() async {
        guard !isStarted else {
            return
        }
        
        isStarted = true
        let stocks = await stocksProvider.loadStocksAsync()
        setupInitialSnapshot(stocks: stocks)
        
        timer.startTimer(intervalInSeconds: 2) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.prepareNextSnapshot()
            
            if let snapshot = self.previousSnapshot {
                symbolsMessagesInterpreter.send(snapshot)
            }
        }
    }
    
    func stop() {
        guard isStarted else {
            return
        }
        
        isStarted = false
        timer.stop()
    }
    
    private func setupInitialSnapshot(stocks: [Stock]) {
        let symbolsItems = stocks.map { stock in
            return SymbolItem(ticker: stock.ticker,
                              name: stock.name,
                              price: stock.price,
                              changePercent24H: stock.changePercent24h)
        }
        
        previousSnapshot = SymbolsSnapshot(items: symbolsItems)
    }
    
    private func prepareNextSnapshot() {
        guard var previousSnapshot = self.previousSnapshot else {
            return
        }
        
        let minCount = min(5, previousSnapshot.items.count)
        let itemsCountToUpdated = Int.random(in: minCount..<previousSnapshot.items.count)
        var indexes: [Int] = []
        
        for _ in 0..<itemsCountToUpdated {
            let index = Int.random(in: 0..<previousSnapshot.items.count)
            indexes.append(index)
        }
        
        for index in indexes {
            let change = Double.random(in: -2.7...2.7)
            previousSnapshot.items[index].price += change
            previousSnapshot.items[index].changePercent24H = change
        }
        
        self.previousSnapshot = previousSnapshot
    }
}
