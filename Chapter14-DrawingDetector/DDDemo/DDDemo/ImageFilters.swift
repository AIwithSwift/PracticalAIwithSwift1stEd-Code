//
//  ImageFilters.swift
//  DDDemo
//
//  Created by Mars Geldard on 24/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

extension UIImage {
    /// see [here](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP30000136-SW55) for full list of inbuilt CIFilters, else you can make your own
    func applying(filter: CIFilter) -> UIImage? {
        filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        
        let context = CIContext(options: nil)
        guard let output = filter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    func fixOrientation() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension CIFilter {
    static let mono = CIFilter(name: "CIPhotoEffectMono")!
    static let noir = CIFilter(name: "CIPhotoEffectNoir")!
    static let tonal = CIFilter(name: "CIPhotoEffectTonal")!
}
