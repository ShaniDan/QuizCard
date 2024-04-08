//
//  CardModel.swift
//  QuizCard
//
//  Created by Shakhnoza Mirabzalova on 8/4/23.
//

import Foundation

struct CardModel : Codable, Identifiable, Hashable {
    var id = UUID()
    var question : String
    var answer : String
    var flipped = false
    
}

// A struct to store one FlashCard set's data
struct FlashcardSet : Codable, Identifiable, Hashable {
    var id = UUID()
    var flashcardSetName : String
    var flashCards : [CardModel] = []
}
