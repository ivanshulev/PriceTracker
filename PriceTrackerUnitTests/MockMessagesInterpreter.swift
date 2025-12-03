//
//  MockMessagesInterpreter.swift
//  PriceTrackerUnitTests
//
//  Created by Ivan Shulev on 3.12.25.
//

import Foundation
import Combine
@testable import PriceTracker

final class MockMessagesInterpreter: MessagesInterpreter {
    private let response = CurrentValueSubject<PriceTracker.SymbolsSnapshot?, Never>(nil)
    
    func send(_ snapshot: PriceTracker.SymbolsSnapshot) {
        response.send(snapshot)
    }
    
    var responsePublisher: AnyPublisher<PriceTracker.SymbolsSnapshot, Never> {
        response
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
}
