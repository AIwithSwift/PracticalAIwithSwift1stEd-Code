//
//  Utils.swift
//  ICDemo
//
//  Created by Mars Geldard on 4/3/19.
//  Copyright © 2019 Mars and Paris. All rights reserved.
//
// BEGIN im_class_utils
import UIKit

extension UIImage{
    static let placeholder = UIImage(named: "placeholder.png")!
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
// END im_class_utils
