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
    // BEGIN ddd_cv_states
    @State private var imagePickerOpen: Bool = false
    @State private var cameraOpen: Bool = false
    @State private var image: UIImage? = nil
    @State private var classification: String? = nil
    // END ddd_cv_states
    
    // BEGIN ddd_cv_vars
    private let placeholderImage = UIImage(named: "placeholder")!
    private let classifier = DrawingClassifierModel()
    private var cameraEnabled: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }
    private var classificationEnabled: Bool { image != nil && classification == nil }
    // END ddd_cv_vars
    
    // BEGIN ddd_cv_bodyview
    var body: some View {
        if imagePickerOpen { return imagePickerView() }
        if cameraOpen { return cameraView() }
        return mainView()
    }
    // END ddd_cv_bodyview
    
    // BEGIN ddd_cv_classify
    private func classify() {
        print("Analysing drawing...")
        classifier.classify(self.image) { result in
            self.classification = result?.icon
        }
    }
    // END ddd_cv_classify
    
    // BEGIN ddd_cv_cr
    private func controlReturned(image: UIImage?) {
        print("Image return \(image == nil ? "failure" : "success")...")
        
        // turn image right side up, resize it and turn it black-and-white
        self.image = classifier.configure(image: image)
    }
    // END ddd_cv_cr
    
    // BEGIN ddd_cv_sip
    private func summonImagePicker() {
        print("Summoning ImagePicker...")
        imagePickerOpen = true
    }
    // END ddd_cv_sip
    
    // BEGIN ddd_cv_sc
    private func summonCamera() {
        print("Summoning camera...")
        cameraOpen = true
    }
    // END ddd_cv_sc
}

// BEGIN ddd_cv_cvext
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
            self.classification = nil
            self.controlReturned(image: result)
            self.imagePickerOpen = false
        })
    }
    
    private func cameraView() -> AnyView {
        return  AnyView(ImagePicker(camera: true) { result in
            self.classification = nil
            self.controlReturned(image: result)
            self.cameraOpen = false
        })
    }
}
// END ddd_cv_cvext

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
