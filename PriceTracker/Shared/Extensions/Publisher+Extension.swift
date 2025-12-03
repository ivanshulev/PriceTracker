//
//  Publisher+Extension.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation
import Combine

extension Publisher {
    func retry<NewFailure: Error>(times: Int,
               delay: DispatchQueue.SchedulerTimeType.Stride = .seconds(1),
               scheduler: DispatchQueue = .global(),
               if shouldRetry: @escaping (Failure) -> Bool) -> AnyPublisher<Output, NewFailure> where Failure == NewFailure {
        Publishers.RetryIf(publisher: self, times: times, shouldRetry: shouldRetry)
            .delay(for: delay, scheduler: scheduler)
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    struct RetryIf<P: Publisher>: Publisher {
        typealias Output = P.Output
        typealias Failure = P.Failure
        
        let publisher: P
        let times: Int
        let shouldRetry: (P.Failure) -> Bool
                
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            guard times > 0 else {
                return publisher.receive(subscriber: subscriber)
            }
            
            publisher.catch { (error: P.Failure) -> AnyPublisher<Output, Failure> in
                if shouldRetry(error)  {
                    return RetryIf(publisher: publisher,
                                   times: times - 1,
                                   shouldRetry: shouldRetry).eraseToAnyPublisher()
                } else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }.receive(subscriber: subscriber)
        }
    }
}
