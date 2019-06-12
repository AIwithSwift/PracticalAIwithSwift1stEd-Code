//
//  Sentiment.swift
//  NLPDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

extension String {
    func predictSentiment() -> Sentiment {
        return [Sentiment.positive, Sentiment.negative].randomElement()!
    }
}

enum Sentiment: String, CustomStringConvertible {
    case positive = "Positive"
    case negative = "Negative"
    
    var description: String { return self.rawValue }
    
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
