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


class ViewController: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var classifyImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func selectButtonPressed(_ sender: Any) { getPhoto() }
    @IBAction func cameraButtonPressed(_ sender: Any) { getPhoto(cameraSource: true) }
    @IBAction func classifyImageButtonPressed(_ sender: Any) { classifyImage() }
    
    private var inputImage: UIImage?
    private var classification: String?
    
    // MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage.placeholder
    }
    
    /// Disables and enables controls based on presence of input to Categorise
    private func refresh() {
        if inputImage == nil {
            classLabel.text = "Pick or take a photo!"
            imageView.image = UIImage.placeholder
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
    
    // MARK: Supplementary View Functions
    
    @objc private func getPhoto(cameraSource: Bool = false) {
        let photoSource: UIImagePickerController.SourceType
        photoSource = cameraSource ? .camera : .photoLibrary
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = photoSource
        imagePicker.mediaTypes = [kUTTypeImage as String]
        present(imagePicker, animated: true)
    }
    
    private func summonAlertView(message: String? = nil) {
        let alertController = UIAlertController(
            title: "Error",
            message: message ?? "Action could not be completed.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    // MARK: Functionality
    
    private func classifyImage() {
        classification = "FRUIT!"
        
        refresh()
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        inputImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        classification = nil
        
        picker.dismiss(animated: true)
        refresh()
        
        if inputImage == nil {
            summonAlertView(message: "Image was malformed.")
        }
    }
}

