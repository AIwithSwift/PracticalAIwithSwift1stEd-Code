//
//  Faces.swift
//  FDDemo
//
//  Created by Mars Geldard on 20/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN FD_starter_ext_uii_imports
import UIKit
import Vision
// END FD_starter_ext_uii_imports

// BEGIN FD_starter_ext_uii
extension UIImage {
    func detectFaces(completion: @escaping ([VNFaceObservation]?) -> ()) {
        
        guard let image = self.cgImage else { return completion(nil) }
        let request = VNDetectFaceRectanglesRequest()
        
        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(
                cgImage: image, 
                orientation: self.cgImageOrientation
            )

            try? handler.perform([request])
            
            guard let observations = 
                request.results as? [VNFaceObservation] else { 
                    return completion(nil)
            }

            completion(observations)
        }
    }
}
// END FD_starter_ext_uii
