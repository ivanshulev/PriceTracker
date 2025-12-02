//
//  MessageReceiver.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation
import Combine

protocol MessageReceiver {
    var responsePublisher: AnyPublisher<Response, Never> { get }
}
