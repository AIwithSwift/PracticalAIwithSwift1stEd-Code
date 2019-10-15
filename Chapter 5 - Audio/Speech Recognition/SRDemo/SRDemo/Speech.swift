//
//  Speech.swift
//  SRDemo
//
//  Created by Mars Geldard on 18/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN SR_imports
import Speech
import AVFoundation
// END SR_imports

// BEGIN SR_class
class SpeechRecognizer {
    // BEGIN SR_class1
    private let audioEngine: AVAudioEngine
    private let session: AVAudioSession
    private let recognizer: SFSpeechRecognizer
    private let inputBus: AVAudioNodeBus
    private let inputNode: AVAudioInputNode
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var permissions: Bool = false
    // END SR_class1
    
    // BEGIN SR_class2
    init?(inputBus: AVAudioNodeBus = 0) {
        self.audioEngine = AVAudioEngine()
        self.session = AVAudioSession.sharedInstance()
        
        
        guard let recognizer = SFSpeechRecognizer() else { return nil }
        
        self.recognizer = recognizer
        self.inputBus = inputBus
        self.inputNode = audioEngine.inputNode
    }
    // END SR_class2
    
    // BEGIN SR_class3
    func checkSessionPermissions(_ session: AVAudioSession, 
        completion: @escaping (Bool) -> ()) {

        if session.responds(
            to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            session.requestRecordPermission(completion)
        }
    }
    // END SR_class3
    
    // BEGIN SR_class4
    func startRecording(completion: @escaping (String?) -> ()) {
        audioEngine.prepare()
        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults = true
        
        // BEGIN SR_class4_inner1
        // audio/microphone access permissions
        checkSessionPermissions(session) { 
            success in self.permissions = success 
        }

        guard let _ = try? session.setCategory(
                .record, 
                mode: .measurement, 
                options: .duckOthers),
            let _ = try? session.setActive(
                true,
                options: .notifyOthersOnDeactivation),
            let _ = try? audioEngine.start(),
            let request = self.request
            else {
                return completion(nil)
        }
        // END SR_class4_inner1
        
        // BEGIN SR_class4_inner2
        let recordingFormat = inputNode.outputFormat(forBus: inputBus)
        inputNode.installTap(
            onBus: inputBus, 
            bufferSize: 1024, 
            format: recordingFormat) { 
                (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.request?.append(buffer)
        }
        // END SR_class4_inner2

        // BEGIN SR_class4_inner3
        print("Started recording...")
        // END SR_class4_inner3
        
        // BEGIN SR_class4_inner4
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
        // END SR_class4_inner4
    }
    // END SR_class4
    
    // BEGIN SR_class5
    func stopRecording() {
        print("...stopped recording.")
        request?.endAudio()
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        request = nil
        task = nil
    }
    // END SR_class5
}
// END SR_class
