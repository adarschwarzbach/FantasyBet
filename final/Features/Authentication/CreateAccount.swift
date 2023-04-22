//
//  CreateAccount.swift
//  final
//
//  Created by Adar Schwarzbach on 4/3/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct CreateAccount: View {
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var errorMessage: String = ""
    @State var showingAlert: Bool = false
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.accentColor)
            
            Text("Create Account")
                .font(.headline)
                .foregroundColor(.accentColor)
            
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: createAccount) {
                Text("Create Account")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Create Account Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func createAccount() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showingAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                // Handle create account error
                errorMessage = error.localizedDescription
                showingAlert = true
                print(errorMessage)
            } else if let user = result?.user {
                // Create a new document in the users collection with the same id as the new user
                let userDocRef = Firestore.firestore().collection("users").document(user.uid)
                
                // Set the username field in the new document to the user's entered username
                userDocRef.setData(["username": username, "balance":100, "email":email, "profilePhoto":"https://picsum.photos/400/400", "bettingHistory":[]]) { error in
                    if let error = error {
                        // Handle error setting document data
                        errorMessage = error.localizedDescription
                        showingAlert = true
                        print(errorMessage)
                    } else {
                        // Update the display name for the user
                        currentUser.updateDisplayName(username)
                        
                        // Navigate to the main screen or perform other actions as needed
                        print("Account created successfully")
                    }
                }
            }
        }
    }
}
