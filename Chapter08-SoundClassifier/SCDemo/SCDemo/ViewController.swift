//
//  ViewController.swift
//  SCDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import AVFoundation

class ThreeStateButton: UIButton {
    
    enum ButtonState {
        case enabled(title: String, color: UIColor)
        case inProgress(title: String, color: UIColor)
        case disabled(title: String, color: UIColor)
    }
    
    func changeState(to state: ThreeStateButton.ButtonState) {
        switch state {
            case .enabled(let title, let color):
                self.setTitle(title, for: .normal)
                self.backgroundColor = color
                self.isEnabled = true
            case .inProgress(let title, let color):
                self.setTitle(title, for: .disabled)
                self.backgroundColor = color
                self.isEnabled = false
            case .disabled(let title, let color):
                self.setTitle(title, for: .disabled)
                self.backgroundColor = color
                self.isEnabled = false
        }
    }
}

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var recordButton: ThreeStateButton!
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        recordAudio()
    }
    
    private var recordingLength: Double = 5.0
    private var classification: Animal?
    private lazy var audioRecorder: AVAudioRecorder? = { return initialiseAudioRecorder() }()
    private lazy var recordedAudioFilename: URL = {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("recording.m4a")
    }()
    
    private func recordAudio() {
        guard let audioRecorder = audioRecorder else { return }
        // TODO display error
        
        recordButton.changeState(to: .inProgress(title: "Recording...", color: .systemRed))
        progressBar.isHidden = false
        
        audioRecorder.record(forDuration: TimeInterval(recordingLength))
        UIView.animate(withDuration: recordingLength) { self.progressBar.setProgress(Float(self.recordingLength), animated: true) }
    }
    
    private func finishRecording(success: Bool = true) {
        progressBar.isHidden = true
        progressBar.progress = 0
        
        if success, let audioFile = try? AVAudioFile(forReading: recordedAudioFilename) {
            recordButton.changeState(to: .disabled(title: "Record Audio", color: .systemGray))
            classifySound(file: audioFile)
        } else {
            // TODO display error
            recordButton.changeState(to: .enabled(title: "Record Audio", color: .systemBlue))
        }
    }
    
    private func update() {
        recordButton.changeState(to: .enabled(title: "Record Audio", color: .systemBlue))
    }
    
    private func classifySound(file: AVAudioFile) {
        classification = Animal.allCases.randomElement()
        print(classification)
        update()
    }
}

extension ViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        finishRecording(success: flag)
    }
    
    private func initialiseAudioRecorder() -> AVAudioRecorder? {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let recorder = try? AVAudioRecorder(url: recordedAudioFilename, settings: settings)
        recorder?.delegate = self
        return recorder
    }
}

