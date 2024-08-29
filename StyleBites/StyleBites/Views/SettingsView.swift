//
//  SettingsView.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 12.07.24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel.shared

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Ernährungsweise")) {
                    Toggle(isOn: $settingsViewModel.isVegetarian) {
                        Text("Vegetarisch")
                    }
                    .onChange(of: settingsViewModel.isVegetarian) { _, newValue in
                        if newValue {
                            settingsViewModel.isVegan = false
                        }
                    }
                    
                    Toggle(isOn: $settingsViewModel.isVegan) {
                        Text("Vegan")
                    }
                    .onChange(of: settingsViewModel.isVegan) { _, newValue in
                        if newValue {
                            settingsViewModel.isVegetarian = false
                        }
                    }
                }
                
                Section(header: Text("Kohlenhydratpräferenz")) {
                    Toggle(isOn: $settingsViewModel.isHighCarb) {
                        Text("High Carb")
                    }
                    .onChange(of: settingsViewModel.isHighCarb) { _, newValue in
                        if newValue {
                            settingsViewModel.isLowCarb = false
                        }
                    }
                    
                    Toggle(isOn: $settingsViewModel.isLowCarb) {
                        Text("Low Carb")
                    }
                    .onChange(of: settingsViewModel.isLowCarb) { _, newValue in
                        if newValue {
                            settingsViewModel.isHighCarb = false
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                settingsViewModel.logout()
            }) {
                Text("Logout")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    SettingsView()
}
