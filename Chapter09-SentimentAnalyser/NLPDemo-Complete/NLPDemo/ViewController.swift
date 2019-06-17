//
//  ViewController.swift
//  NLPDemo
//
//  Created by Mars Geldard on 12/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import UIKit
// BEGIN nlp_new_import
import NaturalLanguage
// END nlp_new_import

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var emojiView: UILabel!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: Actions
    
    @IBAction func analyseSentimentButtonPressed(_ sender: Any) { performSentimentAnalysis() }
    
    // MARK: Attributes
    
    private let placeholderText = "Type something here..."
    // BEGIN nlp_new_attributes
    private lazy var model: NLModel? = {
        return try? NLModel(mlModel: SentimentClassificationModel().model)
    }()
    // END nlp_new_attributes

    // MARK: View Functions
    
    override func viewDidLoad() {
        textView.text = placeholderText
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        super.viewDidLoad()
    }
    
    // MARK: Functionality
    
    private func performSentimentAnalysis() {
        // BEGIN nlp_new_analysis_code1
        var sentimentClass = Sentiment.neutral
        
        if let text = textView.text, let nlModel = self.model {
            sentimentClass = text.predictSentiment(with: nlModel)
        }
        // END nlp_new_analysis_code1
        
        emojiView.text = sentimentClass.icon
        labelView.text = sentimentClass.description
        colorView.backgroundColor = sentimentClass.color
    }
}

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

