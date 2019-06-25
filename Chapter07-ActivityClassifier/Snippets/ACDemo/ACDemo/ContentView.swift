//
//  ContentView.swift
//  ACDemo
//
//  Created by Mars Geldard on 25/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI
import CoreMotion
import AVFoundation

extension AVSpeechSynthesizer {
    func say(_ text: String) {
        self.speak(AVSpeechUtterance(string: text))
    }
}

struct ContentView: View {
    @State var activity: CMMotionActivity? = nil
    let activityTracker = CMMotionActivityManager()
    let speechSynthesiser = AVSpeechSynthesizer()
    
    var body: some View {
        Text("\(activity?.description ?? "None detectable")")
            .font(.largeTitle)
    }
   
    func startTracking() {
        speechSynthesiser.say("Started tracking")
        do {
            try activityTracker.startTracking { result in
                if let activity = result {
                    let activityName = activity.description
                    print("New activity detected: \(activityName)")
                    self.speechSynthesiser.say(activityName)
                }
            }
        } catch {
            speechSynthesiser.say("Error: \(error.localizedDescription)")
        }
    }
    
    func stopTracking() {
        activityTracker.stopTracking()
        speechSynthesiser.say("Stopped tracking")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
