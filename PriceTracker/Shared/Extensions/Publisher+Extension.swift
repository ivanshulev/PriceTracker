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
        self.catch { error -> AnyPublisher<Output, NewFailure> in
            guard shouldRetry(error), times > 0 else {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            return Just(())
                .delay(for: delay, scheduler: scheduler)
                .flatMap { _ in
                    retry(times: times - 1, delay: delay, if: shouldRetry)
                }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
