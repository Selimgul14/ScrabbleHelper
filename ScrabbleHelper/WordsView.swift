//
//  WordsView.swift
//  ScrabbleHelper
//
//  Created by Selim Gül on 16.10.2022.
//

import SwiftUI


struct WordsView: View {

    let wordsDictionary: [String: Int]
    var words = [String: Int]()
    var body: some View {
        NavigationView{
            Form{
                ForEach(Array(wordsDictionary.keys), id: \.self){ key in
                    var score = String(wordsDictionary[key] ?? 0)
                    HStack{
                        Text(key)
                        Spacer()
                        Text(score)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .navigationTitle("Results")

        
    }
}

struct WordsView_Previews: PreviewProvider {
    static var previews: some View {
        WordsView(wordsDictionary: ["car": 5])
    }
}
