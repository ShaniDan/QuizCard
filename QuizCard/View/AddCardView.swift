//
//  AddCardView.swift
//  QuizCard
//
//  Created by Shakhnoza Mirabzalova on 8/4/23.
//

import SwiftUI

struct AddCardView: View {
    @State public var text1: String = ""
    @State public var text2: String = ""
    @State public var textField: String = ""
    @State var currentSet: UUID?
    @Binding var set: FlashcardSet
    @State var selection = FlashcardSet(flashcardSetName: "")
    @ObservedObject var mainViewModel: CardViewModel
    
    init(set: Binding<FlashcardSet>, mainViewModel: CardViewModel) {
        _set = set
//        _set = State(initialValue: set)
        self.mainViewModel = mainViewModel
    }
    
    var body: some View {
            VStack {
                HStack {
                    Text(set.flashcardSetName)
                }
                .padding(.trailing, 8)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement
                        .navigationBarTrailing) {
                            Button {
                                // MARK: Need to add the card to the saved title name
                                let cardModel = CardModel(question: text1, answer: text2)
                                mainViewModel.add(card: cardModel, to: set.id)
                                set.flashCards.append(cardModel)
                                text1 = ""
                                text2 = ""
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                }
                
                ScrollView {
                    VStack {
                        // First view of the TextEditor
                        Text("Question")
                            .foregroundColor(.gray);
                        TextEditor(text: $text1)
                            .frame(height: 250)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray.opacity(0.2), lineWidth: 2)
                            )
                        // Second view of the TextEditor
                        Text("Answer")
                            .foregroundColor(.gray);
                        TextEditor(text: $text2)
                            .frame(height: 250)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray.opacity(0.2), lineWidth: 2)
                            )
                    }
                    .padding()
                }
            }
    }
}

struct AddCardView_Previews: PreviewProvider {
    @State static var previewSet = FlashcardSet(flashcardSetName: "Sample Set", flashCards: [])
    
    static var previews: some View {
        AddCardView(set: $previewSet, mainViewModel: CardViewModel())

    }
}

