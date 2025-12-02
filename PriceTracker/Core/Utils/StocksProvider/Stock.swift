//
//  Stock.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import Foundation

struct Stock: Codable {
    let rank: Int
    let ticker: String
    let name: String
    let marketCap: Int64
    let price: Double
    let changePercent24h: Double
    let logo: URL
    let description: String
    
    // Custom coding keys to match JSON field names
    private enum CodingKeys: String, CodingKey {
        case rank
        case ticker
        case name
        case marketCap = "market_cap"
        case price
        case changePercent24h = "change_percent_24h"
        case logo
        case description
    }
}
