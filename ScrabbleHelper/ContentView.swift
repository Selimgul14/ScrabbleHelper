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

    @FocusState private var lengthIsFocused: Bool

    var body: some View {
        NavigationView{
            List{
                Section{
                    TextField("Enter your letters", text: $availableLetters)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
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
                        WordsView(words: wordList)
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
        wordList.removeAll(keepingCapacity: false)
        if length != ""{
            if let wordsURL = Bundle.main.url(forResource: "\(length)letter", withExtension: "txt"){
                if let startWords = try? String(contentsOf: wordsURL){
                    let allWords = startWords.components(separatedBy: "\n")
                    allWords.forEach{ item in
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
                                            wordList.append(item)
                                        }
                                    }
                                    else {
                                        wordList.append(item)
                                    }
                                }
                            }
                        }
                        else{
                            if isSubsetOf(elements: availableLetters, searchingWord: item) && item != ""{
                                wordList.append(item)
                            }
                        }
//                        if isSubsetOf(elements: availableLetters, searchingWord: item) == true && item != ""{
//                            if starts != "" || ends != "" || contains != ""{
//                                if item.hasPrefix(starts) && item.hasSuffix(ends) {
//                                    wordList.append(item)
//                                }
//                            }
//                            else{
//                                wordList.append(item)
//                            }
//                        }
                    }
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
                                                wordList.append(item)
                                            }
                                        }
                                        else {
                                            wordList.append(item)
                                        }
                                    }
                                }
                            }
                            else{
                                if isSubsetOf(elements: availableLetters, searchingWord: item) && item != ""{
                                    wordList.append(item)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
