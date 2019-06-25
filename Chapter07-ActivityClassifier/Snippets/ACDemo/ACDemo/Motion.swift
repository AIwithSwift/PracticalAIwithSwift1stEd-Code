//
//  Motion.swift
//  ACDemo
//
//  Created by Mars Geldard on 25/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//
import CoreMotion

// typealias CMMotionActivityHandler = (CMMotionActivity?) -> Void
extension CMMotionActivityManager {
    
    enum Error: Swift.Error {
        case notAvailable, notAuthorized
        
        public var localizedDescription: String {
            switch self {
            case .notAvailable: return "Activity Tracking not available"
            case .notAuthorized: return "Activity Tracking not permitted"
            }
        }
    }
    
    func startTracking(handler: @escaping (CMMotionActivity?) -> Void) throws {
        if !CMMotionActivityManager.isActivityAvailable() {
            throw Error.notAvailable
        }
        
        if CMMotionActivityManager.authorizationStatus() != .authorized {
            throw Error.notAuthorized
        }
        
        self.startActivityUpdates(to: .main, withHandler: handler)
    }
    
    func stopTracking() {
        self.stopActivityUpdates()
    }
}
