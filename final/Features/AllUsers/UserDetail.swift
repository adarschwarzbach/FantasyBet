//
//  UserDetail.swift
//  final
//
//  Created by Adar Schwarzbach on 4/21/23.
//

import SwiftUI

struct UserDetail: View {
    let user: UserModel

    var body: some View {
        VStack {
            ScrollView{
                AsyncImage(url: user.profilePhoto, content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding()
                }, placeholder: {
                    Image(systemName: "person")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .padding()
                })
                
                if let username = user.username {
                    Text(username)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                }
                if let email = user.email {
                    Text(email)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                if let balance = user.balance {
                    Text("Balance: \(balance)")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                } else {
                    Text("Balance: N/A")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
                if let bettingHistory = user.bettingHistory {
                    BettingHistoryView(bettingHistory: bettingHistory)
                } else {
                    Text("No betting history found.")
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            
            Spacer()
        }
    }
}

//
//struct UserDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetail(user: UserModel)
//    }
//}
