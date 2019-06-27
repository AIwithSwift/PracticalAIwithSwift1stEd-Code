//
//  Snippets.playground
//
//  Created by Mars Geldard on 22/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import Vision

extension VNImageRequestHandler {
    convenience init?(uiImage: UIImage) {
        guard let cgImage = uiImage.cgImage else { return nil }
        let orientation = uiImage.cgImageOrientation
        
        self.init(cgImage: cgImage, orientation: orientation)
    }
}

extension VNRequest {
    func queueFor(image: UIImage,  completion: @escaping ([Any]?) -> ()) {
        DispatchQueue.global().async {
            if let handler = VNImageRequestHandler(uiImage: image) {
                try? handler.perform([self])
                completion(self.results)
            } else {
                return completion(nil)
            }
        }
    }
}

extension CGRect {
    func scale(to size: CGSize) -> CGRect {
        let horizontalInsets = (self.width - size.width) / 2.0
        let verticalInsets = (self.height - size.height) / 2.0
        let edgeInsets = UIEdgeInsets(
            top: verticalInsets,
            left: horizontalInsets,
            bottom: verticalInsets,
            right: horizontalInsets
        )
        
        let leftOffset = min(self.origin.x + horizontalInsets, 0)
        let upOffset = min(self.origin.y + verticalInsets, 0)
        
        return self.inset(by: edgeInsets).offsetBy(dx: -leftOffset, dy: -upOffset)
    }
}

extension UIImage {
    
    func detectRectangles(completion: @escaping ([VNRectangleObservation]) -> ()) {
        let request = VNDetectRectanglesRequest()
        request.minimumConfidence = 0.8
        request.minimumAspectRatio = 0.3
        request.maximumObservations = 3
        
        request.queueFor(image: self) { result in
            completion(result as? [VNRectangleObservation] ?? [])
        }
    }
    
    func detectBarcodes(types symbologies: [VNBarcodeSymbology] = [.QR], completion: @escaping ([VNBarcodeObservation]) ->()) {
        let request = VNDetectBarcodesRequest()
        request.symbologies = symbologies
        
        request.queueFor(image: self) { result in
            completion(result as? [VNBarcodeObservation] ?? [])
        }
    }
    
    // can also detect human figures, animals, the horizon, all sorts of things
    // with inbuilt Vision functions
    
    enum SaliencyType {
        case objectnessBased, attentionBased
        
        var request: VNRequest {
            switch self {
                case .objectnessBased: return VNGenerateObjectnessBasedSaliencyImageRequest()
                case .attentionBased: return VNGenerateAttentionBasedSaliencyImageRequest()
            }
        }
    }
    
    func detectSalientRegions(prioritising saliencyType: SaliencyType = .attentionBased, completion: @escaping (VNSaliencyImageObservation?) -> ()) {
        let request = saliencyType.request
        
        request.queueFor(image: self) { results in
            completion(results?.first as? VNSaliencyImageObservation)
        }
    }
    
    func cropped(with saliencyObservation: VNSaliencyImageObservation?, to size: CGSize? = nil) -> UIImage? {
        guard let saliencyMap = saliencyObservation,
            let salientObjects = saliencyMap.salientObjects else { return nil }
        
        // merge all detected salient objects into one big rect of the overaching 'salient region'
        let salientRect = salientObjects.reduce(into: CGRect.zero) { rect, object in rect = rect.union(object.boundingBox)  }
        let normalizedSalientRect = VNImageRectForNormalizedRect(salientRect, Int(self.size.width), Int(self.size.height))
        
        var croppingRect = normalizedSalientRect
        
        // transform normalized salient rect based on larger or smaller than desired size
        if let desiredSize = size {
            if self.size.width < desiredSize.width || self.size.height < desiredSize.height { return nil }
            print("Size was \(croppingRect.width) * \(croppingRect.height)")
            croppingRect = croppingRect.scale(to: desiredSize)
            print("Size now \(croppingRect.width) * \(croppingRect.height)")
        }
        
        print("Image was \(self.size.width) * \(self.size.height)")
        guard let croppedImage = self.cropped(to: croppingRect) else { return nil }
        print("Image now \(croppedImage.size.width) * \(croppedImage.size.height)")
        return croppedImage
    }
    
    func cropped(to rect: CGRect) -> UIImage? {
        let croppingRect = CGRect(
            x: rect.origin.x * self.scale,
            y: rect.origin.y * self.scale,
            width: rect.size.width * self.scale,
            height: rect.size.height * self.scale
        )
        
        guard let cgImage = self.cgImage,
            let croppedImage = cgImage.cropping(to: croppingRect) else { return nil }
        return UIImage(cgImage: croppedImage)
        
        // PREVENT SIZE ROUNDING TO NEAREST ODD NUMBER HERE
        
//        guard let croppedImage = self.cgImage?.cropping(to: croppingRect) else { return nil }
//        return UIImage(cgImage: croppedImage, scale: self.scale * (self.scale / 1.0), orientation: self.imageOrientation)
//        UIGraphicsBeginImageContextWithOptions(self.size, false, 0);
//        guard let cgImage = self.cgImage,
//            let context = UIGraphicsGetCurrentContext() else { return nil }
//
//        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
//        context.translateBy(x: 0.0, y: self.size.height)
//        context.scaleBy(x: 1.0, y: -1.0)
//        context.draw(cgImage, in: imageRect, byTiling: false)
//        context.clip(to: [croppingRect])
//
//        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return croppedImage
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

// we included a test image in the playground Resources
let barcodeTestImage = UIImage(named: "test.jpg")!

barcodeTestImage.detectBarcodes { barcodes in
    for barcode in barcodes {
        print("Barcode data: \(barcode.payloadStringValue ?? "None")")
    }
}

let saliencyTestImage = UIImage(named: "test.jpg")!
let thumbnailSize = CGSize(width: 400, height: 400)

saliencyTestImage.detectSalientRegions(prioritising: .attentionBased) { result in
    let attentionCrop = saliencyTestImage.cropped(with: result, to: thumbnailSize)
}

saliencyTestImage.detectSalientRegions(prioritising: .objectnessBased) { result in
    let objectsCrop = saliencyTestImage.cropped(with: result, to: thumbnailSize)
}
