import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct HomeDetails: View {
    @EnvironmentObject var currentUser: CurrentUser
    
    var bettingHistory: [CompletedBet] {
        return currentUser.bettingHistory ?? []
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Text("Welcome back,")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("\(currentUser.displayName ?? "")")
                            .font(.headline)
                            .foregroundColor(.mint)
                            .padding(.leading, -2)
                    }
                    Text("Balance: $\(currentUser.balance ?? "0.00")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                NavigationLink(destination: ProfileScreen()) {
                            Image(systemName: "gearshape")
                                    .font(.title)
                            }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
            
            if bettingHistory.isEmpty {
                Text("No betting history found.")
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                    .padding(.horizontal)
            } else {
                HomeBettingHistory(bettingHistory: bettingHistory)
            }
            
            Divider()
            
            Spacer()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HomeDetails_Previews: PreviewProvider {
    static var previews: some View {
        HomeDetails()
    }
}
