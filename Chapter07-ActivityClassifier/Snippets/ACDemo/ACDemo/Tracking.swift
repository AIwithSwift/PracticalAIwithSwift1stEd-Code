//
//  Tracking.swift
//  ACDemo
//
//  Created by Mars Geldard on 25/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI
import Combine
import CoreMotion

final class ActivityTracker: BindableObject {
    let didChange = PassthroughSubject<ActivityTracker, Never>()
    
    private let tracker = CMMotionActivityManager()
    private(set) var currentActivity: String = "None detectable" {
        willSet {
            self.activityDidChange = (newValue != currentActivity)
        }
        
        didSet {
            didChange.send(self)
        }
    }
    private(set) var activityDidChange = true
    
    init() {}
    
    func startTracking() {
        do {
            try tracker.startTracking { result in
                self.currentActivity = result?.name ?? "None detectable"
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func stopTracking() {
        tracker.stopTracking()
    }
}
