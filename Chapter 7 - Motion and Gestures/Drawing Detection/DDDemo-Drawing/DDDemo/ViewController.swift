//
//  ViewController.swift
//  DDDemo
//
//  Created by Mars Geldard on 30/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // BEGIN dd_new_outlets
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var classifyButton: UIButton!
    // END dd_new_outlets
    
    // BEGIN dd_new_actions
    @IBAction func clearButtonPressed(_ sender: Any) { clear() }
    @IBAction func undoButtonPressed(_ sender: Any) { undo() }
    @IBAction func classifyButtonPressed(_ sender: Any) { classify() }
    // END dd_new_actions
    
    // BEGIN dd_new_vars
    var classification: String? = nil
    private var strokes: [CGMutablePath] = []
    private var currentStroke: CGMutablePath? { return strokes.last }
    private var imageViewSize: CGSize { return imageView.frame.size }
    private let classifier = DrawingClassifierModel()
    // END dd_new_vars
    
    // BEGIN dd_new_vdl
    override func viewDidLoad() {
        super.viewDidLoad()
        
        undoButton.disable()
        classifyButton.disable()
    }
    // END dd_new_vdl
    
    // BEGIN dd_new_tb
    // new stroke started
    override func touchesBegan(_ touches: Set<UITouch>, 
        with event: UIEvent?) {

        guard let touch = touches.first else { return }
        
        let newStroke = CGMutablePath()
        newStroke.move(to: touch.location(in: imageView))
        strokes.append(newStroke)
        refresh()
    }
    // END dd_new_tb
    
    // BEGIN dd_new_tm
    // stroke moved
    override func touchesMoved(_ touches: Set<UITouch>, 
        with event: UIEvent?) {

        guard let touch = touches.first, 
            let currentStroke = self.currentStroke else {                 
                return
        }
        
        currentStroke.addLine(to: touch.location(in: imageView))
        refresh()
    }
    // END dd_new_tm
    
    // BEGIN dd_new_te
    // stroke ended
    override func touchesEnded(_ touches: Set<UITouch>, 
        with event: UIEvent?) {

        guard let touch = touches.first, 
            let currentStroke = self.currentStroke else { 
                return 
        }
        
        currentStroke.addLine(to: touch.location(in: imageView))
        refresh()
    }
    // END dd_new_te
    
    // BEGIN dd_new_undo
    // undo last stroke
    func undo() {
        let _ = strokes.removeLast()
        refresh()
    }
    // END dd_new_undo
    
    // BEGIN dd_new_clear
    // clear all strokes
    func clear() {
        strokes = []
        classification = nil
        refresh()
    }
    // END dd_new_clear
    
    // BEGIN dd_new_refresh
    // refresh view to reflect paths
    func refresh() {
        if self.strokes.isEmpty { self.imageView.image = nil }
        
        let drawing = makeImage(from: self.strokes)
        self.imageView.image = drawing
        
        if classification != nil {
            undoButton.disable()
            clearButton.enable()
            classifyButton.disable()
        } else if !strokes.isEmpty {
            undoButton.enable()
            clearButton.enable()
            classifyButton.enable()
        } else {
            undoButton.disable()
            clearButton.disable()
            classifyButton.disable()
        }
        
        classLabel.text = classification ?? ""
    }
    // END dd_new_refresh
    
    // BEGIN dd_new_makeimage
    // draw strokes on image
    func makeImage(from strokes: [CGMutablePath]) -> UIImage? {
        let image = CGContext.create(size: imageViewSize) { context in
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(8.0)
            context.setLineJoin(.round)
            context.setLineCap(.round)
            
            for stroke in strokes {
                context.beginPath()
                context.addPath(stroke)
                context.strokePath()
            }
        }

        return image
    }
    // END dd_new_makeimage
    
    // BEGIN dd_new_classify
    func classify() {
        guard let grayscaleImage = 
            imageView.image?.applying(filter: .noir) else { 
                return 
        }
        
        classifyButton.disable()
        classifier.classify(grayscaleImage) { result in
            self.classification = result?.icon
            
            DispatchQueue.main.async {
                self.refresh()
            }
        }
    }
    // END dd_new_classify
}

