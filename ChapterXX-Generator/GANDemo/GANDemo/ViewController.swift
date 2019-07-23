//
//  ViewController.swift
//  GANDemo
//
//  Created by Mars Geldard on 14/7/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var generateButton: UIButton!
    
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var imageViewFour: UIImageView!
    @IBOutlet weak var imageViewFive: UIImageView!
    @IBOutlet weak var imageViewSix: UIImageView!
    @IBOutlet weak var imageViewSeven: UIImageView!
    @IBOutlet weak var imageViewEight: UIImageView!
    @IBOutlet weak var imageViewNine: UIImageView!
    @IBOutlet weak var imageViewZero: UIImageView!
    
    @IBAction func generateButtonPressed(_ sender: Any) {
        generateNewImages()
    }
    
    
    private var imageViews: [UIImageView] = []
    private var ganModels: [ImageGenerator] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageViews = [
            imageViewZero, imageViewOne, imageViewTwo, imageViewThree,
            imageViewFour, imageViewFive, imageViewSix, imageViewSeven,
            imageViewEight, imageViewNine,
        ]
        
        self.ganModels = [
            MnistGan0(), MnistGan1(), MnistGan2(), MnistGan3(), MnistGan4(),
            MnistGan5(), MnistGan6(), MnistGan7(), MnistGan8(), MnistGan9()
        ]
    }
    
    private func generateNewImages() {
//        for index in 0..<10 {
//            let ganModel = ganModels[index]
//
//            DispatchQueue.main.async {
//                self.imageViews[index].image = ganModel.prediction()
//            }
//        }
        let model1 = MnistGan1()
        let imageView1: UIImageView = self.imageViewOne
        imageView1.image = nil
            
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model1.prediction(noiseArray: noiseArray) {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            imageView1.image = UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
        
        let model2 = MnistGan2()
        let imageView2: UIImageView = self.imageViewTwo
        imageView2.image = nil
        
        if let noiseArray = MLMultiArray.getRandomNoise(),
            let output = try? model2.prediction(noiseArray: noiseArray) {
            let outputFeatureProvider = output.generatedImage as MLMultiArray
            let byteData = outputFeatureProvider.convert()
            imageView2.image = UIImage(data: byteData, width: 28, height: 28, components: 1)
        }
    }
}

