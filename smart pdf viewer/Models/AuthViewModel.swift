//
//  AuthViewModel.swift
//  smart pdf viewer
//
//  Created by sohail shaik on 7/30/24.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    
    init() {
        self.isSignedIn = Auth.auth().currentUser != nil
        // Observe auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isSignedIn = user != nil
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

