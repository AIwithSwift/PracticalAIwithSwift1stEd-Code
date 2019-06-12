//
//  Sentiment.swift
//  NLPDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

enum Sentiment: String, CustomStringConvertible {
    // String RawValues must match class labels in training files
    case positive = "Pos"
    case negative = "Neg"
    
    var description: String {
        switch self {
            case .positive: return "Positive"
            case .negative: return "Negative"
        }
    }
    
    var icon: String {
        switch self {
            case .positive: return "😄"
            case .negative: return "😢"
        }
    }
    
    var color: UIColor {
        switch self {
            case .positive: return UIColor.systemGreen
            case .negative: return UIColor.systemRed
        }
    }
}
