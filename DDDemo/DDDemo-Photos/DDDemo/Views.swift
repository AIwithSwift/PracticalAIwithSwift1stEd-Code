//
//  Views.swift
//  DDDemo
//
//  Created by Mars Geldard on 22/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI

// BEGIN ddd_views_mainview
struct MainView: View {
    private let image: UIImage
    private let text: String
    private let button: TwoStateButton
    
    var body: some View {
        VStack {
            Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
            Spacer()
            Text(text).font(.title).bold()
            Spacer()
            self.button
        }
    }
    
    init(image: UIImage, text: String, button: () -> TwoStateButton) {
        self.image = image
        self.text = text
        self.button = button()
    }
}
// END ddd_views_mainview

// BEGIN ddd_views_tsb
struct TwoStateButton: View {
    private let text: String
    private let disabled: Bool
    private let background: Color
    private let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text).font(.title).bold().color(.white)
                Spacer()
                }.padding().background(background).cornerRadius(10)
            }.disabled(disabled)
    }
    
    init(text: String, disabled: Bool, background: Color = .blue, action: @escaping () -> Void) {
        self.text = text
        self.disabled = disabled
        self.background = disabled ? .gray : background
        self.action = action
    }
}
// END ddd_views_tsb

// BEGIN ddd_views_imagepicker
struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    private(set) var selectedImage: UIImage?
    private(set) var cameraSource: Bool
    private let completion: (UIImage?) -> ()
    
    init(camera: Bool = false, completion: @escaping (UIImage?) -> ()) {
        self.cameraSource = camera
        self.completion = completion
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        let coordinator = Coordinator(self)
        coordinator.completion = self.completion
        return coordinator
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.sourceType = cameraSource ? .camera : .photoLibrary
        imagePickerController.allowsEditing = true
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        var completion: ((UIImage?) -> ())?
        
        init(_ imagePickerControllerWrapper: ImagePicker) {
            self.parent = imagePickerControllerWrapper
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            print("Image picker complete...")
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            picker.dismiss(animated: true)
            completion?(selectedImage)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Image picker cancelled...")
            picker.dismiss(animated: true)
            completion?(nil)
        }
    }
}
/// END ddd_views_imagepicker

