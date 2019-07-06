//
//  Tracking.swift
//  ACDemo
//
//  Created by Mars Geldard on 25/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//
// BEGIN ardemo_tracking_imports
import SwiftUI
import Combine
import CoreMotion
// END ardemo_tracking_imports

// BEGIN ardemo_tracking_imports1
final class ActivityTracker: BindableObject {
    // BEGIN ardemo_tracking_imports1_inner1
    let didChange = PassthroughSubject<ActivityTracker, Never>()
    
    private let tracker = CMMotionActivityManager()
    private(set) var currentActivity: String = "None detectable" {
        willSet {
            activityDidChange = (newValue != currentActivity)
        }
        
        didSet {
            didChange.send(self)
        }
    }
    private(set) var activityDidChange = true
    // END ardemo_tracking_imports1_inner1
    
    // BEGIN ardemo_tracking_imports1_inner2
    init() {}
    // END ardemo_tracking_imports1_inner2
    
    // BEGIN ardemo_tracking_imports1_inner3
    func startTracking() {
        do {
            try tracker.startTracking { result in
                self.currentActivity = result?.name ?? "None detectable"
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            stopTracking()
        }
    }
    // END ardemo_tracking_imports1_inner3
    
    // BEGIN ardemo_tracking_imports1_inner4
    func stopTracking() {
        currentActivity = "Not Tracking"
        tracker.stopTracking()
    }
    // END ardemo_tracking_imports1_inner4
}
// END ardemo_tracking_imports1
