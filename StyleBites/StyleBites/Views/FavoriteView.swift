//
//  FavoriteView.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 12.07.24.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    @ObservedObject var viewModel: FavoriteViewModel
    
    var body: some View {
        VStack {
            if viewModel.messages.isEmpty {
                VStack {
                    Image("logo-no-background")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    Text("Sie haben noch keine Favoriten Hinzugefügt.")
                }
                .padding()
            } else {
                List(viewModel.messages) { message in
                    Text(message.content)
                        .swipeActions {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                viewModel.deleteMessage(message: message)
                            }
                        }
                }
                .onAppear {
                    viewModel.fetchMessages()
                }
            }
        }
    }
}

#Preview {
    FavoriteView(viewModel: FavoriteViewModel(context: ModelContext(
        try! ModelContainer(
            for: MessageContent.self,
            configurations: .init(isStoredInMemoryOnly: true)
        ))))
}
