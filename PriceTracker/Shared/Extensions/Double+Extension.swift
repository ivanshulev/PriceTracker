//
//  Double+Extension.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation

extension Double {
    func formattedPrice() -> String {
        return String(format: "$%.2f", self)
    }
}
