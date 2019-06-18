//
//  Speech.swift
//  SRDemo
//
//  Created by Mars Geldard on 18/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import Speech
import AVFoundation

class SpeechRecorder {
    private let audioEngine = AVAudioEngine()
    private let audioSession = AVAudioSession.sharedInstance()
    private let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private let recognizer: SFSpeechRecognizer
    private let inputBus: AVAudioNodeBus
    
    init?(inputBus: AVAudioNodeBus = 0) {
        guard let recognizer = SFSpeechRecognizer() else { return nil }
        
        self.recognizer = recognizer
        self.inputBus = inputBus
        
        self.recognitionRequest.shouldReportPartialResults = true

        do {
            // Configure the audio session for the app
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = audioEngine.inputNode

            
            // Configure the microphone input
            let recordingFormat = inputNode.outputFormat(forBus: inputBus)
            inputNode.installTap(onBus: inputBus, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest.append(buffer)
            }
        } catch {
            return nil
        }

        

        
//        audioEngine.prepare()
//        try audioEngine.start()
    }
    
    func startRecording() {
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        let recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("Text \(result.bestTranscription.formattedString)")
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
    }
}
