//
//  TabView.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 12.07.24.
//

import SwiftUI
import SwiftData

struct TabBarView: View {
    let context: ModelContext
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            FavoriteView(viewModel: FavoriteViewModel(context: context))
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        }
    }
    
#Preview {
    TabBarView(context: ModelContext(
        try! ModelContainer(
            for: MessageContent.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
    ))
}
