//
//  FeedRowViewModel.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation

struct FeedRowViewModel {
    let symbolItem: SymbolItem
    let ticker: String
    let priceFormatted: String
    let changeImageName: String
    let isUp: Bool
    var isChanged: Bool
    
    init(symbolItem: SymbolItem, isChanged: Bool = false) {
        self.symbolItem = symbolItem
        self.ticker = symbolItem.ticker
        self.priceFormatted = symbolItem.price.formattedPrice()
        self.changeImageName = symbolItem.changePercent24H > 0 ? "arrow.up" : "arrow.down"
        self.isUp = symbolItem.changePercent24H > 0
        self.isChanged = isChanged
    }
}

private extension Double {
    func formattedPrice() -> String {
        return String(format: "$%.2f", self)
    }
}
