//
//  OpenAiModel.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 02.07.24.
//

import Foundation
import UIKit

struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let max_tokens: Int // swiftlint:disable:this identifier_name
}

struct OpenAIContent: Codable {
    let type: String
    let text: String?
    let image_url: OpenAIImageURL? // swiftlint:disable:this identifier_name
}

struct OpenAIImageURL: Codable {
    let url: String
}

struct OpenAIMessage: Codable {
    let role: String
    let content: [OpenAIContent]
}

struct MessageItem: Identifiable {
    let id = UUID()
    let sender: Sender
    let text: String
    let image: UIImage?
}
