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
    private var ganModels: [ImageGenerator] = [
        MnistGan0(), MnistGan1(), MnistGan2(), MnistGan3(), MnistGan4(),
        MnistGan5(), MnistGan6(), MnistGan7(), MnistGan8(), MnistGan9()
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageViews = [
            imageViewZero, imageViewOne, imageViewTwo, imageViewThree,
            imageViewFour, imageViewFive, imageViewSix, imageViewSeven,
            imageViewEight, imageViewNine,
        ]

        generateNewImages()
    }
    
    private func generateNewImages() {
        for index in 0..<10 {
            let ganModel = ganModels[index]

            DispatchQueue.main.async {
                let generatedImage = ganModel.prediction()
                self.imageViews[index].image = generatedImage
            }
        }
    }
}

