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
            guard let observations = request.results as? [VNFaceObservation] else { return completion([]) }
            completion(observations)
        }
    }

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

extension Collection where Element == VNFaceObservation {
    func drawnOn(_ image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(0.01 * image.size.width)
        
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -image.size.height)
        
        for observation in self {
            let rect = observation.boundingBox
            let normalizedRect = VNImageRectForNormalizedRect(rect, Int(image.size.width), Int(image.size.height)).applying(transform)
            context.stroke(normalizedRect)
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
