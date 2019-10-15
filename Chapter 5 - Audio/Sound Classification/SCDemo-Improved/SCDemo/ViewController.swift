//
//  ViewController.swift
//  SCDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import AVFoundation
import SoundAnalysis

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
            // BEGIN SC_improved_inProgressCase
            case .inProgress(let title, let color):
                self.setTitle(title, for: .normal)
                self.backgroundColor = color
                self.isEnabled = true
            // END SC_improved_inProgressCase
            case .disabled(let title, let color):
                self.setTitle(title, for: .disabled)
                self.backgroundColor = color
                self.isEnabled = false
        }
    }
}

class ViewController: UIViewController {
    // BEGIN SC_improved_attributes
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var recordButton: ThreeStateButton!
    
    @IBAction func recordButtonPressed(_ sender: Any) { toggleRecording() }
    
    private var recording: Bool = false
    private var classification: Animal?
    private let classifier = AudioClassifier(model: AnimalSounds().model)
    // END SC_improved_attributes

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
    }
    
    private func refresh(clear: Bool = false) {
        if clear { classification = nil }
        collectionView.reloadData()
    }
    
    // BEGIN SC_improved_toggleRecording
    private func toggleRecording() {
        recording = !recording
        
        if recording {
            refresh(clear: true)
            recordButton.changeState(to: 
                .inProgress(
                    title: "Stop", 
                    color: .systemRed
                )
            )
            classifier?.beginAnalysis { result in
                self.classify(Animal(rawValue: result ?? ""))
            }
        } else {
            refresh()
            recordButton.changeState(
                to: .enabled(
                    title: "Record Sound", 
                    color: .systemBlue
                )
            )
            classifier?.stopAnalysis()
        }
    }
    // END SC_improved_toggleRecording
    
    // BEGIN SC_improved_classify
    private func classify(_ animal: Animal?) {
        classification = animal
        refresh()
    }
    // END SC_improved_classify
}

extension ViewController {
    private func summonAlertView(message: String? = nil) {
        let alertController = UIAlertController(
            title: "Error",
            message: message ?? "Action could not be completed.",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "OK", 
                style: .default
            )
        )

        present(alertController, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, 
        numberOfItemsInSection section: Int) -> Int {

        return Animal.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = 
            collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimalCell.identifier, 
                for: indexPath) as? AnimalCell else {

                return UICollectionViewCell()
        }

        let animal = Animal.allCases[indexPath.item]
        
        cell.textLabel.text = animal.icon
        cell.backgroundColor = 
            (animal == self.classification) ? animal.color : .systemGray
        
        return cell
    }
}

class AnimalCell: UICollectionViewCell {
    static let identifier = "AnimalCollectionViewCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var textLabel: UILabel!
}
