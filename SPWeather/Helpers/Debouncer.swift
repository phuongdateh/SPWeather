//
//  Debouncer.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation

final class Debouncer: NSObject {
    public var delay: Double
    public weak var timer: Timer?
 
    public init(delay: Double) {
        self.delay = delay
    }
 
    public func call(action: @escaping (() -> Void)) {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
        timer = nextTimer
    }
}
