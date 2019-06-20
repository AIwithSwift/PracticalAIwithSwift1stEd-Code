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
        let request = VNDetectFaceLandmarksRequest()
        
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
        guard let _ = UIGraphicsGetCurrentContext() else { return nil }
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIColor.red.setStroke()
        
        for observation in self {
            guard let features = FacialFeatures(face: observation) else { continue }
            
//            for feature in features.regionsIn(image: image) {
//                feature.image.draw(in: feature.rect)
//            }
            let path = UIBezierPath(cgPath: features.linesIn(image: image))
            path.lineWidth = 0.01 * image.size.width
            path.stroke()
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}

struct FacialFeatures {
    let leftEyePoints: VNFaceLandmarkRegion2D?
    let rightEyePoints: VNFaceLandmarkRegion2D?
    let nosePoints: VNFaceLandmarkRegion2D?
    let mouthPoints: VNFaceLandmarkRegion2D?
    
    enum FeatureType: String {
        case eye = "👁"
        case nose = "👃"
        case mouth = "👅"
    }
    
    init?(face: VNFaceObservation) {
        guard let landmarks = face.landmarks else { return nil }
        self.leftEyePoints = landmarks.leftEye
        self.rightEyePoints = landmarks.rightEye
        self.nosePoints = landmarks.nose
        self.mouthPoints = landmarks.outerLips
    }
    
    func linesIn(image: UIImage) -> CGPath {
        let path = CGMutablePath()
        
        for region in [leftEyePoints, rightEyePoints, nosePoints, mouthPoints] {
            if var coordinates = region?.pointsInImage(imageSize: image.size) {
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -image.size.height)
                coordinates = coordinates.map { point in point.applying(transform) }
                path.addLines(between: coordinates)
            }
        }
        
        return path
    }
    
    func regionsIn(image: UIImage) -> [(image: UIImage, rect: CGRect)] {
        let regions = [leftEyePoints, rightEyePoints, nosePoints, mouthPoints]
        let types = [FeatureType.eye, .eye, .nose, .mouth]
        let offsets: [CGFloat] = [0.2, 0.2, 0.0, 0.3]
        let imageSize = image.size
        
        var normalizedRegions: [(UIImage, CGRect)] = []
        
        for index in 0..<regions.count {
            if let coordinates = regions[index]?.pointsInImage(imageSize: imageSize) {
                let type = types[index]
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -image.size.height)
                var normalizedSquare = CGRect(points: coordinates).applying(transform).squared()
                normalizedSquare = normalizedSquare.offsetBy(dx: 0, dy: normalizedSquare.height * offsets[index])
                if let image = type.rawValue.image(of: normalizedSquare.size) {
                    normalizedRegions.append((image, normalizedSquare))
                }
            }
        }
        
        return normalizedRegions
    }
}

extension CGRect {
    init(points: [CGPoint]) {
        let path = CGMutablePath()
        // missing last point
        path.addLines(between: points)
        self = path.boundingBoxOfPath
    }
    
    func squared() -> CGRect {
        var newSize = self.size
        
        if self.width > self.height {
            newSize = CGSize(width: self.width, height: self.width)
        }
        
        if self.height > self.width {
            newSize = CGSize(width: self.height, height: self.height)
        }
        
        let newOffsetX = newSize.width - self.size.width
        let newOffsetY = newSize.height - self.size.height
        
        return CGRect(
            x: self.origin.x - newOffsetX,
            y: self.origin.y - newOffsetY,
            width: newSize.width,
            height: newSize.height
        )
    }
}

extension String {
    func image(of size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: size.height)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
