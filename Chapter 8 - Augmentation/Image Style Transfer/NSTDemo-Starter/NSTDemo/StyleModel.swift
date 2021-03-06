//
//  StyleModel.swift
//  NSTDemo
//
//  Created by Mars Geldard on 4/3/19.
//  Copyright © 2019 Mars and Paris. All rights reserved.
//

// BEGIN NST_starter_stylemodel
import UIKit
import CoreML

enum StyleModel: String, CaseIterable {
    case upsideDown = "Flip Up"
    case left = "Spin Left"
    case right = "Spin RIght"
    
    // Make this a conditional to enable only certain models
    var isActive: Bool { return true } 
    
    init(index: Int) { self = StyleModel.styles[index] }
    static var styles: [StyleModel] { 
        return self.allCases.filter { style in style.isActive } 
    }
    
    var name: String { return self.rawValue }
    var styleIndex: Int { return StyleModel.styles.firstIndex(of: self)! }
}
// END NST_starter_stylemodel
