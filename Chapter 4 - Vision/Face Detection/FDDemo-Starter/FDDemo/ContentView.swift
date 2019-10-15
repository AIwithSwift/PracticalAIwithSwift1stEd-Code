//
//  ContentView.swift
//  FDDemo
//
//  Created by Mars Geldard on 20/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN FD_starter_cv_1
import SwiftUI
import Vision
// END FD_starter_cv_1

// BEGIN FD_starter_cv_2
struct ContentView: View {
    @State private var imagePickerOpen: Bool = false
    @State private var cameraOpen: Bool = false
    @State private var image: UIImage? = nil
    @State private var faces: [VNFaceObservation]? = nil
    
    // BEGIN FD_starter_cv_2_a
    private var faceCount: Int { return faces?.count ?? 0 }
    private let placeholderImage = UIImage(named: "placeholder")!
    
    private var cameraEnabled: Bool { 
        UIImagePickerController.isSourceTypeAvailable(.camera) 
    }

    private var detectionEnabled: Bool { image != nil && faces == nil }
    // END FD_starter_cv_2_a
    
    // BEGIN FD_starter_cv_2_b
    var body: some View {
        if imagePickerOpen { return imagePickerView() }
        if cameraOpen { return cameraView() }
        return mainView()
    }
    // END FD_starter_cv_2_b
    
    // BEGIN FD_starter_cv_2_c
    private func getFaces() {
        print("Getting faces...")
        self.faces = []
        self.image?.detectFaces { result in
            self.faces = result
        }
    }
    // END FD_starter_cv_2_c
    
    // BEGIN FD_starter_cv_2_d
    private func controlReturned(image: UIImage?) {
        print("Image return \(image == nil ? "failure" : "success")...")
        self.image = image?.fixOrientation()
        self.faces = nil
    }
    // END FD_starter_cv_2_d
    
    // BEGIN FD_starter_cv_2_e
    private func summonImagePicker() {
        print("Summoning ImagePicker...")
        imagePickerOpen = true
    }
    // END FD_starter_cv_2_e
    
    // BEGIN FD_starter_cv_2_f
    private func summonCamera() {
        print("Summoning camera...")
        cameraOpen = true
    }
    // END FD_starter_cv_2_f
}
// END FD_starter_cv_2

// BEGIN FD_starter_cv_ext_1
extension ContentView {
    // BEGIN FD_starter_cv_ext_1_a
    private func mainView() -> AnyView {
        return AnyView(NavigationView {
            MainView(
                image: image ?? placeholderImage, 
                text: "\(faceCount) face\(faceCount == 1 ? "" : "s")") {
                    TwoStateButton(
                        text: "Detect Faces", 
                        disabled: !detectionEnabled, 
                        action: getFaces
                    )
            }
            .padding()
            .navigationBarTitle(Text("FDDemo"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: summonImagePicker) { 
                    Text("Select")
                },
                trailing: Button(action: summonCamera) { 
                    Image(systemName: "camera") 
                }.disabled(!cameraEnabled)
            )
        })
    }
    // END FD_starter_cv_ext_1_a
    
    // BEGIN FD_starter_cv_ext_1_b
    private func imagePickerView() -> AnyView {
        return  AnyView(ImagePicker { result in
            self.controlReturned(image: result)
            self.imagePickerOpen = false
        })
    }
    // END FD_starter_cv_ext_1_b
    
    // BEGIN FD_starter_cv_ext_1_c
    private func cameraView() -> AnyView {
        return  AnyView(ImagePicker(camera: true) { result in
            self.controlReturned(image: result)
            self.cameraOpen = false
        })
    }
    // END FD_starter_cv_ext_1_c
}
// END FD_starter_cv_ext_1

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
