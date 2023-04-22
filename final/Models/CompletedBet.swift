//
//  CompletedBet.swift
//  final
//
//  Created by Adar Schwarzbach on 4/22/23.
//

import SwiftUI
import Foundation

struct CompletedBet: Codable, Hashable {
    let amount: String
    let odds: String
    let outcome: String
    let team: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(odds)
        hasher.combine(outcome)
        hasher.combine(team)
    }
}
