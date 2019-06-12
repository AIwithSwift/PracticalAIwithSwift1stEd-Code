//
//  ViewController.swift
//  BinaryImageClassifier
//
//  Created by Paris BA on 12/6/19.
//  Copyright © 2019 Paris BA. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadImageButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var classificationLabel: UILabel!
    
    lazy var classifierRequest: VNCoreMLRequest = {
        do {
            let whatsMyFruit = WhatsMyFruit()
            
            let visionModel = try VNCoreMLModel(for: whatsMyFruit.model)
            
            let request = VNCoreMLRequest(model: visionModel, completionHandler: { [weak self] request, error in self?.handleResults(for: request, error: error)
            })
            
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Argh! VNCoreMLModel: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takePhotoButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        classificationLabel.text = "Pick or take a photo!"
    }

    @IBAction func getPhoto(_ sender: UIButton) {
        var photoSource: UIImagePickerController.SourceType = .photoLibrary
        
        if(sender == takePhotoButton) {
            photoSource = .camera
        }
        
        let photoPicker = UIImagePickerController()
        
        photoPicker.delegate = self
        photoPicker.sourceType = photoSource
        present(photoPicker, animated: true)
    }
    
    func runClassifier(image: UIImage) {
        guard let coreImageImage = CIImage(image: image) else {
            print("Argh!")
            return
        }
        
        let imageOrientation = CGImagePropertyOrientation(image.imageOrientation)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: coreImageImage, orientation: imageOrientation)
            do {
                try handler.perform([self.classifierRequest])
            } catch {
                print("Argh! \(error)")
            }
        }
    }
    
    func handleResults(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results as? [VNClassificationObservation] {
                if results.isEmpty {
                    self.classificationLabel.text = "Don't see a thing!"
                } else if results[0].confidence < 0.6 {
                    self.classificationLabel.text = "Not quite sure..."
                } else {
                    self.classificationLabel.text = String(format: "%@ %.1f%%", results[0].identifier, results[0].confidence*100)
                }
            } else if let error = error {
                self.classificationLabel.text = "Error!? \(error.localizedDescription)"
            } else {
                self.classificationLabel.text = "Something really weird happened"
            }
            }
        }
    }

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let pickedImage = info[.originalImage] as! UIImage
            imageView.image = pickedImage
        
        runClassifier(image: pickedImage)
    }
}
