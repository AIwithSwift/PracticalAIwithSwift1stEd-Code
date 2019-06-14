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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
    }
    
    private func recordAudio() {
        guard let audioRecorder = audioRecorder else { return }
        
        classification = nil
        collectionView.reloadData()
        
        recordButton.changeState(to: .inProgress(title: "Recording...", color: .systemRed))
        progressBar.isHidden = false
        
        audioRecorder.record(forDuration: TimeInterval(recordingLength))
        UIView.animate(withDuration: recordingLength) { self.progressBar.setProgress(Float(self.recordingLength), animated: true) }
    }
    
    private func finishRecording(success: Bool = true) {
        progressBar.isHidden = true
        progressBar.progress = 0
        
        if success, let audioFile = try? AVAudioFile(forReading: recordedAudioFilename) {
            recordButton.changeState(to: .disabled(title: "Record Sound", color: .systemGray))
            classifySound(file: audioFile)
        } else {
            summonAlertView()
            classify(nil)
        }
    }
    
    private func classify(_ animal: Animal?) {
        classification = animal
        recordButton.changeState(to: .enabled(title: "Record Sound", color: .systemBlue))
        collectionView.reloadData()
    }
    
    private func classifySound(file: AVAudioFile) {
        classify(Animal.allCases.randomElement()!)
    }
}

extension ViewController {
    private func summonAlertView(message: String? = nil) {
        let alertController = UIAlertController(
            title: "Error",
            message: message ?? "Action could not be completed.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
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

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Animal.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimalCell.identifier, for: indexPath) as? AnimalCell else {
            return UICollectionViewCell()
        }

        let animal = Animal.allCases[indexPath.item]
        
        cell.textLabel.text = animal.icon
        cell.backgroundColor = (animal == self.classification) ? animal.color : .systemGray
        
        return cell
    }
}

class AnimalCell: UICollectionViewCell {
    static let identifier = "AnimalCollectionViewCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var textLabel: UILabel!
}
