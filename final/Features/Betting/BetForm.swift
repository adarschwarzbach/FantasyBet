//
//  BetForm.swift
//  final
//
//  Created by Adar Schwarzbach on 4/22/23.
//

import SwiftUI

struct TeamFormView: View {
    let teamLine: Game.TeamLine
    
    @EnvironmentObject var currentUser: CurrentUser
    @Environment(\.presentationMode) var presentationMode

    
    @State private var isConfirmed = false
    @State private var betAmount = ""
    @State private var result: String? = nil
    @State private var netAmount: Int? = nil
    
    var body: some View {
        VStack {
            Text("Balance: $\(currentUser.balance ?? "")")
                .font(.title)
                .padding()
            
            Form {
                Section(header:
                    HStack {
                        Spacer()
                        Text(teamLine.team)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                    }
                    .padding(.vertical)
                    .background(Color.white)
                    .cornerRadius(20)
                ) {
                    HStack {
                        Spacer()
                        Text(convertToMoneylineOdds(teamLine.price))
                            .font(.title2)
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
                .padding(.vertical)
                
                if result == nil && netAmount == nil {
                    Section(header: Text("Bet Amount")) {
                        TextField("Enter amount", text: $betAmount)
                            .keyboardType(.numberPad)
                    }
                }
                
                if let result = result, let netAmount = netAmount {
                    Section(header: Text("Bet Result")) {
                        Text("Result: \(result)")
                        Text("Net Amount: $\(netAmount)")
                    }
                }
            }
            
            if result == nil && netAmount == nil {
                Button(action: {
                    if let betResult = confirmBet(betAmount: betAmount, currentUser: currentUser, teamLine: teamLine.price, team:teamLine.team) {
                        self.result = betResult.result
                        self.netAmount = betResult.netAmount
                    }
                }) {
                    Text("Confirm Bet")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(isConfirmed || (betAmount.isEmpty || Int(betAmount ?? "") == nil || Int(betAmount ?? "")! <= 0 || Int(betAmount ?? "")! > (Int(currentUser.balance ?? "") ?? 0)) ? Color.red : Color.green.opacity(0.8))
                        .cornerRadius(10)
                }
                .disabled(isConfirmed || (betAmount.isEmpty || Int(betAmount ?? "") == nil || Int(betAmount ?? "")! <= 0 || Int(betAmount ?? "")! > (Int(currentUser.balance ?? "") ?? 0)))
            } else {
                Spacer()
                    .frame(height: 30)
                Button(action: {
                    betAmount = ""
                    result = nil
                    netAmount = nil
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
        }
        .navigationBarTitle(Text(teamLine.team), displayMode: .inline)
    }
}



func confirmBet(betAmount: String, currentUser: CurrentUser, teamLine: Double, team: String) -> (result: String, netAmount: Int)? {
    guard let balance = currentUser.balance, let amount = Int(betAmount), amount > 0 else {
        // Invalid bet amount
        return nil
    }
    
    guard amount <= Int(balance) ?? 0 else {
        // User does not have sufficient funds
        let alert = UIAlertController(title: "Insufficient Funds", message: "You do not have enough funds to make this bet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        return nil
    }
    
    let probability = 1 / teamLine
    let randomValue = Double.random(in: 0..<1)
    
    let result = randomValue <= probability ? "won" : "lost"
    let netAmount: Int
    if result == "won" {
        let winnings = Double(amount) * (teamLine - 1)
        netAmount = Int(ceil(max(winnings, 1)))
    } else {
        netAmount = -amount
    }
    
    currentUser.addBetToHistory(team: team, odds: convertToMoneylineOdds(teamLine), amount: String(amount), outcome: result)
    currentUser.updateBalance(outcome: result, amount: netAmount)
    
    print("Result: \(result), Net Amount: \(netAmount), Team: \(team), odds: \(convertToMoneylineOdds(teamLine))")
    
    return (result, netAmount)
}

