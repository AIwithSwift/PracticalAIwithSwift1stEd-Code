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

extension CMMotionActivity {
    var name: String {
        if walking { return "Walking" }
        if running { return "Running" }
        if automotive { return "Driving" }
        if cycling { return "Cycling" }
        if stationary { return "Stationary" }
        return "Unknown"
    }
}

struct ContentView: View {
    @State var activity: String? = nil
    let activityTracker = CMMotionActivityManager()
    let speechSynthesiser = AVSpeechSynthesizer()
    
    var body: some View {
        Text("\(activity?.description ?? "None detectable")")
            .font(.largeTitle)
    }
    
    private func updateActivity(_ activity: CMMotionActivity?) {
        if let activity = activity?.name {
             self.activity = activity
        } else {
            self.activity = nil
        }
    }
   
    func startTracking() {
        speechSynthesiser.say("Started tracking")
        do {
            try activityTracker.startTracking { result in
                self.updateActivity(result)
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
