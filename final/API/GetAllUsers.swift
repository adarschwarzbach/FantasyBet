//
//  GetAllUsers.swift
//  final
//
//  Created by Adar Schwarzbach on 4/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore


class UsersViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var searchText: String = ""
    @EnvironmentObject var currentUser: CurrentUser
    

    func fetchUsers() {
        let db = Firestore.firestore()
        let usersRef = db.collection("users")

        usersRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            var imageID = 1
            self.users = querySnapshot?.documents.compactMap { document -> UserModel? in
                do {
                    if(!document.exists){
                        throw(APIError.failed)
                    }
                    let username: String
                    if let usernameValue = document.data()["username"] as? String {
                        username = String(usernameValue)
                    } else {
                        username = "Unknown"
                    }

                    let balance: String
                    if let balanceValue = document.data()["balance"] as? Int {
                        balance = String(balanceValue)
                    } else {
                        balance = "N/A"
                    }

                    var email: String
                    if let emailValue = document.data()["email"] as? String {
                        email = String(emailValue)
                    } else {
                        email = "none"
                    }
                    var bettingHistory = [CompletedBet]()
                    if let history = document.data()["bettingHistory"] as? [[String: Any]] {
//                        print(history)
                        for betData in history {
                            var amount = betData["amount"] as? String
                            var outcome = betData["outcome"] as? String
                            var team = betData["team"] as? String
                            var odds = betData["odds"] as? String
                            let completed = CompletedBet(amount: amount ?? "", odds: odds ?? "", outcome: outcome ?? "", team: team ?? "")
                            bettingHistory.append(completed)
                        }
                        print(bettingHistory)
                    } else {
                    }
                    
                    let profilePhoto = String(describing: document.data()["profilePhoto"])
                    let profilePhotoURL = NSURL(string: profilePhoto)
                    let profilePhotoString = profilePhotoURL?.absoluteString ?? ""
                    imageID = imageID + 5
                    if(imageID == 6){
                        return UserModel(
                            id: UUID(),
                            username: username,
                            balance: balance,
                            email: email,
                            profilePhoto: "bad-formated-url",
                            bettingHistory: bettingHistory
                        )
                    }
                    return UserModel(
                        id: UUID(),
                        username: username,
                        balance: balance,
                        email: email,
                        profilePhoto: "https://picsum.photos/id/\(imageID)/200",
                        bettingHistory: bettingHistory
                    )
                } catch {
                    print("Error decoding user data: \(error.localizedDescription)")
                    return nil
                }
            } ?? []
        }
    }
}
