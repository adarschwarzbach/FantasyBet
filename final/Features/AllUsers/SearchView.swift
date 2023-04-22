//
//  SearchView.swift
//  final
//
//  Created by Adar Schwarzbach on 4/20/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct SearchView: View {
    @StateObject private var usersViewModel = UsersViewModel()
    @EnvironmentObject var currentUser: CurrentUser

    var filteredUsers: [UserModel] {
        if usersViewModel.searchText.isEmpty {
            return usersViewModel.users.filter { user in
                user.email != currentUser.email
            }
        } else {
            return usersViewModel.users.filter { user in
                user.username?.contains(usersViewModel.searchText) == true &&
                user.email != currentUser.email
            }
        }
    }


    var body: some View {
        NavigationView {
            List(filteredUsers) { user in
                NavigationLink(destination: UserDetail(user: user)) {
                    HStack {
                        AsyncImageWithTimeout(url: user.profilePhoto, placeholder: Image(systemName: "person"))
                                       .frame(width: 50, height: 50)

                        if let username = user.username {
                            Text(username)
                                .font(.headline)
                        }
                        Spacer()
                        if let balance = user.balance {
                            Text("Balance: \(balance)")
                                .font(.subheadline)
                        } else {
                            Text("Balance: N/A")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .onAppear {
                usersViewModel.fetchUsers()
            }
            .navigationTitle("Users")
            .searchable(text: $usersViewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .navigationTitle("Users")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemPurple))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Search Users")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

