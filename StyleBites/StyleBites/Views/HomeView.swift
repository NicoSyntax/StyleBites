//
//  HomeView.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 02.07.24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var favoriteViewModel: FavoriteViewModel
    @State private var photosPickerItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @State private var isShowingInfoSheet = false

    init() {
        let context = ModelContext(
            try! ModelContainer(
                for: MessageContent.self,
                configurations: .init(isStoredInMemoryOnly: false)
            ))
        favoriteViewModel = FavoriteViewModel(context: context)
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        if viewModel.messages.isEmpty {
                            VStack {
                                Image("logo-no-background")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                Text("Wählen Sie unten ein Bild aus und drücken Sie auf Senden.")
                            }
                        } else {
                            ForEach(viewModel.messages) { message in
                                HStack {
                                    if let image = message.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 255)
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                            .shadow(radius: 5)
                                            .padding(.bottom, 5)
                                    } else {
                                        VStack(alignment: .leading) {
                                            if let recipes = viewModel.decodeRecipes(from: message.text) {
                                                ForEach(recipes, id: \.id) { recipe in
                                                    Text("Title: \(recipe.title)")
                                                        .font(.title)
                                                        .padding(.bottom, 2)

                                                    Text("Ingredients:")
                                                        .font(.headline)
                                                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                                                        Text("- \(ingredient)")
                                                    }
                                                    .padding(.bottom, 2)

                                                    Text("Steps:")
                                                        .font(.headline)
                                                    ForEach(recipe.steps, id: \.self) { step in
                                                        Text(step)
                                                    }
                                                }
                                            } else {
                                                Text(message.text)
                                            }
                                        }
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .contextMenu {
                                            Button(action: {
                                                favoriteViewModel.addMessage(content: message.text)
                                            }) {
                                                Label("Speichern", systemImage: "star")
                                            }
                                        }
                                        .padding(.bottom, 5)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
                if let image = image {
                    HStack {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .shadow(radius: 5)
                                .padding(.bottom, 5)
                            Button(action: {
                                self.image = nil
                                self.photosPickerItem = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                HStack {
                    PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                        Image(systemName: "photo.fill")
                            .imageScale(.large)
                    }
                    .padding()
                    .onChange(of: photosPickerItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                                image = uiImage
                                viewModel.selectImage(uiImage, imageName: newItem?.itemIdentifier ?? "image")
                            }
                        }
                    }
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .padding()
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                    .disabled(image == nil)
                }
                .padding()
            }
            .navigationBarItems(trailing: Button(action: {
                isShowingInfoSheet.toggle()
            }) {
                Image(systemName: "cup.and.saucer.fill")
                    .imageScale(.large)
            })
            .sheet(isPresented: $isShowingInfoSheet) {
                VStack {
                    Image("logo-no-background")
                        .resizable()
                        .frame(width: 250, height: 250)
                    Text("Dieses Projekt erfordert finanzielle Unterstützung, um weiterhin online zu bleiben. Wenn Ihnen das Projekt gefällt, können Sie es hier unterstützen:")
                        .padding()
                    Link("Buy me a coffee", destination: URL(string: "https://buymeacoffee.com/nicosyntax")!)
                        .padding()
                        .foregroundColor(.blue)
                    Text("Sie können gerne auch meine weiteren Projekte auf meinem GitHub-Account entdecken.")
    
                    Link("Github", destination: URL(string: "https://github.com/NicoSyntax")!)
                        .padding()
                        .foregroundColor(.blue)
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}

