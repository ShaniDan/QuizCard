//
//  FlashcardView.swift
//  QuizCard
//
//  Created by Shakhnoza Mirabzalova on 8/4/23.
//

import SwiftUI

struct FlashcardView: View {
    @State private var flippedCards: [Bool] = []
    @State var set: FlashcardSet
    @State private var isLinkActive = false
    @ObservedObject var mainViewModel: CardViewModel    
    
    init(set: FlashcardSet, mainViewModel: CardViewModel) {
        _set = State(initialValue: set)
        self.mainViewModel = mainViewModel
    }
    
    
    var body: some View {
        VStack {
            Text(set.flashcardSetName)
                .foregroundColor(Color("Dark Slate Gray"))
                .bold()
                .font(.title)
                .padding()
            if set.flashCards.isEmpty {
                VStack {
                    Image(systemName: "mail.stack.fill")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color("Color 2"))
                        .padding()
                    
                    Text("Here, you'll find your added flashcards. Feel free to input flashcard answers manually or obtain them from AI.")
                        .font(.title3)
                        .foregroundColor(Color("Dark Slate Gray"))
                        .bold()
                        .multilineTextAlignment(.leading)
                        .padding()
                }
            } else {
                VStack { ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        ForEach(set.flashCards) { flashcard in
                           ZStack {
                                Rectangle()
                                    .fill(flashcard.flipped ? Color("Color 2") : Color("Color 1"))
                                    .frame(width: 350, height: 300)
                                    .cornerRadius(15)
                                    .rotation3DEffect(.degrees(flashcard.flipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                                
                                ScrollView(.vertical) {
                                    Text(flashcard.flipped ? flashcard.answer : flashcard.question)
                                        .foregroundColor(.white)
                                        .bold()
                                        .rotation3DEffect(.degrees(flashcard.flipped ? 180 : 0), axis: (x: 0.0, y: 0.0, z: 0.0))
                                        .multilineTextAlignment(.leading)
                                        .frame(minWidth: 310, minHeight: 270)
                                        .padding()
                                }
                                .frame(width: 330, height: 290)
                                
                            }
                            .padding()
                            .onTapGesture {
                                withAnimation {
                                    // index of the tapped card
                                    if let index = set.flashCards.firstIndex(of: flashcard) {
                                        set.flashCards[index].flipped.toggle()
                                        // all the other cards unflipped state
                                        for i in 0..<set.flashCards.count {
                                            if i != index {
                                                set.flashCards[i].flipped = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                }
                .frame(maxWidth: 370, maxHeight: .infinity)
            }
            Spacer()
            NavigationLink(destination: AddCardView(set: $set, mainViewModel: mainViewModel), label: {
                RoundedRectangle(cornerRadius: 40)
                    .frame(width: 330, height: 55)
                    .foregroundColor(Color("Color 2"))
                    .overlay(
                        Text("Add Card")
                            .foregroundColor(.white)
                            .bold()
                    )
            })
            Spacer()
        }
        .onAppear {
            mainViewModel.loadCardSets()
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement
                .navigationBarTrailing) {
                    NavigationLink(destination: EditFlashcardView(set: $set, mainViewModel: mainViewModel)) {
                        Text("Edit")
                    }
                }
        }
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(set: FlashcardSet(flashcardSetName: "Test"), mainViewModel: CardViewModel())
    }
}



