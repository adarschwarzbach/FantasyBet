//
//  GetGameOdds.swift
//  final
//
//  Created by Adar Schwarzbach on 4/21/23.
//

import SwiftUI
import Foundation



class NBAOddsAPI {
    static let apiKey = "aa36d73546219124add99dd8595f46e0"
    static let baseUrl = "https://api.the-odds-api.com/v4"
    static let nbaSportKey = "basketball_nba"
    static let myBookieSiteKey = "mybookie"
    
    static func fetchMyBookieMoneylineOdds(completion: @escaping ([Game]?) -> Void) {
        let urlString = "\(baseUrl)/sports/\(nbaSportKey)/odds/?regions=us&mkt=moneyline&site=\(myBookieSiteKey)&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching moneyline odds: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response: \(response.debugDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }
        
            var games: [Game] = []

            do {
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    print("Failed to parse JSON")
                    return
                }

                for jsonDictionary in jsonArray {
                    if let bookmakers = jsonDictionary["bookmakers"] as? [[String: Any]] {
                        for bookmaker in bookmakers {
                            if let key = bookmaker["key"] as? String, key == "mybookieag",
                               let markets = bookmaker["markets"] as? [[String: Any]] {
                                for market in markets {
                                    if let outcomes = market["outcomes"] as? [[String: Any]] {
                                        let teamLines = outcomes.compactMap { outcome -> Game.TeamLine? in
                                            guard let name = outcome["name"] as? String,
                                                  let price = outcome["price"] as? Double else {
                                                return nil
                                            }
                                            return Game.TeamLine(team: name, price: price)
                                        }
                                        let game = Game(teamLines: teamLines)
                                        games.append(game)
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            
            completion(games)
        }.resume()
    }

}


