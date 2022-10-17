//
//  ContentView.swift
//  ScrabbleHelper
//
//  Created by Selim Gül on 16.10.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var availableLetters = ""
    @State private var starts = ""
    @State private var ends = ""
    @State private var length = ""
    @State private var contains = ""
    @State private var usingLetters = ""
    @State private var maxLength = 10
    @State private var foundWords = [String] ()
    @State var wordList = [String]()
    @State var isShowingResults = false
    @State private var isLoading = false
    @State var wordsDictionary = [String: Int]()

    @FocusState private var lengthIsFocused: Bool

    let scores: KeyValuePairs = ["a": 1, "e": 1, "i": 1, "o": 1, "u": 1, "l": 1, "n": 1, "s": 1, "t": 1, "r": 1, "d": 2, "g": 2,
                  "b": 3, "c": 3, "m": 3, "p": 3,
                  "f": 4, "h": 4, "v": 4, "w": 4, "y": 4,
                  "k": 5,
                  "j": 8, "x": 8,
                  "q": 10, "z": 10]
    var body: some View {
        NavigationView{
            List{
                Section{
                    TextField("Enter your letters", text: $availableLetters)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .limitInputLength(value: $availableLetters, length: 7)
                    Picker("Maximum length: ", selection: $maxLength){
                        ForEach(2...15, id:\.self){
                            Text("\($0)")
                        }
                    }
                }
                Section{
                    VStack{
                        TextField("Starts", text: $starts)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        TextField("Ends", text: $ends)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        TextField("Contains", text: $contains)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        TextField("Specific Length", text: $length)
                            .autocorrectionDisabled()
                            .keyboardType(.numberPad)
                            .focused($lengthIsFocused)
                    }
                }
                
                Section{
                    Button(action: {
                        Task {
                            isLoading.toggle()
                            await searchWords()
                        }
                    }, label: {
                        Text("Search words")
                    })
                }


                VStack{
                    NavigationLink{
                        WordsView(wordsDictionary: wordsDictionary)
                    } label: {
                        Text("View results")
                            .foregroundColor(.blue)
                    }
                } .overlay{
                    if isLoading{
                        ProgressView()
                    }
                }
                    
            }
            
            
            .navigationTitle("Scrabble Helper")
            .toolbar {
                ToolbarItem(placement: .keyboard){
                    Spacer()
                    
                    Button("Done"){
                        lengthIsFocused = false
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    
    func searchWords() async {
        wordsDictionary = [String: Int]()
        wordList.removeAll(keepingCapacity: false)
        if length != ""{
            if let wordsURL = Bundle.main.url(forResource: "\(length)letter", withExtension: "txt"){
                if let startWords = try? String(contentsOf: wordsURL){
                    let allWords = startWords.components(separatedBy: "\n")
                    allWords.forEach{ item in
                        var score = 0
                        if starts != "" || ends != "" || contains != ""{
                            usingLetters = ""
                            usingLetters.append(availableLetters)
                            usingLetters.append(contains)
                            usingLetters.append(starts)
                            usingLetters.append(ends)
                            print(usingLetters)
                            if item.hasPrefix(starts) && item.hasSuffix(ends){
                                print(usingLetters)
                                if isSubsetOf(elements: usingLetters, searchingWord: item) == true && item != "" {
                                    if contains != ""{
                                        if item.contains(contains){
                                            score = calculateScore(word: item)
                                            wordsDictionary[item] = score
                                        }
                                    }
                                    else {
                                        score = calculateScore(word: item)
                                        wordsDictionary[item] = score
                                    }
                                }
                            }
                        }
                        else{
                            if isSubsetOf(elements: availableLetters, searchingWord: item) && item != ""{
                                score = calculateScore(word: item)
                                wordsDictionary[item] = score
                            }
                        }

                    }
                    print(wordsDictionary)
                    isLoading = false
                    return
                }
            }
            fatalError("Could not load \(length)letter.txt from bundle")
        }
        else {
            for i in 2..<maxLength + 1{
                if let wordsURL = Bundle.main.url(forResource: "\(i)letter", withExtension: "txt"){
                    if let startWords = try? String(contentsOf: wordsURL){
                        let allWords = startWords.components(separatedBy: "\n")
                        allWords.forEach{ item in
                            var score = 0
                            if starts != "" || ends != "" || contains != ""{
                                usingLetters = ""
                                usingLetters.append(availableLetters)
                                usingLetters.append(contains)
                                usingLetters.append(starts)
                                usingLetters.append(ends)
                                print(usingLetters)
                                if item.hasPrefix(starts) && item.hasSuffix(ends){
                                    print(usingLetters)
                                    if isSubsetOf(elements: usingLetters, searchingWord: item) == true && item != "" {
                                        if contains != ""{
                                            if item.contains(contains){
                                                score = calculateScore(word: item)
                                                wordsDictionary[item] = score
                                            }
                                        }
                                        else {
                                            score = calculateScore(word: item)
                                            wordsDictionary[item] = score
                                        }
                                    }
                                }
                            }
                            else{
                                if isSubsetOf(elements: availableLetters, searchingWord: item) && item != ""{
                                    score = calculateScore(word: item)
                                    wordsDictionary[item] = score
                                }
                            }
                        }
                    }
                }
            }
            isLoading = false
            return
        }
    }
    
    func isSubsetOf(elements: String, searchingWord: String) -> Bool{
        var characters = Array(elements)
        let searchingChars = Array(searchingWord)
        var missing = false
        searchingChars.forEach{ char in
            var found = false
            for i in 0..<characters.count{
                if characters[i] == char {
                    characters.remove(at: i)
                    found = true
                    break
                }
            }
            if (found == false){
                missing = true
            }
        }
        
        if missing == false{
            return true
        }
        else {
            return false
        }
    }
    
    func calculateScore(word: String) -> Int{
        var sum = 0
        word.forEach{char in
            let index = scores.firstIndex(where: {$0.0 == String(char)})
            let score = scores[index ?? 0].1
            sum += score
        }
        return sum
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}


extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
