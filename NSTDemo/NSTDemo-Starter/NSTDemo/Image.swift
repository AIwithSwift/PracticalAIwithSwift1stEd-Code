//
//  Image.swift
//  NSTDemo
//
//  Created by Mars Geldard on 4/3/19.
//  Copyright © 2019 Mars and Paris. All rights reserved.
//

// BEGIN NST_starter_uie
import UIKit

// MARK: UIImage Extensions

extension UIImage{
    
    static let placeholder = UIImage(named: "placeholder.png")!
    
    /// Attempts Neural Style Transfer upon UIImage with given .mlmodel and input options
    /// - parameter modelSelection: StyleModel enum case selected to pass as .mlmodel option
    // BEGIN NST_starter_uie1
    func styled(with modelSelection: StyleModel) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let orientation: UIImage.Orientation
        
        switch modelSelection {
            case .upsideDown: orientation = .downMirrored
            case .left: orientation = .left
            case.right: orientation = .right
        }
        
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: orientation)
    }
    // END NST_starter_uie1
    
    /// Returns copy of image .aspectFill-ed to given size with excess cropped,
    /// which maintains as much of original image as possible
    /// - parameter size: Size to fit new image into
    // BEGIN NST_starter_uie2
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
    // END NST_starter_uie2
    
    /// Returns copy of image resized to given size
    /// - parameter size: Size to fit new image into
    // BEGIN NST_starter_uie3
    func resized(to size: CGSize) -> UIImage? {
        let newRect = CGRect(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    // END NST_starter_uie3
    
    /// Returns copy of image cropped to given size
    /// - parameter size: Size to fit new image into
    // BEGIN NST_starter_uie4
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
    // END NST_starter_uie4
    
    /// Creates and returns CVPixelBuffer for given image, size and attributes
    // BEGIN NST_starter_uie5
    func pixelBuffer() -> CVPixelBuffer? {
        guard let image = self.cgImage else { return nil }
        let dimensions: (height: Int, width: Int) = (Int(self.size.width), Int(self.size.height))
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            dimensions.width,
            dimensions.height,
            kCVPixelFormatType_32BGRA,
            [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
             kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary,
            &pixelBuffer
        )

        guard let createdPixelBuffer = pixelBuffer, status == kCVReturnSuccess else { return nil }
        
        let populatedPixelBuffer = createdPixelBuffer.perform(permission: .readAndWrite) {
            guard let graphicsContext = CGContext.createContext(for: createdPixelBuffer) else { return nil }
            graphicsContext.draw(image, in: CGRect(x: 0, y: 0, width: dimensions.width, height: dimensions.height))
            return createdPixelBuffer
        } as CVPixelBuffer?
        
        return populatedPixelBuffer
    }
    // END NST_starter_uie5
}
// END NST_starter_uie
