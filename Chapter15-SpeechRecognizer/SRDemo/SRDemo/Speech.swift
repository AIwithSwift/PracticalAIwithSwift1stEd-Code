//
//  Speech.swift
//  SRDemo
//
//  Created by Mars Geldard on 18/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import Speech
import AVFoundation

class SpeechRecognizer {
    private let audioEngine: AVAudioEngine
    private let audioSession: AVAudioSession
    private let recognizer: SFSpeechRecognizer
    private let inputBus: AVAudioNodeBus
    private let inputNode: AVAudioInputNode
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    
    init?(inputBus: AVAudioNodeBus = 0) {
        self.audioEngine = AVAudioEngine()
        self.audioSession = AVAudioSession.sharedInstance()
        
        guard let _ = try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers), let _ = try? audioSession.setActive(true, options: .notifyOthersOnDeactivation),
            let recognizer = SFSpeechRecognizer() else {
            return nil
        }
        
        self.recognizer = recognizer
        self.inputBus = inputBus
        self.inputNode = audioEngine.inputNode
    }
    
    func startRecording(completion: @escaping (String?) -> ()) {
        audioEngine.prepare()
        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults = true
        
        guard let _ = try? audioEngine.start() else { return completion(nil) }
        guard let request = self.request else { return completion(nil) }
        
        let recordingFormat = inputNode.outputFormat(forBus: inputBus)
        inputNode.installTap(onBus: inputBus, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.request?.append(buffer)
        }

        print("Started recording...")
        
        task = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                let transcript = result.bestTranscription.formattedString
                print("Heard: \"\(transcript)\"")
                completion(transcript)
            }
            
            if error != nil || result?.isFinal == true {
                self.stopRecording()
                completion(nil)
            }
        }
    }
    
    func stopRecording() {
        print("...stopped recording.")
        request?.endAudio()
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        request = nil
        task = nil
    }
}
