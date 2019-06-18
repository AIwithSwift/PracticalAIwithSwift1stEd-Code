//
//  ContentView.swift
//  SRDemo
//
//  Created by Mars Geldard on 18/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import Speech
import SwiftUI
import AVFoundation

struct ContentView : View {
    
    @State var speech: String?
    @State var recordingPermitted: Bool
    
    var body: some View {
        Text("Hello World")
    }
    
    override public func viewDidAppear(_ animated: Bool) {

        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                recordingPermitted = (authStatus == .authorized)
            }
        }
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        recordingPermitted = available
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
