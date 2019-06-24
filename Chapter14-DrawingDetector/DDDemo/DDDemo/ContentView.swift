//
//  ContentView.swift
//  DDDemo
//
//  Created by Mars Geldard on 22/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI
import Vision

struct ContentView: View {
    @State private var imagePickerOpen: Bool = false
    @State private var cameraOpen: Bool = false
    @State private var image: UIImage? = nil
    @State private var classification: String? = nil
    
    private let placeholderImage = UIImage(named: "placeholder")!
    private var cameraEnabled: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }
    private var classificationEnabled: Bool { image != nil && classification == nil }
    
    var body: some View {
        if imagePickerOpen { return imagePickerView() }
        if cameraOpen { return cameraView() }
        return mainView()
    }
    
    private func classify() {
        print("Analysing drawing...")
//        self.image?.detectRectangles { result in
//            self.rectangles = result
//            
//            if let image = self.image, let annotatedImage = result?.drawnOn(image) {
//                self.image =  annotatedImage
//            }
//        }
    }
    
    private func controlReturned(image: UIImage?) {
        print("Image return \(image == nil ? "failure" : "success")...")
        
        // turn image right side up and black-and-white
        self.image = image?.fixOrientation()?.applying(filter: CIFilter.noir)
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
