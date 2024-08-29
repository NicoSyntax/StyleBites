//
//  RecipeResponse.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 07.08.24.
//

import Foundation

struct RecipeResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
