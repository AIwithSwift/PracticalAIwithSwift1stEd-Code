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

class ResultsObserver: NSObject, SNResultsObserving {
    
    private let completion: (String?) -> ()
    
    init(completion: @escaping (String?) -> ()) {
        self.completion = completion
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let results = result as? SNClassificationResult,
            let result = results.classifications.first else { return }
        
        if (result.confidence > 0.6) {
             print("Class: \(result.identifier), Confidence: \(Int(result.confidence * 100))%")
            completion(result.identifier)
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        completion(nil)
    }
}

class SoundClassifier {
    
    private let model: MLModel
    private let request: SNClassifySoundRequest
    private let observer: ResultsObserver
    
    init?(model: MLModel, delegate: ViewController) {
        guard let request = try? SNClassifySoundRequest(mlModel: model) else { return nil }
        
        self.model = model
        self.request = request
        self.observer = ResultsObserver { result in
            delegate.classify(Animal(rawValue: result ?? ""))
        }
    }
    
    func classify(audioFile: URL) {
        guard let analyzer = try? SNAudioFileAnalyzer(url: audioFile),
            let _ = try? analyzer.add(request, withObserver: observer) else { return }
        
        analyzer.analyze()
    }
}
