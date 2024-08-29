//
//  StyleBitesApp.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 01.07.24.
//

import Firebase
import FirebaseAuth
import SwiftUI
import SwiftData

@main
struct StyleBitesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MessageContent.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    

    @StateObject private var loginViewModel = LoginViewModel()

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if loginViewModel.isUserLoggedIn {
                TabBarView(context: sharedModelContainer.mainContext)
            } else {
                LoginView()
                    .environmentObject(loginViewModel)
            }
        }
    }
}
