//
//  ConvertToMoneylineOdds.swift
//  final
//
//  Created by Adar Schwarzbach on 4/21/23.
//

import Foundation


func convertToMoneylineOdds(_ price: Double) -> String {
    if price > 2 {
        let payout = (price - 1) * 100
        return "+\(Int(payout))"
    } else {
        let payout = 100 / (price - 1)
        return "-\(Int(payout))"
    }
}
