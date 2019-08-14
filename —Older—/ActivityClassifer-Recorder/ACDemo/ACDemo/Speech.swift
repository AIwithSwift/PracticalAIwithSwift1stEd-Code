//
//  Speech.swift
//  ACDemo
//
//  Created by Mars Geldard on 21/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import AVFoundation

extension AVSpeechSynthesizer {
    func say(_ text: String) {
        self.speak(AVSpeechUtterance(string: text))
    }
}
