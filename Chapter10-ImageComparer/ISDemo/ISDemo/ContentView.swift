//
//  ContentView.swift
//  ISDemo
//
//  Created by Mars Geldard on 13/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var firstImage: UIImage? = nil
    @State private var secondImage: UIImage? = nil
    @State private var similarity: Int = 0
    
    private let placeholderImage = UIImage(named: "placeholder")!
    private var enableComparison: Bool { return firstImage != nil && secondImage != nil }
    private var buttonColor: Color { return enableComparison ? .blue : .gray }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(uiImage: firstImage ?? placeholderImage).resizable()
                    .aspectRatio(contentMode: .fit)
                    Image(uiImage: secondImage ?? placeholderImage).resizable()
                    .aspectRatio(contentMode: .fit)
                }
                
                Text("Similarity: \(similarity)%").font(.title).bold()
                
                Button(action: getSimilarity) {
                    HStack {
                        Spacer()
                        Text("Compare")
                            .font(.title)
                            .bold()
                            .color(.white)
                        Spacer()
                    }.padding()
                    .background(buttonColor)
                    .cornerRadius(10)
                }//.disabled(!enableComparison)
                
            }.padding()
            .navigationBarTitle(Text("ISDemo"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: summonImagePicker) { Text("Select") }, trailing: Button(action: summonCamera) { Image(systemName: "camera") })
        }
    }
    
    private func getSimilarity() {
        print("Getting similarity...")
        similarity = Int.random(in: 0..<100)
    }
    
    private func summonImagePicker() {
        print("Summoning ImagePicker...")
    }
    
    private func summonCamera() {
        print("Summoning camera...")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
