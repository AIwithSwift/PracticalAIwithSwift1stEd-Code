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
    
    init(completion: @escaping (String?) -> ()) {
        self.completion = completion
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let results = result as? SNClassificationResult,
            let result = results.classifications.first else { return }
        let label = result.confidence > 0.7 ? result.identifier : nil
        
        DispatchQueue.main.async {
            self.completion(label)
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        completion(nil)
    }
}

class AudioClassifier {
    
    private let model: MLModel
    private let request: SNClassifySoundRequest
    private let audioEngine = AVAudioEngine()
    private let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    private let inputFormat: AVAudioFormat
    private let analyzer: SNAudioStreamAnalyzer
    private let inputBus: AVAudioNodeBus
    
    private var observer: ResultsObserver?
    
    init?(model: MLModel, inputBus: AVAudioNodeBus = 0) {
        guard let request = try? SNClassifySoundRequest(mlModel: model) else { return nil }
        
        self.model = model
        self.request = request
        self.inputBus = inputBus
        self.inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
        self.analyzer = SNAudioStreamAnalyzer(format: inputFormat)
    }

    func beginAnalysis(completion: @escaping (String?) -> ()) {
        guard let _ = try? audioEngine.start() else { return }
        
        print("Begin recording...")
        let observer = ResultsObserver(completion: completion)
        guard let _ = try? analyzer.add(request, withObserver: observer) else { return }
        self.observer = observer
        
        audioEngine.inputNode.installTap(onBus: inputBus, bufferSize: 8192, format: inputFormat) { buffer, time in
            self.analysisQueue.async {
                self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
    }
    
    func stopAnalysis() {
        print("End recording...")
        analyzer.completeAnalysis()
        analyzer.remove(request)
        audioEngine.inputNode.removeTap(onBus: inputBus)
        audioEngine.stop()
    }
}
