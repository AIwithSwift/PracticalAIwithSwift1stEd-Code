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
    
    func detectBarcodes(completion: @escaping ([VNBarcodeObservation]) ->()) {
        let request = VNDetectBarcodesRequest()
        request.symbologies = [.QR]
        
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
    
    func croppedWithSaliency(to size: CGSize, prioritising saliencyType: SaliencyType = .attentionBased) -> UIImage? {
        if self.size.width < size.width || self.size.height < size.height { return nil }
        guard let cgImage = self.cgImage, let handler = VNImageRequestHandler(uiImage: self) else {
            return self
        }
        
        let request = saliencyType.request
        request.queueFor(image: self) { results in
            if let result = request.results?.first as? VNSaliencyImageObservation {
                
            }
        }
        
        //var unionOfSalientRegions = CGRect(x: 0, y: 0, width: 0, height: 0)
        //let errorPointer = NSErrorPointer(nilLiteral: ())
        //let salientObjects = saliencyObservation.salientObjectsAndReturnError(errorPointer)
        //for salientObject in salientObjects {
        //    unionOfSalientRegions = unionOfSalientRegions.union(salientObject.boundingBox)
        //}
        //self.salientRect = VNImageRectForNormalizedRect(unionOfSalientRegions,
        //                                                originalImage.extent.size.width,
        //                                                originalImage.extent.size.height)
        //
        //public func createHeatMapMask(from observation: VNSaliencyImageObservation) -> CGImage? {
        //    let pixelBuffer = observation.pixelBuffer
        //    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        //    let vector = CIVector(x: 0, y: 0, z: 0, w: 1)
        //    let saliencyImage = ciImage.applyingFilter("CIColorMatrix", parameters: ["inputBVector": vector])
        //    return CIContext().createCGImage(saliencyImage, from: saliencyImage.extent)
        //}
        
        
        // TODO
        // get salientRect, modify to Size
        
        DispatchQueue.global(qos: .userInitiated).async {
            let croppedImage = ciImage.cropped(to: salientRect)
            return UIImage(ciImage: croppedImage)
        }
        
        return nil
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

let saliencyTestImage = UIImage(named: "test2.jpg")!
let thumbnailSize = CGSize(width: 400, height: 400)
let attentionRegionImage = saliencyTestImage.croppedWithSaliency(to: thumbnailSize, prioritising: .attentionBased)
let objectsRegionImage = saliencyTestImage.croppedWithSaliency(to: thumbnailSize, prioritising: .objectnessBased)
