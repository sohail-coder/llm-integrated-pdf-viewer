//
//  WelcomeView.swift
//  smart pdf viewer
//
//  Created by sohail shaik on 7/29/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct WelcomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Google")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                            authViewModel.signOut()
                            // Optionally, you can add additional logic if needed
                        }) {
                            Text("Sign Out")
                                .font(.title)
                        }
        }
    }
    private func signOut() {
            do {
                try Auth.auth().signOut()
                print("User signed out successfully")
                // Update the root view to show the sign-in view
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
}

#Preview {
    WelcomeView()
}
