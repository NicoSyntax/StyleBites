//
//  SettingsViewModel.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 12.07.24.
//

import Foundation

class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel()
    private let loginViewModel = LoginViewModel()
    
    @Published var isVegan: Bool = false
    @Published var isVegetarian: Bool = false
    @Published var isLowCarb: Bool = false
    @Published var isHighCarb: Bool = false
    // Standartzutaten  evtl prompt anhängen explizit kein text
    
    
    func generateRequestMessage() -> String {
        switch (isVegan, isVegetarian, isLowCarb, isHighCarb) {
        case (true, _, _, _):
            return """
analyse picture give me vegan recipes from the ingredients you see response language = german give response in this json class dont use MarkDown start directly with the json:
    {
        "id": "UUID",
        "title": "String",
        "ingredients": ["String"],
        "steps": ["String"]
    }
"""
        case (_, true, _, _):
            return """
analyse picture give me vegeatarian recipes from the ingredients you see response language = german give response in this json class dont use MarkDown start directly with the json:
    {
        "id": "UUID",
        "title": "String",
        "ingredients": ["String"],
        "steps": ["String"]
    }
"""
        case (_, _, true, _):
            return """
analyse picture give me low carb recipes from the ingredients you see response language = german give response in this json class dont use MarkDown start directly with the json:
    {
        "id": "UUID",
        "title": "String",
        "ingredients": ["String"],
        "steps": ["String"]
    }
    also end with the json
"""
        case (_, _, _, true):
            return """
analyse picture give me high carb recipes from the ingredients you see response language = german give response in this json class dont use MarkDown start directly with the json:
    {
        "id": "UUID",
        "title": "String",
        "ingredients": ["String"],
        "steps": ["String"]
    }
"""
        default:
            return """
analyse picture give me recipes from the ingredients you see response language = german give response in this json class dont use MarkDown start directly with the json:
    {
        "id": "UUID",
        "title": "String",
        "ingredients": ["String"],
        "steps": ["String"]
    }
"""
        }
    }
    
    func logout() {
        loginViewModel.logout()
    }
}
