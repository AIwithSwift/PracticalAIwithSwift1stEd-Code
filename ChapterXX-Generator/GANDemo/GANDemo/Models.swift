//
//  Models.swift
//  GANDemo
//
//  Created by Mars Geldard on 17/7/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import CoreML
import UIKit

public protocol ImageGenerator {
    func prediction() -> UIImage?
}

extension MnistGan0: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan0Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan0Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan1: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan1Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan1Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan2: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan2Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan2Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan3: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan3Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan3Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan4: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan4Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan4Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan5: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan5Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan5Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan6: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan6Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan6Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan7: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan7Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan7Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan8: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan8Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan8Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

extension MnistGan9: ImageGenerator {
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model.prediction(from: MnistGan9Input(noiseArray: noiseArray) as MLFeatureProvider) as? MnistGan9Output {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            return UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        return nil
    }
}

