//
//  ViewController.swift
//  BinaryImageClassifier
//
//  Created by Paris BA on 12/6/19.
//  Copyright © 2019 Paris BA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadImageButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var classificationLabel: UILabel!
    
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
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let pickedImage = info[.originalImage] as! UIImage
            imageView.image = pickedImage
        
        // TODO: classify here
    }
}
