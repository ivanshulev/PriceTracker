//
//  WebSocketConnectable.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 3.12.25.
//

import Foundation
import Combine

protocol WebSocketConnectable {
    func connect()
    func disconnect()
    var connectedPublisher: AnyPublisher<Bool, Never> { get }
    var isConnectedValue: Bool { get }
}
