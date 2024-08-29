//
//  MessageContent.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 12.07.24.
//

import SwiftData
import Foundation

@Model
class MessageContent: Identifiable {
    let id: UUID
    var content: String

    init(content: String, id: UUID = UUID()) {
        self.content = content
        self.id = id
    }
}

