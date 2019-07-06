//
//  Motion.swift
//  ACDemo
//
//  Created by Mars Geldard on 25/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//
// BEGIN ardemo_motion_import
import CoreMotion
// END ardemo_motion_import

// BEGIN ardemo_motion_ext_cmmotionactivity
extension CMMotionActivity {
    var name: String {
        if walking { return "Walking" }
        if running { return "Running" }
        if automotive { return "Driving" }
        if cycling { return "Cycling" }
        if stationary { return "Stationary" }
        return "Unknown"
    }
}
// END ardemo_motion_ext_cmmotionactivity

// typealias CMMotionActivityHandler = (CMMotionActivity?) -> Void
// BEGIN ardemo_motion_ext_cmmotam_overall
extension CMMotionActivityManager {
    // BEGIN ardemo_motion_ext_cmmotam_1
    enum Error: Swift.Error {
        case notAvailable, notAuthorized
        
        public var localizedDescription: String {
            switch self {
            case .notAvailable: return "Activity Tracking not available"
            case .notAuthorized: return "Activity Tracking not permitted"
            }
        }
    }
    // END ardemo_motion_ext_cmmotam_1
    
    // BEGIN ardemo_motion_ext_cmmotam_2
    func startTracking(handler: @escaping (CMMotionActivity?) -> Void) throws {
        if !CMMotionActivityManager.isActivityAvailable() {
            throw Error.notAvailable
        }
        
        if CMMotionActivityManager.authorizationStatus() != .authorized {
            throw Error.notAuthorized
        }
        
        self.startActivityUpdates(to: .main, withHandler: handler)
    }
    // END ardemo_motion_ext_cmmotam_2
    
    // BEGIN ardemo_motion_ext_cmmotam_3
    func stopTracking() {
        self.stopActivityUpdates()
    }
    // END ardemo_motion_ext_cmmotam_3
}
// END ardemo_motion_ext_cmmotam_overall
