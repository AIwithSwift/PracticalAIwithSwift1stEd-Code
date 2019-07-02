//
//  Sentiment.swift
//  CTDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import NaturalLanguage

extension String {
    func predictSentiment() -> Sentiment {
        if self.isEmpty { return .neutral }
        let classString = ReviewTagger.prediction(for: self) ?? ""
        return Sentiment(rawValue: classString)
    }
}

enum Sentiment: String, CustomStringConvertible {
    case positive = "Positive"
    case negative = "Negative"
    case neutral = "None"
    
    var description: String { return self.rawValue }
    
    var icon: String {
        switch self {
            case .positive: return "😄"
            case .negative: return "😢"
            default: return "😐"
        }
    }
    
    var color: UIColor {
        switch self {
            case .positive: return UIColor.systemGreen
            case .negative: return UIColor.systemRed
            default: return UIColor.systemGray
        }
    }

    init(rawValue: String) {
        // initialising RawValues must match class labels in training files
        switch rawValue {
            case "POSITIVE": self = .positive
            case "NEGATIVE": self = .negative
            default: self = .neutral
        }
    }
}
