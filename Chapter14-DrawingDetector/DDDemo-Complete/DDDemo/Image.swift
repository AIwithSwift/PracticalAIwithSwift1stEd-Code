//
//  Image.swift
//  DDDemo
//
//  Created by Mars Geldard on 24/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

/// see [here](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP30000136-SW55) for full list of inbuilt CIFilters, else you can make your own
extension CIFilter {
    static let mono = CIFilter(name: "CIPhotoEffectMono")!
    static let noir = CIFilter(name: "CIPhotoEffectNoir")!
    static let tonal = CIFilter(name: "CIPhotoEffectTonal")!
}

extension UIImage {
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
    
    /// Returns copy of image .aspectFill-ed to given size with excess cropped,
    /// which maintains as much of original image as possible
    /// - parameter size: Size to fit new image into
    func aspectFilled(to size: CGSize) -> UIImage? {
        if self.size == size { return self }
        
        let (width, height) = (Int(size.width), Int(size.height))
        let aspectRatio: CGFloat = self.size.width / self.size.height
        let intermediateSize: CGSize
        
        if aspectRatio > 0 {
            intermediateSize = CGSize(width: Int(aspectRatio * size.height), height: height)
        } else {
            intermediateSize = CGSize(width: width, height: Int(aspectRatio * size.width))
        }
        
        return self.resized(to: intermediateSize)?.cropped(to: size)
    }
    
    /// Returns copy of image resized to given size
    /// - parameter size: Size to fit new image into
    func resized(to size: CGSize) -> UIImage? {
        let newRect = CGRect(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Returns copy of image cropped to given size
    /// - parameter size: Size to fit new image into
    func cropped(to size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let widthDifference = self.size.width - size.width
        let heightDifference = self.size.height - size.height
        
        if widthDifference + heightDifference == 0 { return self }
        if min(widthDifference, heightDifference) < 0 { return nil }
        
        let newRect = CGRect(x: widthDifference / 2.0, y: heightDifference / 2.0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: 0.0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(cgImage, in: CGRect(x:0, y:0, width: self.size.width, height: self.size.height), byTiling: false)
        context?.clip(to: [newRect])
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
}
