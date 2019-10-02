//
//  Similarity.swift
//  ISDemo
//
//  Created by Mars Geldard on 19/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN IS_similarity_imports
import UIKit
import Vision
// END IS_similarity_imports

// BEGIN IS_similarity_uii
extension UIImage {
    // BEGIN IS_similarity_uii1
    func similarity(to image: UIImage) -> Float? {
        var similarity: Float = 0
        guard let firstImageFPO = self.featurePrintObservation(),
            let secondImageFPO = image.featurePrintObservation(),
            let _ = try? secondImageFPO.computeDistance(&similarity, to: firstImageFPO) else {
                return nil
        }
        
        return similarity
    }
    // END IS_similarity_uii1
    
    // BEGIN IS_similarity_uii2
    private func featurePrintObservation() -> VNFeaturePrintObservation? {
        guard let cgImage = self.cgImage else { return nil }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: self.cgImageOrientation, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()
        if let _ = try? requestHandler.perform([request]), let result = request.results?.first as? VNFeaturePrintObservation {
            return result
        }
        
        return nil
    }
    // END IS_similarity_uii2
}
// END IS_similarity_uii

// BEGIN IS_similarity_uii_b
extension UIImage {
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
// END IS_similarity_uii_b
