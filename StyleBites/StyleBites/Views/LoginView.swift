//
//  LoginView.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 01.07.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var hidePassword: Bool = true
    
    var body: some View {
        NavigationStack {
            Image("logo-no-background")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                HStack {
                    if hidePassword {
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    } else {
                        TextField("Passwort", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    Button("", systemImage: "eye") {
                        hidePassword.toggle()
                    }
                }
                
                
                Button("Login") {
                    loginViewModel.login(email: email, password: password)
                }
                .padding()
                
                Divider()
                    .padding()
                Text("No account yet?")
                NavigationLink("Register", destination: RegistrationView())
            }
            .navigationTitle("Login")
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
