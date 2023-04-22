import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage: String = ""
    @State var showingAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.accentColor)
            
            Text("Log In")
                .font(.headline)
                .foregroundColor(.accentColor)
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: login) {
                Text("Log In")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Login Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                // Handle login error
                errorMessage = error.localizedDescription
                showingAlert = true
            } else if let _ = result?.user {
                // Navigate to the main screen or perform other actions as needed
                print("Login successful")
            }
        }
    }
}
