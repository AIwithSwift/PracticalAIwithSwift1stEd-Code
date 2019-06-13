//
//  ViewController.swift
//  ICDemo
//
//  Created by Paris BA on 12/6/19.
//  Copyright © 2019 Paris BA. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos


class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var classifyImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func selectButtonPressed(_ sender: Any) { getPhoto() }
    @IBAction func cameraButtonPressed(_ sender: Any) { getPhoto(cameraSource: true) }
    @IBAction func classifyImageButtonPressed(_ sender: Any) { classifyImage() }
    
    // BEGIN im_class_ai_newvar
    private let classifier = VisionClassifier(mlmodel: WhatsMyFruit().model)
    // END im_class_ai_newvar
    private var inputImage: UIImage?
    var classification: String?
    
    // MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.placeholder
        // BEGIN im_class_ai_vdl
        classifier?.delegate = self
        refresh()
        // END im_class_ai_vdl
    }
    
    /// Disables and enables controls based on presence of input to categorise
    func refresh() {
        if inputImage == nil {
            classLabel.text = "Pick or take a photo!"
            imageView.image = UIImage.placeholder
            // BEGIN im_class_ai_refresh
            classifyImageButton.disable()
            // END im_class_ai_refresh
        } else {
            imageView.image = inputImage
            
            if classification == nil {
                classLabel.text = "None"
                classifyImageButton.enable()
            } else {
                classLabel.text = classification
                classifyImageButton.disable()
            }
        }
    }
    
    // MARK: Functionality
    // BEGIN im_class_ai_classifyImage
    private func classifyImage() {
        if let classifier = self.classifier, let image = inputImage {
            classifier.classify(image)
            classifyImageButton.disable()
        }
    }
    // END im_class_ai_classifyImage
}

extension ViewController: UINavigationControllerDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate {
    
    private func getPhoto(cameraSource: Bool = false) {
        let photoSource: UIImagePickerController.SourceType
        photoSource = cameraSource ? .camera : .photoLibrary
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = photoSource
        imagePicker.mediaTypes = [kUTTypeImage as String]
        present(imagePicker, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        inputImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        classification = nil
        
        picker.dismiss(animated: true)
        refresh()
        
        if inputImage == nil {
            summonAlertView(message: "Image was malformed.")
        }
    }
    
    func summonAlertView(message: String? = nil) {
        let alertController = UIAlertController(
            title: "Error",
            message: message ?? "Action could not be completed.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

