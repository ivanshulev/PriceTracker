//
//  MessageHandler.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import Foundation
import Combine

protocol MessageHandler {
    func send(_ message: URLSessionWebSocketTask.Message)
    var responsePublisher: AnyPublisher<Response, Never> { get }
}
