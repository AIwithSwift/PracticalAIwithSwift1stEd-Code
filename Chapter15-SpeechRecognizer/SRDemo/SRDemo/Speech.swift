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
    private let session: AVAudioSession
    private let recognizer: SFSpeechRecognizer
    private let inputBus: AVAudioNodeBus
    private let inputNode: AVAudioInputNode
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var permissions: Bool = false
    
    init?(inputBus: AVAudioNodeBus = 0) {
        self.audioEngine = AVAudioEngine()
        self.session = AVAudioSession.sharedInstance()
        
        
        guard let recognizer = SFSpeechRecognizer() else { return nil }
        
        self.recognizer = recognizer
        self.inputBus = inputBus
        self.inputNode = audioEngine.inputNode
    }
    
    func checkSessionPermissions(_ session: AVAudioSession, completion: @escaping (Bool) -> ()) {
        if session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            session.requestRecordPermission(completion)
        }
    }
    
    func startRecording(completion: @escaping (String?) -> ()) {
        audioEngine.prepare()
        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults = true
        
        // audio/microphone access permissions
        checkSessionPermissions(session) { success in self.permissions = success }
        guard let _ = try? session.setCategory(.record, mode: .measurement, options: .duckOthers),
            let _ = try? session.setActive(true, options: .notifyOthersOnDeactivation),
            let _ = try? audioEngine.start(),
            let request = self.request
            else {
                return completion(nil)
        }
        
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
