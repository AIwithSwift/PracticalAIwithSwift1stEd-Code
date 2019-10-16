//
//  StyleModel.swift
//  NSTDemo
//
//  Created by Mars Geldard on 4/3/19.
//  Copyright © 2019 Mars and Paris. All rights reserved.
//

// BEGIN NST_complete_stylemodelswift
import UIKit
import CoreML

enum StyleModel: String, CaseIterable {
    
    // List models (named whatever you like) and their names to display in
    // the app
    //
    // These must be in the order they were input into training (likely
    // alphabetical in filename)
    case abstract = "Abstract"
    case apples = "Apples"
    case brick = "Brick"
    case flower = "Flower"
    case foliage = "Foliage"
    case honeycomb = "Honeycomb"
    case mosaic = "Mosaic"
    case nebula = "Nebula"
    
    // Rename this to your own .mlmodel file name
    var model: StyleTransferModel { return StyleTransferModel() } 

    // Change if your own model has different constraints
    var constraints: CGSize { return CGSize(width: 800, height: 800) } 

    // Make this a conditional to enable only certain models
    var isActive: Bool { return true } 
    
    init(index: Int) { self = StyleModel.styles[index] }

    static var styles: [StyleModel] { 
        return self.allCases.filter { style in style.isActive }
    }
    
    var name: String { return self.rawValue }

    var styleIndex: Int { return StyleModel.styles.firstIndex(of: self)! }

    var styleArray: MLMultiArray { 
        return MLMultiArray(
            size: StyleModel.allCases.count, 
            selecting: self.styleIndex)
    }
}
// END NST_complete_stylemodelswift
