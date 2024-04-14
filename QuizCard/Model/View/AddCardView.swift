//
//  AddCardView.swift
//  QuizCard
//
//  Created by Shakhnoza Mirabzalova on 8/4/23.
//

//import OpenAISwift
import SwiftUI

struct AddCardView: View {
    @State public var text1: String = ""
    @State public var text2: String = ""
    @State public var modelAI = [String]()
    @State public var textField: String = ""
    @State var currentSet: UUID?
    @Binding var set: FlashcardSet
    @State var selection = FlashcardSet(flashcardSetName: "")
    @ObservedObject var mainViewModel: CardViewModel
//    @Binding var setFirebase: FlashcardSetFirebase
    
    init(set: Binding<FlashcardSet>, mainViewModel: CardViewModel) {
        _set = set
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
                                Circle()
                                    .foregroundColor(Color("Color 2"))
                                    .frame(width: 43, height: 43)
                                    .overlay (
                                        Image(systemName: "plus")
//                                            .resizable()
//                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white))
                                            .bold()
                            }
                        }
                }
                
                ScrollView {
                    VStack {
                        // First view of the TextEditor
                        ScrollView {
                            Text("Question")
                                .foregroundColor(.gray);
                            TextEditor(text: $text1)
                                .frame(height: 250)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.gray.opacity(0.2), lineWidth: 2)
                                )
                        }
                        // Second view of the TextEditor
                        ScrollView {
                            Text("Answer")
                                .foregroundColor(.gray);
                            TextEditor(text: $text2)
                                .frame(height: 250)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.gray.opacity(0.2), lineWidth: 2)
                                )
                        }
                    }
                    .onAppear {
                        mainViewModel.setup()
                    }
                    .padding()
                }
                
                Button {
                    send()
                } label: {
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: 330, height: 55)
                        .foregroundColor(Color("Color 2"))
                        .overlay(
                            Text("Save")
                                .foregroundColor(.white)
                                .bold()
                        )
                }
            }
            .padding()
    }
    func send() {
        mainViewModel.send(text: text1) { response in
            DispatchQueue.main.async {
                print("AI Response: \(response)") // Check if you're getting a valid response
                self.text2 = response
//                self.text1 = "" // Clear the input question text
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

