//
//  FavoriteViewMode.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 12.07.24.
//

import Foundation
import SwiftUI
import SwiftData

class FavoriteViewModel: ObservableObject {
    @Published var messages: [MessageContent] = []
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        fetchMessages()
    }
    
    func fetchMessages() {
        let request = FetchDescriptor<MessageContent>()
        if let fetchedMessages = try? context.fetch(request) {
            messages = fetchedMessages
        }
    }
    
    func addMessage(content: String) {
        let newMessage = MessageContent(content: content)
        context.insert(newMessage)
        saveContext()
        fetchMessages()
        print("Saved Message: \(newMessage.content)")
    }
    
    func deleteMessage(message: MessageContent) {
        context.delete(message)
        saveContext()
        fetchMessages()
        print("Deleted Item: \(message.content)")
    }
    
    func addTestMessage() {
        let newMessage = MessageContent(content: "TEST")
        context.insert(newMessage)
        saveContext()
        fetchMessages()
        print("Saved Test Message: \(newMessage.content)")
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
