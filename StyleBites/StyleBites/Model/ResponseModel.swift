//
//  ResponseModel.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 02.07.24.
//

import Foundation

struct ChatCompletionResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
