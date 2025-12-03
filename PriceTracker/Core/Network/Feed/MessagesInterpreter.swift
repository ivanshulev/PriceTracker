//
//  MessagesInterpreter.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 3.12.25.
//

import Foundation
import Combine

protocol MessagesInterpreter {
    func send(_ snapshot: SymbolsSnapshot)
    var responsePublisher: AnyPublisher<SymbolsSnapshot, Never> { get }
}
