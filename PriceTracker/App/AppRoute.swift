//
//  AppRoute.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation

enum AppRoute: Hashable {
    case feed
    case details(ticker: String)
}
