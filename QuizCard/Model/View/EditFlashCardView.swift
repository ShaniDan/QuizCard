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
                    ForEach(set.flashCards.indices, id: \.self) { index in
                        VStack {
                            HStack {
                                Text("\(index + 1)")
                                TextEditor(text: $set.flashCards[index].question)
                                        .frame(height: 100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.gray.opacity(0.2), lineWidth: 2)
                                        )
                                TextEditor(text: $set.flashCards[index].answer)
                                    .frame(height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.gray.opacity(0.2), lineWidth: 2)
                                    )
                            }
                            
                            
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
