//
//  Animals.swift
//  SCDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

// BEGIN animalsdotswift
enum Animal: String, CaseIterable {
    // BEGIN adotswift1
    case dog, pig, cow, frog, cat, insects, sheep, crow, chicken
    // END adotswift1
    
    // BEGIN adotswift2
    init?(rawValue: String) {
        if let match = Self.allCases
            .first(where: { $0.rawValue == rawValue }) {
            self = match
        } else if rawValue == "rooster" || rawValue == "hen" {
            self = .chicken
        } else {
            return nil
        }
    }
    // END adotswift2
    
    // BEGIN adotswift3
    var icon: String {
        switch self {
            case .dog: return "🐶"
            case .pig: return "🐷"
            case .cow: return "🐮"
            case .frog: return "🐸"
            case .cat: return "🐱"
            case .insects: return "🐝"
            case .sheep: return "🐑"
            case .crow: return "🐦"
            case .chicken: return "🐔"
        }
    }
    // END adotswift3
    
    // BEGIN adotswift4
    var color: UIColor {
        switch self {
            case .dog: return .systemRed
            case .pig: return .systemBlue
            case .cow: return .systemOrange
            case .frog: return .systemYellow
            case .cat: return .systemTeal
            case .insects: return .systemPink
            case .sheep: return .systemPurple
            case .crow: return .systemGreen
            case .chicken: return .systemIndigo
        }
    }
    // END adotswift4
}
// END animalsdotswift
