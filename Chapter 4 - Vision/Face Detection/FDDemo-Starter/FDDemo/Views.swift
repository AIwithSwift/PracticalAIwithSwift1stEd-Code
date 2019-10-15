//
//  Views.swift
//  FDDemo
//
//  Created by Mars Geldard on 20/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI

// BEGIN FD_starter_views1
struct MainView: View {
    private let image: UIImage
    private let text: String
    private let button: TwoStateButton
    
    // BEGIN FD_starter_views1_a
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Text(text).font(.title).bold()
            Spacer()
            self.button
        }
    }
    // END FD_starter_views1_a
    
    // BEGIN FD_starter_views1_b
    init(image: UIImage, text: String, button: () -> TwoStateButton) {
        self.image = image
        self.text = text
        self.button = button()
    }
    // END FD_starter_views1_b
}
// END FD_starter_views1

// BEGIN FD_starter_views2
struct TwoStateButton: View {
    private let text: String
    private let disabled: Bool
    private let background: Color
    private let action: () -> Void
    
    // BEGIN FD_starter_views2_a
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text).font(.title).bold().foregroundColor(.white)
                Spacer()
                }.padding().background(background).cornerRadius(10)
            }.disabled(disabled)
    }
    // END FD_starter_views2_a
    
    // BEGIN FD_starter_views2_b
    init(text: String, 
        disabled: Bool, 
        background: Color = .blue, 
        action: @escaping () -> Void) {

        self.text = text
        self.disabled = disabled
        self.background = disabled ? .gray : background
        self.action = action
    }
    // END FD_starter_views2_b
}
// END FD_starter_views2

// BEGIN FD_starter_views3
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
    
    func makeUIViewController(context: Context) 
        -> UIImagePickerController {
            
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.sourceType = 
            cameraSource ? .camera : .photoLibrary

        return imagePickerController
    }
    
    func updateUIViewController(
        _ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, 
        UINavigationControllerDelegate {
            
        var parent: ImagePicker
        var completion: ((UIImage?) -> ())?
        
        init(_ imagePickerControllerWrapper: ImagePicker) {
            self.parent = imagePickerControllerWrapper
        }
        
        func imagePickerController(_ picker: UIImagePickerController, 
            didFinishPickingMediaWithInfo info: 
                [UIImagePickerController.InfoKey: Any]) {

            print("Image picker complete...")

            let selectedImage = 
                info[UIImagePickerController.InfoKey.originalImage] 
                    as? UIImage

            picker.dismiss(animated: true)
            completion?(selectedImage)
        }
        
        func imagePickerControllerDidCancel(
                _ picker: UIImagePickerController) {

            print("Image picker cancelled...")
            picker.dismiss(animated: true)
            completion?(nil)
        }
    }
}
// END FD_starter_views3

// BEGIN FD_starter_views4
extension UIImage {
    func fixOrientation() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    var cgImageOrientation: CGImagePropertyOrientation {
        switch self.imageOrientation {
            case .up: return .up
            case .down: return .down
            case .left: return .left
            case .right: return .right
            case .upMirrored: return .upMirrored
            case .downMirrored: return .downMirrored
            case .leftMirrored: return .leftMirrored
            case .rightMirrored: return .rightMirrored
        }
    }
}
// END FD_starter_views4
