//
//  Repository.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 12.07.24.
//

import Foundation

class Repository {
    static let shared = Repository()
    
    private init() {}
    
    func makeRequest(urlString: String, requestBody: OpenAIRequest) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(ApiKeys.openAi.rawValue)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
        }
        
        return data
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
                    await viewModel.updateMessagesWithBotMessage(botMessage)
                    
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

