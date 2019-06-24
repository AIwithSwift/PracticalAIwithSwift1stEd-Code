//
//  Snippets.swift
//
//  Created by Mars Geldard on 22/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import Vision

extension UIImage {
    func detectRectangles(completion: @escaping ([VNRectangleObservation]?) -> ()) {
        guard let image = self.cgImage else { return completion(nil) }

        let request = VNDetectRectanglesRequest()
        request.minimumConfidence = 0.8
        request.minimumAspectRatio = 0.3
        request.maximumObservations = 3

        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(cgImage: image, orientation: self.cgImageOrientation)
            try? handler.perform([request])
            guard let observations = request.results as? [VNRectangleObservation] else { return completion([]) }
            completion(observations)
        }
    }
    
    func detectBarcodes(completion: @escaping ([VNBarcodeObservation]?) ->()) {
        guard let image = self.cgImage else { return completion(nil) }
        
        // TODO
    }
    
    func cropWithSaliency(to size: CGSize) -> UIImage? {
        if self.size.width < size.width || self.size.height < size.height { return nil }
        
        // TODO
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
