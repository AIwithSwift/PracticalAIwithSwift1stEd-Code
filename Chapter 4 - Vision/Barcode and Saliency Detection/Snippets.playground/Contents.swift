// BEGIN bc_sal_imports
import UIKit
import Vision
// END bc_sal_imports

// DETECTING OBJECTS

// BEGIN bc_sal_vnic
extension VNImageRequestHandler {
    convenience init?(uiImage: UIImage) {
        guard let cgImage = uiImage.cgImage else { return nil }
        let orientation = uiImage.cgImageOrientation
        
        self.init(cgImage: cgImage, orientation: orientation)
    }
}
// END bc_sal_vnic

// BEGIN bc_cal_vnr_qf
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
// END bc_cal_vnr_qf

// BEGIN bc_cal_ui_dr_dbc
extension UIImage {
    func detectRectangles(
        completion: @escaping ([VNRectangleObservation]) -> ()) {

        let request = VNDetectRectanglesRequest()
        request.minimumConfidence = 0.8
        request.minimumAspectRatio = 0.3
        request.maximumObservations = 3
        
        request.queueFor(image: self) { result in
            completion(result as? [VNRectangleObservation] ?? [])
        }
    }
    
    func detectBarcodes(
        types symbologies: [VNBarcodeSymbology] = [.QR], 
        completion: @escaping ([VNBarcodeObservation]) ->()) {

        let request = VNDetectBarcodesRequest()
        request.symbologies = symbologies
        
        request.queueFor(image: self) { result in
            completion(result as? [VNBarcodeObservation] ?? [])
        }
    }
    
    // can also detect human figures, animals, the horizon, all sorts of
    // things with inbuilt Vision functions
}
// END bc_cal_ui_dr_dbc

// BEGIN saliency
extension UIImage {
    // BEGIN saliency1
    enum SaliencyType {
        case objectnessBased, attentionBased
        
        var request: VNRequest {
            switch self {
            case .objectnessBased: 
                return VNGenerateObjectnessBasedSaliencyImageRequest()
            case .attentionBased: 
                return VNGenerateAttentionBasedSaliencyImageRequest()
            }
        }
    }
    // END saliency1
    
    // BEGIN saliency2
    func detectSalientRegions(
        prioritising saliencyType: SaliencyType = .attentionBased, 
        completion: @escaping (VNSaliencyImageObservation?) -> ()) {

        let request = saliencyType.request
        
        request.queueFor(image: self) { results in
            completion(results?.first as? VNSaliencyImageObservation)
        }
    }
    // END saliency2
    
    // BEGIN saliency3
    func cropped(
        with saliencyObservation: VNSaliencyImageObservation?, 
        to size: CGSize? = nil) -> UIImage? {

        guard let saliencyMap = saliencyObservation,
            let salientObjects = saliencyMap.salientObjects else { 
                return nil
        }
        
        // merge all detected salient objects into one big rect of the
        // overaching 'salient region'
        let salientRect = salientObjects.reduce(into: CGRect.zero) { 
            rect, object in 
            rect = rect.union(object.boundingBox)  
        }
        let normalizedSalientRect = 
            VNImageRectForNormalizedRect(
                salientRect, Int(self.width), Int(self.height)
            )
        
        var finalImage: UIImage?
        
        // transform normalized salient rect based on larger or smaller
        // than desired size
        if let desiredSize = size {
            if self.width < desiredSize.width || 
                self.height < desiredSize.height { return nil }
            
            let scaleFactor = desiredSize
                .scaleFactor(to: normalizedSalientRect.size)
            
            // crop to the interesting bit
            finalImage = self.cropped(to: normalizedSalientRect)
    
            // scale the image so that as much of the interesting bit as
            // possible can be kept within desiredSize
            finalImage = finalImage?.scaled(by: -scaleFactor)

            // crop to the final desiredSize aspectRatio
            finalImage = finalImage?.cropped(to: desiredSize)
        } else {
            finalImage = self.cropped(to: normalizedSalientRect)
        }
        
        return finalImage
    }
    // END saliency3
}
// END saliency

// we included a test image in the playground Resources
// BEGIN finding_barcodes
let barcodeTestImage = UIImage(named: "test.jpg")!

barcodeTestImage.detectBarcodes { barcodes in
    for barcode in barcodes {
        print("Barcode data: \(barcode.payloadStringValue ?? "None")")
    }
}
// END finding_barcodes

// BEGIN saltest1
let saliencyTestImage = UIImage(named: "test3.jpg")!
let thumbnailSize = CGSize(width: 80, height: 80)
// END saltest1

// note some images may return nil, particularly for objectness,
// if the whole image was found equally interesting

// BEGIN saltest2
var attentionCrop: UIImage?
var objectsCrop: UIImage?
// END saltest2

// BEGIN saltest3
saliencyTestImage.detectSalientRegions(prioritising: .attentionBased) {
    result in
    
    if result == nil { 
        print("The entire image was found equally interesting!")
    }

    attentionCrop = saliencyTestImage
        .cropped(with: result, to: thumbnailSize)

    print("Image was \(saliencyTestImage.width) * " + 
        "\(saliencyTestImage.height), now " + 
        "\(attentionCrop?.width ?? 0) * \(attentionCrop?.height ?? 0).")
}

saliencyTestImage
    .detectSalientRegions(prioritising: .objectnessBased) { result in
    if result == nil { 
        print("The entire image was found equally interesting!")
    }

    objectsCrop = saliencyTestImage
        .cropped(with: result, to: thumbnailSize)

    print("Image was \(saliencyTestImage.width) * " +
    "\(saliencyTestImage.height), now " +
    "\(objectsCrop?.width ?? 0) * \(objectsCrop?.height ?? 0).")
}
// END saltest3
