//
//  SimpleToDoApp.swift
//  SimpleToDo
//
//  Created by ryo.tsuzukihashi on 2024/09/17.
//

import SwiftUI

@main
struct SimpleToDoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
