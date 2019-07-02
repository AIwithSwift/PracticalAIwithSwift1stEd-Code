//
//  ReviewTagger.swift
//  CTDemo
//
//  Created by Paris BA on 2/7/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import Foundation
import NaturalLanguage
import CoreML

final class ReviewTagger {
    private static let shared = ReviewTagger()
    
    private let scheme = NLTagScheme("Review")
    private let options: NLTagger.Options = [.omitPunctuation]
    
    private lazy var tagger: NLTagger? = {
        do {
            let modelFile = Bundle.main.url(forResource: "ReviewMLTextClassifier", withExtension: "mlmodelc")!
            let model = try NLModel(contentsOf: modelFile) // makes the ML model an NL model
            let tagger = NLTagger(tagSchemes: [scheme])
            tagger.setModels([model], forTagScheme: scheme) // connect model to (custom) scheme name
            print("Success loading model")
            return tagger
        } catch {
            return nil
        }
    }()
    
    private init() {}
    
    static func prediction(for text: String) -> String? {
        guard let tagger = ReviewTagger.shared.tagger else { return nil }
        print("Prediction requested for: \(text)")
        tagger.string = text
        let range = text.startIndex ..< text.endIndex
        tagger.setLanguage(.english, range: range)
        return tagger.tags(in: range,
            unit: .document,
            scheme: ReviewTagger.shared.scheme,
            options: ReviewTagger.shared.options)
        .compactMap { tag, _ -> String? in
            print(tag?.rawValue)
            return tag?.rawValue
        }
        .first
    }
}
