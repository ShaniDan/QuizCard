//
//  CardViewModel.swift
//  QuizCard
//
//  Created by Shakhnoza Mirabzalova on 8/4/23.
//

import Foundation

class CardViewModel: ObservableObject {
    
    private static var myKey: String = "myKey"
    
    @Published var cardSets: [FlashcardSet] = getSets() {
        didSet {
            CardViewModel.save(cardSets)
            print("Card sets updated: \(cardSets)")
        }
    }
    private static func save(_ sets: [FlashcardSet]) {
        if let data = try? JSONEncoder().encode(sets) {
            UserDefaults.standard.set(data, forKey: myKey
            )
            print("Card sets saved to UserDefaults")
        }
    }
    
    private static func getSets() -> [FlashcardSet] {
        if let data = UserDefaults.standard.data(forKey: myKey),
           let cardSet = try? JSONDecoder().decode([FlashcardSet].self, from: data) {
            return cardSet
        }
        return []
    }
    
    // MARK: CRUD
    // MARK: Create function
    
    func addSet(name: String) -> UUID {
        let cardSet = FlashcardSet(flashcardSetName: name)
        cardSets.append(cardSet)
        print("New card set added: \(cardSet)")
        return cardSet.id
    }
    
    func add(card: CardModel, to id: UUID?) {
        guard let id = id, let index = allFlashcardSets.firstIndex(where: { $0.id == id }) else { return }
        var cardSet = cardSets.remove(at: index)
        var newCard = card
        newCard.flipped = false
        cardSet.flashCards.append(card)
        cardSets.insert(cardSet, at: index)
        print("New card added to card set: \(card)")
    }
    
    // MARK: Read functions
    func set(id: UUID) -> FlashcardSet? {
        cardSets.first(where: { $0.id == id })
    }
    
    // MARK: Update function
    
    func updateCardSet(cardSetID: UUID, newName: String) -> UUID? {
        guard let cardSetIndex = cardSets.firstIndex(where: { $0.id == cardSetID }) else {
            return nil
        }
        
        cardSets[cardSetIndex].flashcardSetName = newName
        return cardSets[cardSetIndex].id
    }
    
    func updateCards(cardID: UUID, newQuestionName: String, newAnswerName: String) -> UUID? {
        guard let cardSetIndex = cardSets.firstIndex(where: { $0.flashCards.contains(where: { $0.id == cardID }) }),
              let cardIndex = cardSets[cardSetIndex].flashCards.firstIndex(where: { $0.id == cardID }) else {
            return nil
        }
        
        cardSets[cardSetIndex].flashCards[cardIndex].question = newQuestionName
        cardSets[cardSetIndex].flashCards[cardIndex].answer = newAnswerName
        
        return cardSets[cardSetIndex].id
    }
    
    public var allFlashcardSets: [FlashcardSet] {cardSets}
    
    // MARK: Delete function
    
    func deleteCardSet(at offsets: IndexSet) {
        cardSets.remove(atOffsets: offsets)
    }
    
    // MARK: Delete function for individual cards
    
    func deleteCards(at offsets: IndexSet, in set: FlashcardSet) -> FlashcardSet? {
        guard let cardSetIndex = cardSets.firstIndex(where: { $0.id == set.id }) else {
            return nil
        }
        
        cardSets[cardSetIndex].flashCards.remove(atOffsets: offsets)
        return cardSets[cardSetIndex]
    }

    private var keys: NSDictionary?
    
    func setup() {
    }
    func send(text: String, completion: @escaping (String) -> Void) {

        print("working")
    }
                               
    func loadCardSets() {
            cardSets = CardViewModel.getSets()
        }
    }
                               
