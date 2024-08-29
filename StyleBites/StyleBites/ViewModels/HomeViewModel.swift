//
//  HomeViewModel.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 02.07.24.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var messages: [MessageItem] = []
    @Published var image: UIImage?
    @Published var isImagePickerPresented = false
    @Published var imageName: String?
    @Published var pendingMessage: String = ""
    @Published var isLoading: Bool = false
    
    private let repository = Repository.shared
    private let settingsViewModel = SettingsViewModel.shared
    
    func sendMessage() {
        pendingMessage = settingsViewModel.generateRequestMessage()
        let userMessage = MessageItem(sender: .user, text: pendingMessage, image: image)
        messages.append(userMessage)
        
        if let base64String = image?.jpegData(compressionQuality: 0.8)?.base64EncodedString() {
            Task {
                await uploadMessageAndImage(base64String: base64String, userMessage: pendingMessage)
            }
        } else {
            Task {
                await uploadMessageOnly(userMessage: pendingMessage)
            }
        }
        
        removeImage()
    }
    
    func selectImage(_ uiImage: UIImage, imageName: String) {
        self.image = uiImage
        self.imageName = imageName
    }
    
    func removeImage() {
        self.image = nil
        self.imageName = nil
    }
    
    @MainActor
    private func uploadMessageOnly(userMessage: String) async {
        let messageContent = OpenAIContent(type: "text", text: userMessage, image_url: nil)
        let message = OpenAIMessage(role: "user", content: [messageContent])
        let requestBody = OpenAIRequest(model: "gpt-4o", messages: [message], max_tokens: 900)
        
        do {
            isLoading = true
            let data = try await repository.makeRequest(urlString: "https://api.openai.com/v1/chat/completions", requestBody: requestBody)
            await repository.handleResponse(data: data, viewModel: self)
        } catch {
            print("Error uploading message: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    @MainActor
    private func uploadMessageAndImage(base64String: String, userMessage: String) async {
        let imageContent = OpenAIContent(type: "image_url", text: nil, image_url: OpenAIImageURL(url: "data:image/jpeg;base64,\(base64String)"))
        let textContent = OpenAIContent(type: "text", text: userMessage, image_url: nil)
        let message = OpenAIMessage(role: "user", content: [textContent, imageContent])
        let requestBody = OpenAIRequest(model: "gpt-4o", messages: [message], max_tokens: 900)
        
        do {
            isLoading = true
            let data = try await repository.makeRequest(urlString: "https://api.openai.com/v1/chat/completions", requestBody: requestBody)
            await repository.handleResponse(data: data, viewModel: self)
        } catch {
            print("Error uploading message and image: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    func updateMessagesWithBotMessage(_ botMessage: MessageItem) {
        messages.append(botMessage)
        isLoading = false
    }
    
    func decodeRecipes(from text: String) -> [Recipe]? {
        if let jsonData = text.data(using: .utf8) {
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: jsonData)
                return recipes
            } catch {
                print("Error decoding Recipes: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func handleResponse(data: Data, viewModel: HomeViewModel) async {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = jsonResponse["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                let cleanedContent = content
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let jsonData = cleanedContent.data(using: .utf8) else {
                    print("Error: Cannot convert JSON content to Data")
                    return
                }
                
                do {
                    let recipe = try JSONDecoder().decode(Recipe.self, from: jsonData)
                    
                    print("Successfully decoded recipe: \(recipe)")
                    
                    let botMessage = MessageItem(
                        sender: .bot,
                        text: "\(recipe.title)\n\nIngredients: \(recipe.ingredients.joined(separator: ", "))\n\nSteps: \(recipe.steps.joined(separator: "\n"))",
                        image: nil
                    )
                    viewModel.updateMessagesWithBotMessage(botMessage)
                    
                } catch {
                    print("Error decoding JSON content: \(error.localizedDescription)")
                }
            } else {
                print("Error: Unable to parse JSON response")
            }
            
        } catch {
            print("Error processing response: \(error.localizedDescription)")
        }
    }

}
