//
//  ContentView.swift
//  ACDemo
//
//  Created by Mars Geldard on 25/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN ardemo_contentview_import
import SwiftUI
import AVFoundation
// END ardemo_contentview_import

// BEGIN ardemo_contentview_ex_avss
extension AVSpeechSynthesizer {
    func say(_ text: String) {
        self.speak(AVSpeechUtterance(string: text))
    }
}
// END ardemo_contentview_ex_avss

// BEGIN ardemo_contentview_contentview
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
// END ardemo_contentview_contentview

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
