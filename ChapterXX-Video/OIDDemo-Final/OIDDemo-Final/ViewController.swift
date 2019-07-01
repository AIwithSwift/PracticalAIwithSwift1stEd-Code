//
//  ViewController.swift
//  OIDDemo-Final
//
//  Created by Paris BA on 1/7/19.
//  Copyright © 2019 Secret Lab Institute. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CoreML

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    //private let classifier = VisionClassifier(mlmodel: YOLOv3Tiny().model)
    @IBOutlet weak var classification: UILabel!
    
//    private var previewLaywer: AVCaptureVideoPreviewLayer! = nil
//    private let videoDataOutput = AVCaptureVideoDataOutput()
//    private let videoQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
//
//    private var classificationOverlay: CALayer! = nil
//
//    private var visionRequests = [VNRequest]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //classifier?.delegate = self
        
        cameraSetup()
    }
    
    func cameraSetup() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .vga640x480
        captureSession.startRunning()
        
        // Input
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(captureInput)
        
        // Display stuff (we need a preview layer to show the camera)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        // Get the output of capture
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        self.classification.text = "Camera setup!"
    }
    
    // For the delegate
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { return }

        let request = VNCoreMLRequest(model: model) { (completedRequest, err) in
            
            guard let results = completedRequest.results as? [VNClassificationObservation] else { return }

            guard let bestResult = results.first else { return }

            DispatchQueue.main.async {
                print("I am here")
                self.classification.text = "\(bestResult.identifier) (\(bestResult.confidence))"
                print(bestResult.identifier)
            }

        }

        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

    
}

//extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//
//        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//        guard let model = try? VNCoreMLModel(for: YOLOv3Tiny().model) else { return }
//
//        let request = VNCoreMLRequest(model: model) { (completedRequest, err) in
//            guard let results = completedRequest.results as? [VNClassificationObservation] else { return }
//
//            guard let bestResult = results.first else { return }
//
//            DispatchQueue.main.async {
//                self.classification.text = "\(bestResult.identifier) (\(bestResult.confidence))"
//                print(bestResult.identifier)
//            }
//
//        }
//
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//    }
//
//}
