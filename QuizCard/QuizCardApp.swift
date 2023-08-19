//
//  QuizCardApp.swift
//  QuizCard
//
//  Created by Shakhnoza Mirabzalova on 8/4/23.
//

import SwiftUI

@main
struct QuizCardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListFlashcardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
