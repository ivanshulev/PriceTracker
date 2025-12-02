//
//  MessageSender.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation

protocol MessageSender {
    func send(_ message: URLSessionWebSocketTask.Message)
}
