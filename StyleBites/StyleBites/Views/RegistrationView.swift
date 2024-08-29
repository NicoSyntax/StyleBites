//
//  RegistrationView.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 08.07.24.
//

import SwiftUI

struct RegistrationView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var hidePassword: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var body: some View {
        Image("logo-no-background")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 250)
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            SecureField("Repeat Password", text: $repeatPassword)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        
        Button("Register") {
            if password == repeatPassword {
                loginViewModel.register(email: email, password: password)
            } else {
                alertTitle = "Wrong Password"
                alertMessage = "The Password does not match the repeat Password"
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Try Again")))
        }
        .padding()
    }
}


#Preview {
    RegistrationView()
        .environmentObject(LoginViewModel())
}
