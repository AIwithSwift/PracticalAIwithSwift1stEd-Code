//
//  Extenstions.swift
//  DDDemo
//
//  Created by Mars Geldard on 30/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN dd_new_extensions_import
import UIKit
// END dd_new_extensions_import

// BEGIN dd_new_extensions_cgcontext
extension CGContext {
    static func create(size: CGSize, 
        action: (inout CGContext) -> ()) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        guard var context = UIGraphicsGetCurrentContext() else { 
            return nil 
        }

        action(&context)

        let result = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return result
    }
}
// END dd_new_extensions_cgcontext

// BEGIN dd_new_extensions_uibutton
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
// END dd_new_extensions_uibutton

// BEGIN dd_new_extensions_uibarbuttonitem
extension UIBarButtonItem {
    func enable() { self.isEnabled = true }
    func disable() { self.isEnabled = false }
}
// END dd_new_extensions_uibarbuttonitem
