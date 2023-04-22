import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct finalApp: App {
    init() {
            FirebaseApp.configure()
        }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var currentUser = CurrentUser()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(currentUser)
        }
    }
}
