import SwiftUI
import Firebase

struct LoginSignupView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isLoggingIn: Bool = true
    @State var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Text(isLoggingIn ? "Log In" : "Sign Up")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(isLoggingIn ? "Log In" : "Sign Up") {
                if isLoggingIn {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            // User is logged in
                            // Navigate to the main screen or perform other actions as needed
                        }
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            // User is signed up and logged in
                            // Navigate to the main screen or perform other actions as needed
                        }
                    }
                }
            }
            
            Button(isLoggingIn ? "Create an account" : "Log in") {
                isLoggingIn.toggle()
            }
        }
        .padding()
    }
}
