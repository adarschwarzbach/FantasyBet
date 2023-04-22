//
//  Sports.swift
//  Final2
//
//  Created by Kai Jennings on 4/11/23.
//

import Foundation
import CoreLocation

struct SportsAPIResponse: Decodable {
    var sports: [Sport]
    
    
    static func mock() -> SportsAPIResponse {
        SportsAPIResponse(sports: [Sport(key: "americanfootball_ncaaf", group: "American Football", title: "NCAAF", description: "US College Football", active: true, has_outrights: false), Sport(key: "baseball_mlb", group: "Baseball", title: "MLB", description: "Major League Baseball", active: true, has_outrights: false)])
    }
    
}
struct Sport: Decodable, Identifiable {
    var id: String {self.key}
    
    var key: String
    var group: String
    var title: String
    var description: String
    var active: Bool
    var has_outrights: Bool
}

//basically deleting this and won't have to use this
