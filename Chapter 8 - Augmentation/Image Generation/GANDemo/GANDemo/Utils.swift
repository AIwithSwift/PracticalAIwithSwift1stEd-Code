//
//  Utils.swift
//  GANDemo
//
//  Created by Mars Geldard on 15/7/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN gan_utils1
import UIKit
import CoreML
import Foundation
// END gan_utils1

// BEGIN gan_utils_mlm
extension MLMultiArray {
    static func getRandomNoise(length: NSNumber = 100) -> MLMultiArray? {
        guard let input = try? MLMultiArray(shape: [length], dataType: .double) else {
            return nil
        }
        
        for index in 0..<Int(truncating: length) {
            input[index] = NSNumber(value: Double.random(in: -1.0...1.0))
        }
        
        return input
    }
}
// END gan_utils_mlm

// BEGIN gan_utils_uint
extension UInt8 {
    static func makeByteArray<T>(from value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }
}
// END gan_utils_uint

// BEGIN gan_utils_uiimage
extension UIImage {
    // BEGIN gan_utils_uiimage1
    convenience init?(data: MLMultiArray) {
        assert(data.shape.count == 3)
        assert(data.shape[0] == 1)

        let height = data.shape[1].intValue
        let width = data.shape[2].intValue

        var byteData: [UInt8] = []
        
        for xIndex in 0..<width {
            for yIndex in 0..<height {
                let pixelValue = Float32(truncating: data[xIndex * height + yIndex])
                let byteOut: UInt8 = UInt8((pixelValue * 127.5) + 127.5)
                byteData.append(byteOut)
            }
        }

        self.init(data: byteData, width: width, height: height, components: 1)
    }
    // END gan_utils_uiimage1
    
    // BEGIN gan_utils_uiimage2
    convenience init?(data: [UInt8], width: Int, height: Int, components: Int) {
        let dataSize = (width * height * components * 8)
        guard let cfData = CFDataCreate(nil, data, dataSize / 8),
            let provider = CGDataProvider(data: cfData),
            let cgImage = CGImage.makeFrom(
                dataProvider: provider,
                width: width,
                height: height,
                components: components) else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
    // END gan_utils_uiimage2
}
// END gan_utils_uiimage

// BEGIN gan_utils_cgimage
extension CGImage {
    static func makeFrom(dataProvider: CGDataProvider, width: Int, height: Int, components: Int) -> CGImage? {
        if components != 1 && components != 3 { return nil }
        
        let bitMapInfo: CGBitmapInfo = .byteOrder16Little
        let bitsPerComponent = 8
        
        let colorSpace: CGColorSpace = (components == 1) ?
            CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB()
        
        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerComponent * components,
            bytesPerRow: ((bitsPerComponent * components) / 8) * width,
            space: colorSpace,
            bitmapInfo: bitMapInfo,
            provider: dataProvider ,
            decode: nil,
            shouldInterpolate: false,
            intent: CGColorRenderingIntent.defaultIntent)
    }
}
// END gan_utils_cgimage
