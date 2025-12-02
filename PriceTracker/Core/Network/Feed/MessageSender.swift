//
//  MessageSender.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import Foundation

protocol MessageSender {
    func send(_ message: URLSessionWebSocketTask.Message)
}
