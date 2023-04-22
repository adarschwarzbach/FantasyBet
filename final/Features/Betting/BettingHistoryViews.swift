//
//  BettingHistoryViews.swift
//  final
//
//  Created by Adar Schwarzbach on 4/22/23.
//

import SwiftUI

struct BettingHistoryView: View {
    let bettingHistory: [CompletedBet]
    
    var body: some View {
        VStack {
            Text("Betting History:")
                .font(.title2)
                .padding(.top)
            
            if bettingHistory.isEmpty {
                Text("This user has not made any bets yet.")
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                    .padding(.horizontal)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(bettingHistory, id: \.self) { bet in
                            HStack {
                                Text(bet.team)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text("(\(bet.odds))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(bet.outcome == "won" ? "+" : "-")$\(bet.amount)")
                                    .foregroundColor(bet.outcome == "won" ? .green : .red)
                            }
                            .padding(.vertical)
                            .padding(.horizontal)
                        }
                    }
                }
                .cornerRadius(10)
            }
        }
    }
}


struct HomeBettingHistory: View {
    let bettingHistory: [CompletedBet]
    
    var body: some View {
        VStack {
            Text("Betting History:")
                .font(.title2)
                .padding(.top)
            
            if bettingHistory.isEmpty {
                Text("You have not made any bets yet.")
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                    .padding(.horizontal)
            } else {
                List(bettingHistory, id: \.self) { bet in
                    HStack {
                        Text(bet.team)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("(\(bet.odds))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(bet.outcome == "won" ? "+" : "-")$\(bet.amount)")
                            .foregroundColor(bet.outcome == "won" ? .green : .red)
                    }
                }
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}
