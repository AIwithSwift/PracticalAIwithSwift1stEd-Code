//
//  ContentView.swift
//  SRDemo
//
//  Created by Mars Geldard on 18/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN SR_view_imports
import Speech
import SwiftUI
import AVFoundation
// END SR_view_imports

// BEGIN SR_view_buttonlabel
struct ButtonLabel: View {
    private let title: String
    private let background: Color
    
    var body: some View {
        HStack {
            Spacer()
            Text(title).font(.title).bold().color(.white)
            Spacer()
        }.padding().background(background).cornerRadius(10)
    }
    
    init(_ title: String, background: Color) {
        self.title = title
        self.background = background
    }
}
// END SR_view_buttonlabel

// BEGIN SR_view_contentview
struct ContentView: View {
    
    // BEGIN SR_view_contentview1
    @State var recording: Bool = false
    @State var speech: String = ""
    // END SR_view_contentview1
    
    // BEGIN SR_view_contentview2
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if !speech.isEmpty {
                    Text(speech).font(.largeTitle).lineLimit(nil)
                } else {
                    Text("Speech will go here...").font(.largeTitle).color(.gray).lineLimit(nil)
                }

                Spacer()

                if recording {
                    Button(action: stopRecording) {
                        ButtonLabel("Stop Recording", background: .red)
                    }
                } else {
                    Button(action: startRecording) {
                        ButtonLabel("Start Recording", background: .blue)
                    }
                }
            }.padding()
            .navigationBarTitle(Text("SRDemo"), displayMode: .inline)
        }
    }
    // END SR_view_contentview2
    
    // BEGIN SR_view_contentview3
    private let recognizer: SpeechRecognizer
    // END SR_view_contentview3
    
    // BEGIN SR_view_contentview4
    init() {
        guard let recognizer = SpeechRecognizer() else { fatalError("Something went wrong...") }
        self.recognizer = recognizer
    }
    // END SR_view_contentview4
    
    // BEGIN SR_view_contentview5
    private func startRecording() {        
        self.recording = true
        self.speech = ""
        
        recognizer.startRecording { result in
            if let text = result {
                self.speech = text
            } else {
                self.stopRecording()
            }
        }
    }
    // END SR_view_contentview5
    
    // BEGIN SR_view_contentview6
    private func stopRecording() {
        self.recording = false
        recognizer.stopRecording()
    }
    // END SR_view_contentview6
}
// END SR_view_contentview

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
