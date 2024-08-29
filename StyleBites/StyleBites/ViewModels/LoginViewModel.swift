//
//  LoginViewModel.swift
//  StyleBites
//
//  Created by Nicolas Niemann on 01.07.24.
//

import Foundation
import FirebaseAuth


class LoginViewModel: ObservableObject {
    
    @Published private(set) var user: User?
    
    var isUserLoggedIn: Bool {
        self.user != nil
    }
    
    private let firebaseAuthentication = Auth.auth()
    
    init() {
        if let currentUser = self.firebaseAuthentication.currentUser {
            self.user = currentUser
        }
    }
    
    func login(email: String, password: String) {
        firebaseAuthentication.signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Error in login: \(error)")
                return
            }
            
            guard let authResult, let userEmail = authResult.user.email else {
                print("authResult or Email are empty!")
                return
            }
            
            print("Successfully signed in with user-Id \(authResult.user.uid) and email \(userEmail)")
            
            self.user = authResult.user
        }
    }
    
    func register(email: String, password: String) {
        firebaseAuthentication.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Error in registration: \(error)")
                return
            }
            
            guard let authResult, let userEmail = authResult.user.email else {
                print("authResult or Email are empty!")
                return
            }
            
            print("Successfully registered with userID \(authResult.user.uid) and email \(userEmail)")
            
            self.user = authResult.user
        }
    }
    
    
    func logout() {
        do {
            try firebaseAuthentication.signOut()
            self.user = nil
        } catch {
            print("Error in logout: \(error)")
        }
    }
}
