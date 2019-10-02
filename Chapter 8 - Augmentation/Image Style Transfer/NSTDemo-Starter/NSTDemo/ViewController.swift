//
//  ViewController.swift
//  NSTDemo
//
//  Created by Paris BA on 4/3/19.
//  Copyright © 2019 Mars and Paris. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos


class ViewController: UIViewController {
    
    // MARK: Outlets
    // BEGIN NST_starter_outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var modelSelector: UIPickerView!
    @IBOutlet weak var transferStyleButton: UIButton!
    // END NST_starter_outlets
    
    // MARK: Actions
    
    // BEGIN NST_starter_actions
    @IBAction func selectButtonPressed(_ sender: Any) { summonImagePicker() }
    @IBAction func shareButtonPressed(_ sender: Any) {summonShareSheet() }
    @IBAction func transferStyleButtonPressed(_ sender: Any) { performStyleTransfer() }
    // END NST_starter_actions

    // BEGIN NST_starter_attributes
    private var inputImage: UIImage?
    private var outputImage: UIImage?
    private var modelSelection: StyleModel {
        let selectedModelIndex = modelSelector.selectedRow(inComponent: 0)
        return StyleModel(index: selectedModelIndex)
    }
    // END NST_starter_attributes
    
    // MARK: View Functions
    // BEGIN NST_starter_vdl
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelSelector.delegate = self
        modelSelector.dataSource = self
        imageView.contentMode = .scaleAspectFill
    
        refresh()
    }
    // END NST_starter_vdl
    
    /// Disables and enables controls based on presence of input to Style Transfer and output to Share
    ///
    /// `if (input but no output) then  { enable NST function }`
    /// `else if (input and output) then { enable NST and Share function }`
    /// `else if (no input) then { disable both }`
    // BEGIN NST_starter_refresh
    private func refresh() {
        switch (inputImage == nil, outputImage == nil) {
            case (false, false): imageView.image = outputImage
                transferStyleButton.enable()
                shareButton.enable()
            
            case (false, true): imageView.image = inputImage
                transferStyleButton.enable()
                shareButton.disable()
            
            default: imageView.image = UIImage.placeholder
                transferStyleButton.disable()
                shareButton.disable()
        }
    }
    // END NST_starter_refresh
    
    // MARK: Functionality
    // BEGIN NST_starter_pstfunc
    private func performStyleTransfer() {
        outputImage = inputImage?.styled(with: modelSelection)
        
        if outputImage == nil {
            summonAlertView()
        }
        
        refresh()
    }
    // END NST_starter_pstfunc
}

// BEGIN NST_starter_ext_uincd
extension ViewController: UINavigationControllerDelegate {
    private func summonShareSheet() {
        guard let outputImage = outputImage else {
            summonAlertView()
            return
        }
        
        let shareSheet = UIActivityViewController(activityItems: [outputImage as Any], applicationActivities: nil)
        present(shareSheet, animated: true)
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
}
// END NST_starter_ext_uincd

// BEGIN NST_starter_ext_uiipcd
extension ViewController: UIImagePickerControllerDelegate {
    private func summonImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        present(imagePicker, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        inputImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        outputImage = nil

        picker.dismiss(animated: true)
        refresh()
        
        if inputImage == nil {
            summonAlertView(message: "Image was malformed.")
        }
    }
}
// END NST_starter_ext_uiipcd

// BEGIN NST_starter_ext_uipvd
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StyleModel.styles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return StyleModel(index: row).name
    }
}
// END NST_starter_ext_uipvd
