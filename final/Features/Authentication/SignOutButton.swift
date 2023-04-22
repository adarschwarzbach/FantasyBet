//
//  SignOutButton.swift
//  final
//
//  Created by Adar Schwarzbach on 4/20/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignOutButton: View {
    var body: some View {
        Button(action: signOut) {
            Text("Sign Out")
                .foregroundColor(.white)
                .padding()
                .background(Color.mint)
                .cornerRadius(10)
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
