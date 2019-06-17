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
    
    private var completion: (String?) -> ()
    private var results: [(String, Double)] = []
    private var cumulativeResults: [String: Double] {
        return results.reduce(into: [:]) { $0[$1.0, default: 0.0] += $1.1 }
    }
    
    init(completion: @escaping (String?) -> ()) {
        self.completion = completion
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let results = result as? SNClassificationResult,
            let result = results.classifications.first else { return }
        
        if result.confidence > 0.7 {
            self.results.append((result.identifier, result.confidence))
            print("Class: \(result.identifier), Confidence: \(result.confidence)")
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        completion(nil)
    }
    
    func requestDidComplete(_ request: SNRequest) {
        let highestResult = cumulativeResults.max { $0.value < $1.value }
        print("Class: \(highestResult?.key ?? "None"), Confidence: \(highestResult?.value ?? 0.0)")
        completion(highestResult?.key ?? "")
    }
}

class AudioClassifier {
    
    private let model: MLModel
    private let request: SNClassifySoundRequest
    
    init?(model: MLModel) {
        guard let request = try? SNClassifySoundRequest(mlModel: model) else { return nil }
        
        self.model = model
        self.request = request
    }
    
    func classify(audioFile: URL, completion: @escaping (String?) -> ()) {
        let observer = ResultsObserver(completion: completion)
        guard let analyzer = try? SNAudioFileAnalyzer(url: audioFile),
            let _ = try? analyzer.add(request, withObserver: observer) else { return }
        
        analyzer.analyze()
    }
}
