//
//  WordsView.swift
//  ScrabbleHelper
//
//  Created by Selim Gül on 16.10.2022.
//

import SwiftUI

struct WordsView: View {
    let words: [String]
    var scores = ["a": 1, "e": 1, "i": 1, "o": 1, "u": 1, "l": 1, "n": 1, "s": 1, "t": 1, "r": 1, "d": 2, "g": 2,
                  "b": 3, "c": 3, "m": 3, "p": 3,
                  "f": 4, "h": 4, "v": 4, "w": 4, "y": 4,
                  "k": 5,
                  "j": 8, "x": 8,
                  "q": 10, "z": 10]
    //var scores = ["a": "1", "e": "1", "i": "1", "o": "1", "u": "1", "l": "1", "n": "1", "s": "1", "t": "1", "r": "1", "d": "2", "g": "2",
      //            "b": "3", "c": "3", "m": "3", "p": "3",
        //          "f": "4", "h": "4", "v": "4", "w": "4", "y": "4",
          //        "k": "5",
            //      "j": "8", "x": "8",
              //    "q": "10", "z": "10"]
    var body: some View {
        NavigationView{
            Form{
                Section{
                    ForEach(words, id: \.self){ word in
                        //var sum = calculateScore(word: word)
                        
                        
                        Text("\(word)")
                    }
                } header: {
                    Text("Results")
                        .font(.headline.bold())
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    //func calculateScore(word: String) -> Int {
    //    var sum = 0
    //    word.forEach{ char in
    //        var value = scores[char]
    //        sum += value
    //    }
    //    return sum
    //}
}

struct WordsView_Previews: PreviewProvider {
    static var previews: some View {
        WordsView(words: ["car", "blanket", "bus", "television"])
    }
}
