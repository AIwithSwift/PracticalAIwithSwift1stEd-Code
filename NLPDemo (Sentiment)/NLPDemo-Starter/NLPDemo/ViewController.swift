//
//  ViewController.swift
//  NLPDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets
    // START nlp_starter_outlets
    @IBOutlet weak var emojiView: UILabel!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textView: UITextView!
    // END nlp_starter_outlets
    
    // MARK: Actions
    
    // START nlp_starter_actions
    @IBAction func analyseSentimentButtonPressed(_ sender: Any) { performSentimentAnalysis() }
    // END nlp_starter_outlets
    
    // MARK: Attributes
    // START nlp_starter_attributes
    private let placeholderText = "Type something here..."
    // END nlp_starter_attributes

    // MARK: View Functions
    
    // START nlp_starter_vdl
    override func viewDidLoad() {
        textView.text = placeholderText
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        super.viewDidLoad()
    }
    // END nlp_starter_vdl
    
    // MARK: Functionality
    
    // BEGIN nlp_class_performSentimentAnalysis
    private func performSentimentAnalysis() {
        // BEGIN nlp_class_remove1
        let text = textView.text ?? ""
        let sentimentClass = text.predictSentiment()
        // END nlp_class_remove1
        
        emojiView.text = sentimentClass.icon
        labelView.text = sentimentClass.description
        colorView.backgroundColor = sentimentClass.color
    }
    // END nlp_class_performSentimentAnalysis
}

// BEGIN nlp_class_starter_extension
extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
}
// END nlp_class_starter_extension

