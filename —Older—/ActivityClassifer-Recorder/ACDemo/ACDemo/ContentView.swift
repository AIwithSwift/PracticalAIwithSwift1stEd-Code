//
//  ContentView.swift
//  ACDemo
//
//  Created by Mars Geldard on 17/6/19.
//  Copyright © 2019 Mars Geldard. All rights reserved.
//

import SwiftUI

struct IntroView:View {
    @State var firstActionName: String = "Circle"
    @State var secondActionName: String = "Back and Forth"
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("Please think of\ntwo different motions\nyou can do with\nyour phone...\n✌️🤳🤔").bold().font(.largeTitle).lineLimit(5).multilineTextAlignment(.center)

            Spacer()
            
            Text("Give them names").font(.title)
            
            Spacer()
            
            HStack {
                Text("Action ☝️").bold().font(.title)
                TextField($firstActionName).font(.title)
            }
            
            HStack {
                Text("Action ✌️").bold().font(.title)
                TextField($secondActionName).font(.title)
            }
            
            Spacer()
            
            Button(action: next) {
                HStack {
                    Spacer()
                    Text("Next")
                        .font(.title)
                        .bold()
                        .color(.white)
                    Spacer()
                    }.padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
    
    func next() {
        print("You entered \"\(firstActionName)\" and \"\(secondActionName)\" as your two actions.")
    }
}
struct ContentView: View {
    
    var body: some View {
        IntroView().padding()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
