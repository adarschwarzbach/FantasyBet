import SwiftUI
import Firebase
import FirebaseAuth



struct DisplayNameTextField: View {
    @Binding var displayName: String
    @State private var name = ""
    @State private var isEditing = false
    @State private var showUpdateButton = false
    @EnvironmentObject var currentUser: CurrentUser

    
    var body: some View {
        VStack {
            HStack {
                TextField("Update Display Name", text: $name, onEditingChanged: { editing in
                    isEditing = editing
                })
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
                .onChange(of: name) { newName in
                    showUpdateButton = !newName.isEmpty
                }
            }
            
            if showUpdateButton {
                Button(action: {
                    currentUser.updateDisplayName(name)
                    name = ""
                    displayName = name
                    showUpdateButton = false
                }) {
                    Text("Update Display Name")
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
        }
    }
}
