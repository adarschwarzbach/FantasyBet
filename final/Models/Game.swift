//
//  Game.swift
//  final
//
//  Created by Adar Schwarzbach on 4/22/23.
//

import SwiftUI
import Foundation

struct Game: Identifiable {
    let id = UUID()
    let teamLines: [TeamLine]
    
    struct TeamLine: Identifiable {
        let id = UUID()
        let team: String
        let price: Double
    }
}
