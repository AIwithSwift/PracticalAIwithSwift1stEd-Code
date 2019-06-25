//
//  ContentView.swift
//  DDDemo
//
//  Created by Mars Geldard on 22/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI
import Vision

extension VNImageRequestHandler {
    convenience init?(uiImage: UIImage) {
        guard let ciImage = CIImage(image: uiImage) else { return nil }
        let orientation = uiImage.cgImageOrientation
        
        self.init(ciImage: ciImage, orientation: orientation)
    }
}

class DrawingClassifier {
    let imageSize = CGSize(width: 28.0, height: 28.0)
    func configure(image: UIImage?) -> UIImage? {
        if let rotatedImage = image?.fixOrientation(),
            let resizedImage = rotatedImage.aspectFilled(to: self.imageSize),
            let grayscaleImage = resizedImage.applying(filter: CIFilter.noir) {
            return grayscaleImage
        }
        
        return nil
    }
    
    func classify(_ image: UIImage?, completion: (Drawing?) -> ()) {
        guard let image = image,
            let model = try? VNCoreMLModel(for: self.model) else {
                return completion(nil)
        }
        
        let request = VNCoreMLRequest(model: model)
            
        DispatchQueue.global(qos: .userInitiated).async {
            if let handler = VNImageRequestHandler(uiImage: image) {
                try? handler.perform([request])
                let results = request.results as? [VNClassificationObservation]
                let highestResult = results?.max { $0.confidence > $1.confidence }
                completion(Drawing(rawValue: highestResult?.identifier ?? ""))
            } else {
                completion(nil)
            }
        }
    }
}

struct ContentView: View {
    @State private var imagePickerOpen: Bool = false
    @State private var cameraOpen: Bool = false
    @State private var image: UIImage? = nil
    @State private var classification: String? = nil
    
    private let placeholderImage = UIImage(named: "placeholder")!
    private let classifier = DrawingClassifier()
    private var cameraEnabled: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }
    private var classificationEnabled: Bool { image != nil && classification == nil }
    
    var body: some View {
        if imagePickerOpen { return imagePickerView() }
        if cameraOpen { return cameraView() }
        return mainView()
    }
    
    private func classify() {
        print("Analysing drawing...")
        classifier.classify(self.image) { result in
            self.classification = result?.icon
        }
    }
    
    private func controlReturned(image: UIImage?) {
        print("Image return \(image == nil ? "failure" : "success")...")
        
        // turn image right side up, resize it and turn it black-and-white
        self.image = DrawingClassifier().configure(image: image)
    }
    
    private func summonImagePicker() {
        print("Summoning ImagePicker...")
        imagePickerOpen = true
    }
    
    private func summonCamera() {
        print("Summoning camera...")
        cameraOpen = true
    }
}

extension ContentView {
    private func mainView() -> AnyView {
        return AnyView(NavigationView {
            MainView(image: image ?? placeholderImage, text: "\(classification ?? "Nothing detected")") {
                TwoStateButton(text: "Classify", disabled: !classificationEnabled, action: classify)
                }.padding().navigationBarTitle(Text("DDDemo"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: summonImagePicker) { Text("Select") },
                                    trailing: Button(action: summonCamera) { Image(systemName: "camera") }.disabled(!cameraEnabled))
        })
    }
    
    private func imagePickerView() -> AnyView {
        return  AnyView(ImagePicker { result in
            self.controlReturned(image: result)
            self.imagePickerOpen = false
        })
    }
    
    private func cameraView() -> AnyView {
        return  AnyView(ImagePicker(camera: true) { result in
            self.controlReturned(image: result)
            self.cameraOpen = false
        })
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
