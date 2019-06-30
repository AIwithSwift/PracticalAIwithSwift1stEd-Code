//
//  Drawing.swift
//  DDDemo
//
//  Created by Mars Geldard on 30/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import Vision

enum Drawing: String, CaseIterable {
    /// These only include those the model was trained on
    /// For others that can be included in the training phase, see the [full list of categories in the dataset](https://raw.githubusercontent.com/googlecreativelab/quickdraw-dataset/master/categories.txt)
    case apple, banana, bread, broccoli, cake, carrot, coffee, cookie
    case donut, grapes, hotdog, icecream, lollipop, mushroom, peanut, pear
    case pineapple, pizza, potato, sandwich, steak, strawberry, watermelon
    
    init?(rawValue: String) {
        if let match = Drawing.allCases.first(where: { $0.rawValue == rawValue }) {
            self = match
        } else {
            switch rawValue {
            case "coffee cup":  self = .coffee
            case "hot dog":     self = .hotdog
            case "ice cream":   self = .icecream
            default: return nil
            }
        }
    }
    
    var icon: String {
        switch self {
        case .apple: return "🍎"
        case .banana: return "🍌"
        case .bread: return "🍞"
        case .broccoli: return "🥦"
        case .cake: return "🎂"
        case .carrot: return "🥕"
        case .coffee: return "☕️"
        case .cookie: return "🍪"
        case .donut: return "🍩"
        case .grapes: return "🍇"
        case .hotdog: return "🌭"
        case .icecream: return "🍦"
        case .lollipop: return "🍭"
        case .mushroom: return "🍄"
        case .peanut: return "🥜"
        case .pear: return "🍐"
        case .pineapple: return "🍍"
        case .pizza: return "🍕"
        case .potato: return "🥔"
        case .sandwich: return "🥪"
        case .steak: return "🥩"
        case .strawberry: return "🍓"
        case .watermelon: return "🍉"
        }
    }
}

extension VNImageRequestHandler {
    convenience init?(uiImage: UIImage) {
        guard let ciImage = CIImage(image: uiImage) else { return nil }
        let orientation = uiImage.cgImageOrientation
        
        self.init(ciImage: ciImage, orientation: orientation)
    }
}

extension DrawingClassifierModelStrokes {    
    func classify(_ image: UIImage?, completion: @escaping (Drawing?) -> ()) {
        guard let image = image,
            let model = try? VNCoreMLModel(for: self.model) else {
                return completion(nil)
        }
        
        let request = VNCoreMLRequest(model: model)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let handler = VNImageRequestHandler(uiImage: image) {
                try? handler.perform([request])
                let results = request.results as? [VNClassificationObservation]
                let highestResult = results?.max { $0.confidence < $1.confidence }
                print(results?.list ?? "")
                completion(Drawing(rawValue: highestResult?.identifier ?? ""))
            } else {
                completion(nil)
            }
        }
    }
}

extension Collection where Element == VNClassificationObservation {
    var list: String {
        var string = ""
        for element in self {
            string += "\(element.identifier): \(element.confidence * 100.0)%\n"
        }
        return string
    }
}

