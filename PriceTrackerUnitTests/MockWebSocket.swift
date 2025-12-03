//
//  MockWebSocket.swift
//  PriceTrackerUnitTests
//
//  Created by Ivan Shulev on 3.12.25.
//

import Foundation
import Combine
@testable import PriceTracker

class MockWebSocket: WebSocketConnectable {
    private var isConnected: CurrentValueSubject<Bool, Never>
    
    init(isConnectedValue: Bool) {
        self.isConnected = CurrentValueSubject<Bool, Never>(isConnectedValue)
    }
    
    var connectedPublisher: AnyPublisher<Bool, Never> {
        return isConnected.eraseToAnyPublisher()
    }
    
    var isConnectedValue: Bool {
        isConnected.value
    }
    
    func connect() {
        isConnected.send(true)
    }
    
    func disconnect() {
        isConnected.send(false)
    }
}
