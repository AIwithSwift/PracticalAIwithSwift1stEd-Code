//
//  Sentiment.swift
//  NLPDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import NaturalLanguage

extension String {
    // BEGIN nlp_new_predictSentiment
    func predictSentiment(with nlModel: NLModel) -> Sentiment {
        if self.isEmpty { return .neutral }
        let classString = nlModel.predictedLabel(for: self) ?? ""
        return Sentiment(rawValue: classString)
    }
    // END nlp_new_predictSentiment
}

enum Sentiment: String, CustomStringConvertible {
    // BEGIN nlp_mods1
    case positive = "Positive"
    case negative = "Negative"
    case neutral = "None"
    // END nlp_mods1
    
    var description: String { return self.rawValue }
    
    // BEGIN nlp_mods2
    var icon: String {
        switch self {
            case .positive: return "😄"
            case .negative: return "😢"
            default: return "😐"
        }
    }
    // END nlp_mods2
    
    // BEGIN nlp_mods3
    var color: UIColor {
        switch self {
            case .positive: return UIColor.systemGreen
            case .negative: return UIColor.systemRed
            default: return UIColor.systemGray
        }
    }
    // END nlp_mods3

    // BEGIN nlp_mods4
    init(rawValue: String) {
        // initialising RawValues must match class labels in training files
        switch rawValue {
            case "Pos": self = .positive
            case "Neg": self = .negative
            default: self = .neutral
        }
    }
    // END nlp_mods4
}
