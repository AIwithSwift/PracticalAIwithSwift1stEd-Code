//
//  Utils.swift
//  GANDemo
//
//  Created by Mars Geldard on 15/7/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import CoreML

import Foundation

class TargetDeviceInformation {
    static var isTargetingSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

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
    
    func convert() -> [UInt8] {
        var byteData: [UInt8] = []
        
        for i in 0..<self.count {
            let floatOut = self[i] as! Float32
            
            if TargetDeviceInformation.isTargetingSimulator {
                let bytesOut = UInt8.makeByteArray(from: (floatOut + 1.0) / 2.0)
                byteData.append(contentsOf: bytesOut)
            } else {
                let byteOut: UInt8 = UInt8((floatOut * 127.5) + 127.5)
                byteData.append(byteOut)
            }
        }
        
        return byteData
    }
}

extension UIImage {
//    static func generatedImage(with ganModel: ImageGenerator) -> UIImage? {
//        guard let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? ganModel.prediction(noiseArray: noiseArray),
//            let outputFeatureProvider = output.featureValue(for: "generatedImage"),
//            let outputImageData = outputFeatureProvider as? MLMultiArray
//            else {
//                return nil
//        }
//        
//        let byteData = outputImageData.convert()
//        let image = createImage(data: byteData, width: 28, height: 28, components: 1)
//        
//        return image
//    }
}

extension UInt8 {
    static func makeByteArray<T>(from value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }
}

extension UIImage {
    convenience init?(data: [UInt8], width: Int, height: Int, components: Int) {
        let bitsPerComponent = TargetDeviceInformation.isTargetingSimulator ? 32 : 8
        let dataSize = (width * height * components * bitsPerComponent)
        guard let cfData = CFDataCreate(nil, data, dataSize / 8),
            let provider = CGDataProvider(data: cfData) else {
            return nil
        }
        
        guard let cgImage = CGImage.makeFrom(dataProvider: provider, width: width, height: height, components: components) else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
}

extension CGImage {
    static func makeFrom(dataProvider: CGDataProvider, width: Int, height: Int, components: Int) -> CGImage? {
        if components != 1 && components != 3 { return nil }
        
        let simulator = TargetDeviceInformation.isTargetingSimulator
        let bitMapInfo: CGBitmapInfo = simulator ? .floatComponents : .byteOrder16Little
        let bitsPerComponent = simulator ? 32 : 8
        
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

