//
//  Image.swift
//  DDDemo
//
//  Created by Mars Geldard on 30/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN ddnew_image_imports
import UIKit
// END ddnew_image_imports

/// see 
/// https://developer.apple.com/library/archive/documentation/
///     GraphicsImaging/Reference/CoreImageFilterReference/index.html#//
///     apple_ref/doc/uid/TP30000136-SW55 
/// for full list of inbuilt CIFilters, else you can make your own

// BEGIN ddnew_image_cifilter
extension CIFilter {
    static let mono = CIFilter(name: "CIPhotoEffectMono")!
    static let noir = CIFilter(name: "CIPhotoEffectNoir")!
    static let tonal = CIFilter(name: "CIPhotoEffectTonal")!
}
// END ddnew_image_cifilter

// BEGIN ddnew_image_uiimage
extension UIImage {
    // BEGIN ddnew_image_uiimage0
    func applying(filter: CIFilter) -> UIImage? {
        filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        
        let context = CIContext(options: nil)
        guard let output = filter.outputImage,
            let cgImage = context.createCGImage(
                    output, from: output.extent
                ) else {
                    return nil
        }
        
        return UIImage(
            cgImage: cgImage, 
            scale: scale, 
            orientation: imageOrientation)
    }
    // END ddnew_image_uiimage0
    
    // BEGIN ddnew_image_uiimage1
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
    // END ddnew_image_uiimage1
}
// END ddnew_image_uiimage
