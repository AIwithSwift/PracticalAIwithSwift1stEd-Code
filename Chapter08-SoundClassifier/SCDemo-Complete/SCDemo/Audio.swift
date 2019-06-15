//
//  Audio.swift
//  SCDemo
//
//  Created by Mars Geldard on 14/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import CoreML
import AVFoundation
import SoundAnalysis

extension MLMultiArray {
    
    convenience init(size: Int, data: UnsafeMutablePointer<Float>, offset: Int = 0) {
        do {
            try self.init(shape: [size] as [NSNumber], dataType: MLMultiArrayDataType.float32)
        } catch {
            fatalError("Could not initialise MLMultiArray for MLModel options.")
        }
        
        for index in (0 + offset)..<(size + offset) {
            self[index] = NSNumber.init(value: data[index])
        }
    }
}

func prepare(audio file: AVAudioFile, model: MLModel) {
    let chunkSize = 15600
    let fileLength = Int(file.length)
    var results: [String: Double] = [:]
    
    let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: UInt32(fileLength))
    do {
        try file.read(into:buffer!)
    } catch{
        fatalError("Error reading buffer.")
    }
    guard let bufferData = buffer?.floatChannelData else { return }
    
    // for each chunk of audio that can be processed at once
    for offset in stride(from: 0, to: fileLength, by: chunkSize) {
        
        // make model array input from given audio data
        let audioData = MLMultiArray(size: chunkSize, data: bufferData[0], offset: offset)
        let input = modelInput(audio: audioData)
        
        // get the result
        guard let chunkResult = try? model.prediction(input: input) else { return }
        
        let tuple: (label: String, prob: Double) = chunkResult.labelProbability
        results[tuple.label, default: 0.0] += tuple.prob
    }
    
    let maxProbability = results.max { $0.value < $1.value }.key
    
    classify(Animal(rawValue: maxProbability))
}


