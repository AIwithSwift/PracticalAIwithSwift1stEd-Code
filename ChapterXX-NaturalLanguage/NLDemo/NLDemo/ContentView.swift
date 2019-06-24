//
//  ContentView.swift
//  NLDemo
//
//  Created by Paris BA on 22/6/19.
//  Copyright © 2019 Secret Lab Institute. All rights reserved.
//

import SwiftUI
import NaturalLanguage

struct ContentView : View {
    
    @State var text: String = "Type some text here"
    
    let tagger = NLTagger(tagSchemes: [.nameType])
    
    let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    
    let tags: [NLTag] = [.personalName, .placeName, .organizationName]
    
    var body: some View {
        VStack {
            TextField($text, onEditingChanged: { (changed) in
                self.textChanged()
            }) {
                self.textChanged()
            }
                .textFieldStyle(.roundedBorder)
                .padding()
            Text("Text: \(text)")
        }
    }
    
    private func    () {
        //print("text changed!")
        tagger.string = text
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            if let tag = tag, tags.contains(tag) {
                print("\(text[tokenRange]): \(tag.rawValue)")
            }
            return true
        }

    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif





