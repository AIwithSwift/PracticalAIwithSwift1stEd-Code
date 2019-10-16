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
            let handler = VNImageRequestHandler(
                cgImage: image, 
                orientation: self.cgImageOrientation)

            try? handler.perform([request])

            guard let observations = request.results 
                as? [VNFaceObservation] else { 
                    return completion([])
            }
            completion(observations)
        }
    }
    // BEGIN FD_improved_rotatedBy
    func rotatedBy(degrees: CGFloat, clockwise: Bool = false) -> UIImage? {
        var radians = (degrees) * (.pi / 180)
        
        if !clockwise { 
            radians = -radians
        }
        
        let transform = CGAffineTransform(rotationAngle: CGFloat(radians))
        
        let newSize = CGRect(
            origin: CGPoint.zero, 
            size: self.size
            ).applying(transform).size

        let roundedSize = CGSize(
            width: floor(newSize.width), 
            height: floor(newSize.height))

        let centredRect = CGRect(
            x: -self.size.width / 2, 
            y: -self.size.height / 2, 
            width: self.size.width, 
            height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(
            roundedSize, 
            false, 
            self.scale)

        guard let context = UIGraphicsGetCurrentContext() else { 
            return nil 
        }
        
        context.translateBy(
            x: roundedSize.width / 2, 
            y: roundedSize.height / 2
        )

        context.rotate(by: radians)
        self.draw(in: centredRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    // END FD_improved_rotatedBy
    
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

// BEGIN FD_improved_newCollectionExtension
extension Collection where Element == VNFaceObservation {
    func drawnOn(_ image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        guard let _ = UIGraphicsGetCurrentContext() else { return nil }
        
        image.draw(in: CGRect(
            x: 0, 
            y: 0, 
            width: image.size.width, 
            height: image.size.height)
        )

        let imageSize: (width: Int, height: Int) = 
            (Int(image.size.width), Int(image.size.height))

        let transform = CGAffineTransform(scaleX: 1, y: -1)
            .translatedBy(x: 0, y: -image.size.height)

        let padding: CGFloat = 0.3
        
        for observation in self {
            guard let anchor = 
                observation.landmarks?.anchorPointInImage(image) else { 
                    continue
            }

            guard let center = anchor.center?.applying(transform) else { 
                continue
            }
            
            let overlayRect = VNImageRectForNormalizedRect(
                observation.boundingBox,
                imageSize.width,
                imageSize.height
            ).applying(transform).centeredOn(center)

            let insets = (
                x: overlayRect.size.width * padding, 
                y: overlayRect.size.height * padding)

            let paddedOverlayRect = overlayRect.insetBy(
                dx: -insets.x, 
                dy: -insets.y)

            let randomEmoji = [
                "🙂", 
                "😁", 
                "😊", 
                "🤨", 
                "😕", 
                "🙄", 
                "😬", 
                "😮", 
                "😴"
            ].randomElement()!
            
            if var overlayImage = randomEmoji
                .image(of: paddedOverlayRect.size) {

                if let angle = anchor.angle, 
                    let rotatedImage = overlayImage
                        .rotatedBy(degrees: angle) {

                    overlayImage = rotatedImage
                }
                
                overlayImage.draw(in: paddedOverlayRect)
            }
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
// END FD_improved_newCollectionExtension

// BEGIN FD_improved_VNfl
extension VNFaceLandmarks2D {
    func anchorPointInImage(_ image: UIImage) -> 
        (center: CGPoint?, angle: CGFloat?) {

        // centre each set of points that may have been detected, if
        // present
        let allPoints = 
            self.allPoints?.pointsInImage(imageSize: image.size)
            .centerPoint

        let leftPupil = 
            self.leftPupil?.pointsInImage(imageSize: image.size)
            .centerPoint

        let leftEye = 
            self.leftEye?.pointsInImage(imageSize: image.size)
            .centerPoint

        let leftEyebrow = 
            self.leftEyebrow?.pointsInImage(imageSize: image.size)
            .centerPoint

        let rightPupil = 
            self.rightPupil?.pointsInImage(imageSize: image.size)
            .centerPoint

        let rightEye = 
            self.rightEye?.pointsInImage(imageSize: image.size)
            .centerPoint

        let rightEyebrow = 
            self.rightEyebrow?.pointsInImage(imageSize: image.size)
            .centerPoint

        let outerLips = 
            self.outerLips?.pointsInImage(imageSize: image.size)
            .centerPoint

        let innerLips = 
            self.innerLips?.pointsInImage(imageSize: image.size)
            .centerPoint
        
        let leftEyeCenter = leftPupil ?? leftEye ?? leftEyebrow
        let rightEyeCenter = rightPupil ?? rightEye ?? rightEyebrow
        let mouthCenter = innerLips ?? outerLips
        
        if let leftEyePoint = leftEyeCenter, 
            let rightEyePoint = rightEyeCenter, 
            let mouthPoint = mouthCenter {

            let triadCenter = 
                [leftEyePoint, rightEyePoint, mouthPoint]
                .centerPoint

            let eyesCenter = 
                [leftEyePoint, rightEyePoint]
                .centerPoint

            return (eyesCenter, triadCenter.rotationDegreesTo(eyesCenter))
        }
        
        // else fallback
        return (allPoints, 0.0)
    }
}
// END FD_improved_VNfl

// BEGIN FD_improved_cgrectext
extension CGRect {
    func centeredOn(_ point: CGPoint) -> CGRect {
        let size = self.size
        let originX = point.x - (self.width / 2.0)
        let originY = point.y - (self.height / 2.0)
        return CGRect(
            x: originX, 
            y: originY, 
            width: size.width, 
            height: size.height
        )
    }
}
// END FD_improved_cgrectext

// BEGIN FD_improved_cgpoint
extension CGPoint {
    func rotationDegreesTo(_ otherPoint: CGPoint) -> CGFloat {
        let originX = otherPoint.x - self.x
        let originY = otherPoint.y - self.y

        let degreesFromX = atan2f(
            Float(originY), 
            Float(originX)) * (180 / .pi)

        let degreesFromY = degreesFromX - 90.0
        
        let normalizedDegrees = (degreesFromY + 360.0)
            .truncatingRemainder(dividingBy: 360.0)

        return CGFloat(normalizedDegrees)
    }
}
// END FD_improved_cgpoint

// BEGIN FD_improved_array
extension Array where Element == CGPoint {
    var centerPoint: CGPoint {
        let elements = CGFloat(self.count)
        let totalX = self.reduce(0, { $0 + $1.x })
        let totalY = self.reduce(0, { $0 + $1.y })
        return CGPoint(x: totalX / elements, y: totalY / elements)
    }
}
// END FD_improved_array

// BEGIN FD_improved_string
extension String {
    func image(of size: CGSize, scale: CGFloat = 0.94) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(
            in: rect, 
            withAttributes: [
                .font: UIFont.systemFont(ofSize: size.height * scale)
            ]
        )
        
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return image
    }
}
// END FD_improved_string
