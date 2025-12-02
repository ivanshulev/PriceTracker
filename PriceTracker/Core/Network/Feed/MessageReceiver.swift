//
//  MessageReceiver.swift
//  learn_websocket
//
//  Created by Ivan Shulev on 1.12.25.
//

import Foundation
import Combine

protocol MessageReceiver {
    var responsePublisher: AnyPublisher<Response, Never> { get }
}
