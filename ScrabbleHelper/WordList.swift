//
//  WordList.swift
//  ScrabbleHelper
//
//  Created by Selim Gül on 16.10.2022.
//

import Foundation

struct WordList: Codable, Identifiable {
    let id: Int
    let words: [String]
}
