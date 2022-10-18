//
//  WordView.swift
//  ScrabbleHelper
//
//  Created by Selim Gül on 18.10.2022.
//

import SwiftUI

struct WordView: View {
    let word: String
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Text("")
                } header: {
                    Text("Definition")
                }
                
                Section{
                    Text("")
                } header: {
                    Text("Pronunciation")
                }
                
                Section{
                    Text("")
                } header: {
                    Text("Example sentence")
                }
            }
            .navigationTitle(word)
        }
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView(word: "Table")
    }
}
