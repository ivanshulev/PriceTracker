//
//  DetachedTimer.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import Foundation

class DetachedTimer {
    private var timerTask: Task<Void, Never>?
    
    func startTimer(intervalInSeconds: Int, action: @escaping () -> Void) {
        timerTask?.cancel()
        
        timerTask = Task.detached(priority: .utility) {
            do {
                while true {
                    try await Task.sleep(nanoseconds: UInt64(intervalInSeconds) * 1_000_000_000)
                    action()
                }
            } catch {
            }
        }
    }
    
    func stop() {
        timerTask?.cancel()
    }
}
