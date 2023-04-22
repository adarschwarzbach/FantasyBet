import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var currentUser = CurrentUser()
    
    var homeViewModel = HomeViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let user = Auth.auth().currentUser {
            currentUser = CurrentUser(user: user)
        }
//        FirebaseApp.configure()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in
                print("User ID: \(user.uid)")
                self.homeViewModel.isLoggedIn = true
            } else {
                // User is signed out
                print("User is signed out")
                self.homeViewModel.isLoggedIn = false
            }
        }
        
        return true
    }

}

