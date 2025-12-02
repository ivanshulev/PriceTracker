//
//  SymbolDetailsProvider.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation

class SymbolDetailsProvider {
    private var stocksMap: [String: Stock] = [:]
    
    init(stocks: [Stock]) {
        stocks.forEach {
            stocksMap[$0.ticker] = $0
        }
    }
    
    func fetchDetails(ticker: String) -> Stock? {
        return self.stocksMap[ticker]
    }
}
