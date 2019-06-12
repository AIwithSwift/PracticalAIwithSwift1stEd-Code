//
//  Animals.swift
//  SCDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

enum Animal: String {
    case dog, pig, cow, frog, cat, insects, sheep, crow, rooster, hen
    
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
            default: return "🐔"
        }
    }
}
