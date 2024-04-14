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
    @State var showPopover = false
    @State var showingNotification = true
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
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
                }
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement
                        .navigationBarTrailing) {
                            Button(action: {
                                self.showingNotification.toggle()
                            }) {
                                Image(systemName: "bell")
                                    .resizable()
                                    .frame(width: 20, height: 22)
                                    .padding()
                                    .foregroundColor(.black)
                            }
                        }
                }
                .onAppear {
                    mainViewModel.loadCardSets()
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingButton(show: $show, mainViewModel: mainViewModel)
                    }
                }
                .padding()
            }
            .navigationTitle("My Flashcard Sets")
        }
        .overlay (
            showingNotification ? NotificationView(showingNotification: $showingNotification) : nil
        )
    }
}

struct ListFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        ListFlashcardView()
    }
}

struct NotificationView: View {
    @Binding var showingNotification: Bool
    
    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingNotification = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                Text("Hi, Thank you for using my app and I hope it's helping you to learn new skills. I launched a new application called Owley AI flashcards.")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("If you'd like to check that one out click the Owley button and also join the Owley discord channel below for more information.")
                    .font(.headline)
                    .foregroundColor(.black)
                VStack(alignment: .center) {
                    Link("Owley App Store", destination: URL(string: "https://apps.apple.com/us/app/owley-ai-flashcards/id6473753837?platform=iphone")!)
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(width: 250, height: 50)
                        .background(Color("Color 2"))
                        .cornerRadius(10)
                    Link(" Owley Discord", destination: URL(string: "https://discord.gg/Nt4tFerp")!)
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(width: 250, height: 50)
                        .background(Color("Color 2"))
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(
                .white
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 2)
            )
            .padding()
            Spacer()
        }
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





