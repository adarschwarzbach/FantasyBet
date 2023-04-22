//
//  OddsEndpoint.swift
//  Final2
//
//  Created by Kai Jennings on 4/10/23.
//

import Foundation
import CoreLocation

struct OddsEndpoint {
    static let baseUrl = "https://api.the-odds-api.com"
    static let apiKey = "e68c0763e4190284598bf47a75301574"
    
    enum QueryType {
        case sport
        case odds
        
        var queryName: String {
            switch self {
            case .sport: return "/v4/sports/?"
            case .odds: return "/v4/sports/upcoming/odds/?" //for odds i just made it the upcoming games and the region 'US' and the games h2h but this is something you can change
            }
        }
    }
    
    
    static func path(queryType: QueryType) -> String {
        let url = "\(baseUrl)/\(queryType.queryName)"
        let key = "apiKey=\(apiKey)"
        let region = "regions=us"
        let markets = "markets=h2h"
        return "\(url)\(key)&\(region)&\(markets)"
    }
}
