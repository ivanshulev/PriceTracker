//
//  SymbolItem.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation

struct SymbolItem: Hashable {
    public var ticker: String
    public var name: String
    public var price: Double
    public var changePercent24H: Double
}
