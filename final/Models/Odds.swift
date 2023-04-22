////
////  Odds.swift
////  Final2
////
////  Created by Kai Jennings on 4/14/23.
////
//
import Foundation
import CoreLocation
import SwiftUI
//
struct OddsAPIResponse: Decodable {
    var Odds: [Odd]

    static func mock() -> OddsAPIResponse {
        OddsAPIResponse(Odds: [Odd(id: "bda33adca828c09dc3cac3a856aef176", sport_key: "americanfootball_nfl", home_team: "Tampa Bay Buccaneers", away_team: "Dallas Cowboys",
                                   bookmakers: [Bookmaker(key: "unibet", title: "Unibet", last_update: "2021-06-10T13:33:18Z",
                                                          markets: [Market(key: "h2h",
                                                                           outcomes: [Outcome(name: "Dallas Cowboys", price: 240),
                                                                                      Outcome(name: "Tampa Bay Buccaneers", price: -303)]
                                                                          )])])])
    }

//    init(from decoder: Decoder) throws {
//            do {
//                let container = try decoder.singleValueContainer()
//                self.Odds = try container.decode([Odd].self)
//            } catch DecodingError.typeMismatch {
//                let oddsDict = try decoder.singleValueContainer().decode([String:Odd].self)
//                self.Odds = Array(oddsDict.values)
//            }
//        }

    //I think this code is super close to be able to decode the dictionary but is just missing like one thing idk what

}

struct Odd: Decodable, Identifiable {
    var id: String
    var sport_key: String
    var commence_time: String?
    var home_team: String
    var away_team: String
    var bookmakers: [Bookmaker]

}

struct Bookmaker: Decodable, Identifiable {
    var key: String
    var title: String
    var last_update: String
    var markets: [Market]

    var id: String {self.key}
}

struct Market: Decodable, Identifiable {
    var key: String
    var outcomes: [Outcome]

    var id: String {self.key}
}

struct Outcome: Decodable, Identifiable {
    var name: String
    var price: Int

    var id: UUID = UUID()
}

