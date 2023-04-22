//
//  UserModel.swift
//  final
//
//  Created by Adar Schwarzbach on 4/20/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct UserModel: Codable, Identifiable {
    let id: UUID
    let username: String?
    let balance: String?
    let email: String?
    let profilePhoto: URL?
    var bettingHistory: [CompletedBet]

    init(id: UUID = UUID(),
         username: String = "",
         balance: String = "",
         email: String = "",
         profilePhoto: String = "",
         bettingHistory: [CompletedBet] = []) {
        self.id = id
        self.username = username
        self.balance = balance
        self.email = email
        self.profilePhoto = URL(string:profilePhoto)
        self.bettingHistory = bettingHistory
    }
}

