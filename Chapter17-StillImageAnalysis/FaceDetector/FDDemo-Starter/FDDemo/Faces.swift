//
//  Faces.swift
//  FDDemo
//
//  Created by Mars Geldard on 20/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import Vision

extension UIImage {
    func detectFaces(completion: @escaping ([VNFaceObservation]?) -> ()) {
        guard let image = self.cgImage else { return completion(nil) }
        let request = VNDetectFaceRectanglesRequest()
        
        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(cgImage: image, orientation: self.cgImageOrientation)
            try? handler.perform([request])
            guard let observations = request.results as? [VNFaceObservation] else { return completion(nil) }
            completion(observations)
        }
    }
}
