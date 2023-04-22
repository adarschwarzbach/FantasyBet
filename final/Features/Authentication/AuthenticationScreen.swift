//
//  AuthenticationScreen.swift
//  final
//
//  Created by Adar Schwarzbach on 4/3/23.
//

import SwiftUI

struct AuthenticationScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Fantasy Bet")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .padding(48)
            
            HStack(spacing: 20) {
                NavigationLink(destination: LoginScreen()) {
                    Text("Log In")
                        .frame(width: 150)
                        .padding(.vertical, 10)
                        .background(Capsule().stroke(Color.accentColor, lineWidth: 2))
                        .foregroundColor(.accentColor)
                }
                
                NavigationLink(destination: CreateAccount()) {
                    Text("Create Account")
                        .frame(width: 150)
                        .padding(.vertical, 10)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
    }
}



struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationScreen()
    }
}
