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

struct ContentView: View {
    
    @State var recording: Bool = false
    @State var speech: String = ""
    
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
    
    private let recognizer: SpeechRecognizer

    init() {
        guard let recognizer = SpeechRecognizer() else { fatalError("Something went wrong...") }
        self.recognizer = recognizer
    }
    
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
    
    private func stopRecording() {
        self.recording = false
        recognizer.stopRecording()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
