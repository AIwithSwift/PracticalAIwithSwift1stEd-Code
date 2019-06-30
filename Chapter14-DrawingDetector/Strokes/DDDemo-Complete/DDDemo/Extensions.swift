//
//  Extenstions.swift
//  DDDemo
//
//  Created by Mars Geldard on 30/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

extension UiImage {
    var cgImageOrientation: CGImagePropertyOrientation {
        switch self.imageOrientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        }
    }
}

extension CGContext {
    static func create(size: CGSize, action: (inout CGContext) -> ()) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        guard var context = UIGraphicsGetCurrentContext() else { return nil }
        action(&context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

extension UIButton {
    func enable() {
        self.isEnabled = true
        self.backgroundColor = UIColor.systemBlue
    }
    
    func disable() {
        self.isEnabled = false
        self.backgroundColor = UIColor.lightGray
    }
}

extension UIBarButtonItem {
    func enable() { self.isEnabled = true }
    func disable() { self.isEnabled = false }
}
