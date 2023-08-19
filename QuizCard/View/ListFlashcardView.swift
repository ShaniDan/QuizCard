//
//  ListFlashcardView.swift
//  QuizCard
//
//  Created by Shakhnoza Mirabzalova on 8/4/23.
//

import SwiftUI

struct ListFlashcardView: View {
    @State public var textField: String = ""
    @State var currentSet: UUID?
    @State var show = false
    @StateObject var mainViewModel: CardViewModel = CardViewModel()
    @State var bottomSheet = false
  
    
    var body: some View {
        NavigationStack {
            ZStack {
                if mainViewModel.cardSets.isEmpty {
                    VStack {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                            .resizable()
                            .frame(width: 140, height: 170)
                            .foregroundColor(Color("Color 2"))
                            .padding()
                        Text("Tap plus to add flashcard set")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Dark Slate Gray"))
                            .bold()
                    }
                } else {
                    VStack {
                        List {
                            ForEach(mainViewModel.allFlashcardSets, id: \.flashcardSetName) { cardSet in
                                NavigationLink(destination: FlashcardView(set: cardSet, mainViewModel: mainViewModel)) {
                                    Text(cardSet.flashcardSetName)
                                        .font(.headline)
                                }
                            }
                            .onDelete(perform: mainViewModel.deleteCardSet)
                            
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                }
            // FloatingButton
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingButton(show: $show, mainViewModel: mainViewModel)
                    }
                }
                .padding()
               }
            Spacer()
            
            .navigationTitle("My Flashcard Sets")
            .foregroundColor(Color("Dark Slate Gray"))
            .onAppear {
                mainViewModel.loadCardSets()
            }
            }
//        .navigationBarBackButtonHidden(true)
        }
    }

struct ListFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        ListFlashcardView()
    }
}



struct FloatingButton: View {
    @Binding var show: Bool
    @ObservedObject var mainViewModel: CardViewModel
    @State public var textField: String = ""
    @State var currentSet: UUID?
    @State var bottomSheet = false
    
    init(show: Binding<Bool>, mainViewModel: CardViewModel) {
        _show = show
        self.mainViewModel = mainViewModel
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.show.toggle()
                bottomSheet.toggle()
            }) {
                Image(systemName: "plus").resizable().frame(width: 30, height: 30).padding(15)
            }
            .background(Color("Color 2"))
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotationEffect(.init(degrees: self.show ? 180 : 0))
            .animation(.easeInOut(duration: 0.4), value: show)
            .sheet(isPresented: $bottomSheet) {
                VStack {
                    Text("New set name")
                        .font(.headline)
                    TextField("Title", text: $textField)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    Button {
                        currentSet = mainViewModel.addSet(name: textField)
                        textField = ""
                    } label: {
                        Text("Save")
                    }
                }
                .padding()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
        .padding(30)
    }
}



