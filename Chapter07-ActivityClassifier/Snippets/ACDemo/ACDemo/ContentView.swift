//
//  ContentView.swift
//  ACDemo
//
//  Created by Mars Geldard on 25/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI
import AVFoundation

extension AVSpeechSynthesizer {
    func say(_ text: String) {
        self.speak(AVSpeechUtterance(string: text))
    }
}

struct ContentView: View {
    @EnvironmentObject var tracker: ActivityTracker
    private let speechSynthesiser = AVSpeechSynthesizer()
    
    var body: some View {
        let newActivity = tracker.currentActivity
        if tracker.activityDidChange {
            speechSynthesiser.say(newActivity)
        }
        
        return Text(newActivity).font(.largeTitle)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
