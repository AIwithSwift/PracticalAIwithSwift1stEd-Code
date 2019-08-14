//
//  ViewController.swift
//  GANDemo
//
//  Created by Mars Geldard on 14/7/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

// BEGIN gan_swift_imports
import UIKit
import CoreML
// END gan_swift_imports

class ViewController: UIViewController {

    // BEGIN gan_swift_outlets
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
    // END gan_swift_outlets
    
    // BEGIN gan_swift_actions
    @IBAction func generateButtonPressed(_ sender: Any) {
        generateNewImages()
    }
    // END gan_swift_actions
    
    // BEGIN gan_swift_vars
    private var imageViews: [UIImageView] = []
    
    private var ganModels: [ImageGenerator] = [
        MnistGan(modelName: "MnistGan"),
        MnistGan(modelName: "MnistGan1"),
        MnistGan(modelName: "MnistGan2"),
        MnistGan(modelName: "MnistGan3"),
        MnistGan(modelName: "MnistGan4"),
        MnistGan(modelName: "MnistGan5"),
        MnistGan(modelName: "MnistGan6"),
        MnistGan(modelName: "MnistGan7"),
        MnistGan(modelName: "MnistGan8"),
        MnistGan(modelName: "MnistGan9"),
    ]
//    private var ganModels: [ImageGenerator] = [
//        MnistGan0(), MnistGan1(), MnistGan2(), MnistGan3(), MnistGan4(),
//        MnistGan5(), MnistGan6(), MnistGan7(), MnistGan8(), MnistGan9()
//    ]
    // END gan_swift_vars
    
    // BEGIN gan_swift_vdl
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageViews = [
            imageViewZero, imageViewOne, imageViewTwo, imageViewThree,
            imageViewFour, imageViewFive, imageViewSix, imageViewSeven,
            imageViewEight, imageViewNine,
        ]

        generateNewImages()
    }
    // END gan_swift_vdl
    
    // BEGIN gan_swift_gennewimages
    private func generateNewImages() {
        for index in 0..<10 {
            let ganModel = ganModels[index]

            DispatchQueue.main.async {
                let generatedImage = ganModel.prediction()
                self.imageViews[index].image = generatedImage
            }
        }
    }
    // END gan_swift_gennewimages
}

