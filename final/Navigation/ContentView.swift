import SwiftUI
import Firebase
import FirebaseAuth

class UserSession: ObservableObject {
    @Published var currentUser: User?
    
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        addStateDidChangeListener()
    }
    
    func addStateDidChangeListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.currentUser = user
            }
        }
    }
    
    func removeStateDidChangeListener() {
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}

struct ContentView: View {
    
    @StateObject var userSession = UserSession()
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            if let currentUser = userSession.currentUser {
                TabContainer()
                    .environmentObject(CurrentUser(user: currentUser))
                    .environmentObject(homeViewModel)
            } else {
                AuthenticationScreen()
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .environmentObject(homeViewModel)
            }
        }
        .onAppear {
            userSession.addStateDidChangeListener()
        }
        .onDisappear {
            userSession.removeStateDidChangeListener()
        }
    }
}



