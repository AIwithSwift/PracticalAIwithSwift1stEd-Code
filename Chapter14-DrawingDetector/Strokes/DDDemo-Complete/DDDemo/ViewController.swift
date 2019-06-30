//
//  ViewController.swift
//  DDDemo
//
//  Created by Mars Geldard on 30/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func undoButtonPressed(_ sender: Any) {
        self.undo()
    }
    
    private var strokes: [CGMutablePath] = []
    private var currentStroke: CGMutablePath? { return strokes.last }
    private var imageViewSize: CGSize { return self.imageView.frame.size }
    
    
    // new stroke started
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let newStroke = CGMutablePath()
        newStroke.move(to: touch.location(in: imageView))
        self.strokes.append(newStroke)
        self.refresh()
    }
    
    // stroke moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let currentStroke = self.currentStroke else { return }
        
        currentStroke.addLine(to: touch.location(in: imageView))
        self.refresh()
    }
    
    
    // stroke ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let currentStroke = self.currentStroke else { return }
        
        currentStroke.addLine(to: touch.location(in: imageView))
        self.refresh()
    }
    
    // undo last stroke
    func undo() {
        let _ = self.strokes.removeLast()
        self.refresh()
    }
    
    // refresh view to reflect paths
    func refresh() {
        if self.strokes.isEmpty { self.imageView.image = nil }
        
        let drawing = makeImage(from: self.strokes)
        self.imageView.image = drawing
        self.undoButton.isEnabled = !self.strokes.isEmpty
    }
    
    // draw strokes on image
    func makeImage(from strokes: [CGMutablePath]) -> UIImage? {
        let image = CGContext.create(size: imageViewSize) { context in
            context.setFillColor(UIColor.white.cgColor)
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
}

extension CGContext {
    static func create(size: CGSize, action: (inout CGContext) -> ()) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        guard var context = UIGraphicsGetCurrentContext() else { return nil }
        action(&context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

