//
//  Models.swift
//  GANDemo
//
//  Created by Mars Geldard on 17/7/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN gan_models_import
import CoreML
import UIKit
// END gan_models_import

// BEGIN gan_models_prot
public protocol ImageGenerator {
    func prediction() -> UIImage?
}
// END gan_models_prot

// BEGIN gan_models_1
extension MnistGan : ImageGenerator {
    // Initialise the MnistGan class using the name of a compiled model
    convenience init(modelName: String) {
        let bundle = Bundle(for: MnistGan.self)
        let url = bundle.url(forResource: modelName, withExtension:"mlmodelc")!
        try! self.init(contentsOf: url)
    }
    // Generate an image, using an array of random noise; the number displayed in
    // the image will depend upon which model was loaded
    func prediction() -> UIImage? {
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? self.prediction(input: MnistGanInput(input1: noiseArray)) {
            return UIImage(data: output.output1)
        }
        return nil
    }
}
// END gan_models_1



//extension MnistGan0: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan0Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}

//extension MnistGan1: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan1Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
//extension MnistGan2: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan2Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
//extension MnistGan3: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan3Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
//extension MnistGan4: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan4Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
//extension MnistGan5: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan5Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
//extension MnistGan6: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan6Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
//extension MnistGan7: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan7Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
//extension MnistGan8: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan8Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
//extension MnistGan9: ImageGenerator {
//    func prediction() -> UIImage? {
//        if let noiseArray = MLMultiArray.getRandomNoise(),
//            let output = try? self.prediction(input: MnistGan9Input(input1: noiseArray)) {
//            return UIImage(data: output.output1)
//        }
//
//        return nil
//    }
//}
//
