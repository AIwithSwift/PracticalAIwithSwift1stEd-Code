//
//  Vision.swift
//  ICDemo
//
//  Created by Mars Geldard on 13/6/19.
//  Copyright © 2019 Paris BA. All rights reserved.
//
// BEGIN im_class_ai_visiondotswift
import UIKit
import CoreML
import Vision

extension VNImageRequestHandler {
    convenience init?(uiImage: UIImage) {
        guard let ciImage = CIImage(image: uiImage) else { return nil }
        let orientation = uiImage.cgImageOrientation
        
        self.init(ciImage: ciImage, orientation: orientation)
    }
}

class VisionClassifier {
    
    private let model: VNCoreMLModel
    private lazy var requests: [VNCoreMLRequest] = {
        let request = VNCoreMLRequest(
            model: model, 
            completionHandler: { 
                [weak self] request, error in 
                self?.handleResults(for: request, error: error)
        })
        
        request.imageCropAndScaleOption = .centerCrop
        return [request]
    }()
    
    var delegate: ViewController?
    
    init?(mlmodel: MLModel) {
        if let model = try? VNCoreMLModel(for: mlmodel) {
            self.model = model
        } else {
            return nil
        }
    }
    
    func classify(_ image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let handler = 
                VNImageRequestHandler(uiImage: image) else { 
                    return
            }
            
            do {
                try handler.perform(self.requests)
            } catch {
                self.delegate?.summonAlertView(
                    message: error.localizedDescription
                )
            }
        }
    }
    
    func handleResults(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = 
                request.results as? [VNClassificationObservation] else {
                    self.delegate?.summonAlertView(
                        message: error?.localizedDescription
                    )
                    return
            }
            
            if results.isEmpty {
                self.delegate?.classification = "Don't see a thing!"
            } else {
                let result = results[0]
                
                if result.confidence < 0.6  {
                    self.delegate?.classification = "Not quite sure..."
                } else {
                    self.delegate?.classification = 
                        "\(result.identifier) " +
                        "(\(Int(result.confidence * 100))%)"
                }
            }
            
            self.delegate?.refresh()
        }
    }
}
// END im_class_ai_visiondotswift
// BEGIN im_class_ai_visiondotswiftextension
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
// END im_class_ai_visiondotswiftextension
