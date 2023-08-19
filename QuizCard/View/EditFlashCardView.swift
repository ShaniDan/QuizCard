//
//  EditFlashCardView.swift
//  QuizCard
//
//  Created by Shakhnoza Mirabzalova on 8/4/23.
//

import SwiftUI

struct EditFlashcardView: View {
    @Binding var set: FlashcardSet
    @ObservedObject var mainViewModel: CardViewModel
    
    init(set: Binding<FlashcardSet>, mainViewModel: CardViewModel) {
//        _set = State(initialValue: set)
        _set = set
        self.mainViewModel = mainViewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Name")
                TextField("Enter Card Set Name", text: $set.flashcardSetName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                List {
                    ForEach(0..<set.flashCards.count, id: \.self) { index in
                        VStack {
                            TextField("Question", text: $set.flashCards[index].question)
                            TextField("Answer", text: $set.flashCards[index].answer)
                        }
                    }
                    .onDelete { indices in
                        if let updatedSet = mainViewModel.deleteCards(at: indices, in: set) {
                            set = updatedSet
                        }
                    }
                }
                .listStyle(.grouped)
            }
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement
                .navigationBarTrailing) {
                    Button(action: {
                        if mainViewModel.updateCardSet(cardSetID: set.id, newName: set.flashcardSetName) != nil {
                            for card in set.flashCards {
                                _ = mainViewModel.updateCards(cardID: card.id,
                                                              newQuestionName: card.question,
                                                              newAnswerName: card.answer)
                            }
                        }
                    }, label: {
                        Text("Save")
                    })
                }
        }
    }
}

struct EditFlashcardView_Previews: PreviewProvider {
    // Create a preview instance of FlashcardSet
    @State static var previewSet = FlashcardSet(flashcardSetName: "Sample Set", flashCards: [
    ])
    
    static var previews: some View {
        EditFlashcardView(set: $previewSet, mainViewModel: CardViewModel())
    }
}
