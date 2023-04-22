//
//  SaturateUserStore.swift
//  final
//
//  Created by Adar Schwarzbach on 4/21/23.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth

class CurrentUser: ObservableObject {
    @Published var displayName: String?
    @Published var email: String?
    @Published var balance: String?
    @Published var bettingHistory: [CompletedBet]?
    
    
    init() {}
    
    init(user: User) {
        self.displayName = user.displayName
        self.email = user.email
        self.getBettingHistoryAndBalance()
    }
    
    func updateUser(_ user: User) {
        self.displayName = user.displayName
        self.email = user.email
    }
    
    func updateDisplayName(_ newName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        changeRequest?.commitChanges(completion: { error in
            if let error = error {
                print("Error updating display name: \(error.localizedDescription)")
            } else {
                self.displayName = newName
                
                // Update the display name in the user document in Firestore
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                
                let userDocRef = Firestore.firestore().collection("users").document(uid)
                userDocRef.updateData(["username": newName]) { error in
                    if let error = error {
                        print("Error updating display name in user document: \(error.localizedDescription)")
                    } else {
                        print("Display name updated in user document")
                    }
                }
            }
        })
    }

    
    func addBetToHistory(team: String, odds: String, amount: String, outcome: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "bettingHistory": FieldValue.arrayUnion([[
                "team": team,
                "odds": odds,
                "amount": amount,
                "outcome": outcome
            ]])
        ]) { error in
            if let error = error {
                print("Error adding bet to betting history: \(error.localizedDescription)")
            } else {
                print("Bet added to betting history")
                // Add bet to front of bettingHistory array locally
                let completedBet = CompletedBet(amount: amount, odds: odds, outcome: outcome, team: team)
                self.bettingHistory?.insert(completedBet, at: 0)
            }
        }
    }


    func updateBalance(outcome: String, amount: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "balance": FieldValue.increment(Int64(outcome == "won" ? amount : amount))
        ]) { error in
            if let error = error {
                print("Error updating balance: \(error.localizedDescription)")
            } else {
                print("Balance updated successfully")
                if let balance = self.balance, let balanceValue = Int(balance) {
                    self.balance = String(balanceValue + (outcome == "won" ? amount : amount))
                }
            }
        }
    }


    
    
    func getBettingHistoryAndBalance() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                if let data = document.data() {
                    //                    Get balance
                    guard let data = document.data(), let balanceValue = data["balance"] as? Int else {
                        self.balance = "N/A"
                        return
                    }
                    self.displayName =  data["username"] as? String
                    self.balance = String(balanceValue)
                    //                    get betting History
                    //                    print( data["bettingHistory"])
                    if let bettingHistory = data["bettingHistory"] as? [[String: Any]] {
                        var completedBets = [CompletedBet]()
                        for betData in bettingHistory {
                            var amount = betData["amount"] as? String
                            var outcome = betData["outcome"] as? String
                            var team = betData["team"] as? String
                            var odds = betData["odds"] as? String
                            let completed = CompletedBet(amount: amount ?? "", odds: odds ?? "", outcome: outcome ?? "", team: team ?? "")
                            completedBets.append(completed)
                        }
                        self.bettingHistory = completedBets.reversed()
                    }
                }
            }
            
        }
    }
}

