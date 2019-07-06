//
//  Views.swift
//  ISDemo
//
//  Created by Mars Geldard on 18/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN IS_views_import
import SwiftUI
// END IS_views_import

// BEGIN IS_views_ori
struct OptionalResizableImage: View {
    private let image: UIImage?
    private let placeholder: UIImage
    
    var body: some View {
        if let image = image {
            return Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
        } else {
            return Image(uiImage: placeholder).resizable().aspectRatio(contentMode: .fit)
        }
    }
}
// END IS_views_ori

// BEGIN IS_views_bl
struct ButtonLabel: View {
    private let text: String
    private let background: Color
    
    var body: some View {
        HStack {
            Spacer()
            Text(text).font(.title).bold().color(.white)
            Spacer()
            }.padding().background(background).cornerRadius(10)
    }
    
    init(_ text: String, background: Color) {
        self.text = text
        self.background = background
    }
}
// END IS_views_bl

// BEGIN IS_views_ipv
struct ImagePickerView: View {
    private let completion: (UIImage?) -> ()
    private let camera: Bool
    
    var body: some View {
        ImagePickerControllerWrapper(camera: camera, completion: completion)
    }
    
    init(camera: Bool = false, completion: @escaping (UIImage?) -> ()) {
        self.completion = completion
        self.camera = camera
    }
}
// END IS_views_ipv

// BEGIN IS_views_ipcw
struct ImagePickerControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    private(set) var selectedImage: UIImage?
    private(set) var cameraSource: Bool
    private let completion: (UIImage?) -> ()
    
    init(camera: Bool, completion: @escaping (UIImage?) -> ()) {
        self.cameraSource = camera
        self.completion = completion
    }
    
    func makeCoordinator() -> ImagePickerControllerWrapper.Coordinator {
        let coordinator = Coordinator(self)
        coordinator.completion = self.completion
        return coordinator
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.sourceType = cameraSource ? .camera : .photoLibrary
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //uiViewController.setViewControllers(?, animated: true)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerControllerWrapper
        var completion: ((UIImage?) -> ())?
        
        init(_ imagePickerControllerWrapper: ImagePickerControllerWrapper) {
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
// END IS_views_ipcw

// BEGIN IS_views_uii
extension UIImage {
    func fixOrientation() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
// END IS_views_uii
