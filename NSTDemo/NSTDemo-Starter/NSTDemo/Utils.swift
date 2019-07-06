//
//  Utils.swift
//  NSTDemo
//
//  Created by Mars Geldard on 4/3/19.
//  Copyright © 2019 Mars and Paris. All rights reserved.
//

// BEGIN NST_starter_utils
import UIKit
import CoreML
// END NST_starter_utils

// MARK: MLMultiArray Extension

// BEGIN NST_starter_utils1
extension MLMultiArray {
    
    /// Initialises new MLMultiArray of Double: 0.0, changing given index to 1.0
    /// This is used for MLModels with multiple options, where the non-zero index corresponds to some option
    /// - parameters:
    ///     - size: Number of options
    ///     - index: Index to change to 1.0
    convenience init(size: Int, selecting selectedIndex: Int) {
        do {
            try self.init(shape: [size] as [NSNumber], dataType: MLMultiArrayDataType.double)
        } catch {
            fatalError("Could not initialise MLMultiArray for MLModel options.")
        }
        
        for index in 0..<size {
            self[index] = (index == selectedIndex) ? 1.0 : 0.0
        }
    }
}
// END NST_starter_utils1

// MARK: CVPixelBuffer Extensions

// BEGIN NST_starter_utils2
extension CVPixelBufferLockFlags {
    static let readAndWrite = CVPixelBufferLockFlags(rawValue: 0)
}
// END NST_starter_utils2

// BEGIN NST_starter_utils3
extension CVPixelBuffer {
    var width: Int { return CVPixelBufferGetWidth(self) }
    var height: Int { return CVPixelBufferGetHeight(self) }
    var bytesPerRow: Int { return CVPixelBufferGetBytesPerRow(self) }
    var baseAddress: UnsafeMutableRawPointer? { return CVPixelBufferGetBaseAddress(self) }
    
    /// Locks CVPixelBuffer base address, executes block, unlocks base address and returns block output
    /// - parameters:
    ///     - permission: Options for whether ReadOnly or ReadAndWrite access is required
    ///     - action: code block to execute
    func perform<T>(permission: CVPixelBufferLockFlags, action: () -> (T?)) -> T? {
        CVPixelBufferLockBaseAddress(self, permission)      // lock memory
        let output = action()                               // do the thing
        CVPixelBufferUnlockBaseAddress(self, permission)    // unlock memory
        return output                                       // return output of doing thing
    }
}
// END NST_starter_utils3

// MARK: CGContext Extension

// BEGIN NST_starter_utils4
extension CGContext {
    
    /// Create CGContext with dimensions of given CVPixelBuffer and default other values
    /// - parameter pixelBuffer: Image PixelBuffer to make context for
    static func createContext(for pixelBuffer: CVPixelBuffer) -> CGContext? {
        return CGContext(
            data: pixelBuffer.baseAddress,
            width: pixelBuffer.width,
            height: pixelBuffer.height,
            bitsPerComponent: 8,
            bytesPerRow: pixelBuffer.bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue
        )
    }
    
    /// Converts and returns context.makeImage() CGImage output to UIImage
    func makeUIImage() -> UIImage? {
        if let cgImage = self.makeImage() {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
}
// END NST_starter_utils4

// MARK: CGSize Extension

// BEGIN NST_starter_utils5
extension CGSize: CustomStringConvertible {
    public var description: String {
        return "\(self.width) * \(self.height)"
    }
}
// EMD NST_starter_utils5

// MARK: UIButton/UIControl Extensions

// BEGIN NST_starter_utils6
extension UIButton {
    func enable() {
        self.isEnabled = true
        self.backgroundColor = UIColor.systemBlue
    }
    
    func disable() {
        self.isEnabled = false
        self.backgroundColor = UIColor.lightGray
    }
}

extension UIBarButtonItem {
    func enable() { self.isEnabled = true }
    func disable() { self.isEnabled = false }
}
// END NST_starter_utils6
