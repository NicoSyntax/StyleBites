//
//  Recipe.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 26.07.24.
//

import Foundation

struct Recipe: Codable {
    let id: String
    let title: String
    let ingredients: [String]
    let steps: [String]
}
