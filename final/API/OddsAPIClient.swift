//
//  OddsAPIClient.swift
//  Final2
//
//  Created by Kai Jennings on 4/10/23.
//

import Foundation
import CoreLocation

protocol OddsAPI {
    func fetchSports() async throws -> SportsAPIResponse
    func fetchOdds() async throws -> OddsAPIResponse
}

struct OddsAPIClient: OddsAPI, APIClient {
    let session: URLSession = .shared

    func fetchSports() async throws -> SportsAPIResponse {
        let path = OddsEndpoint.path(queryType: .sport)
        dump(path)
        let response: SportsAPIResponse = try await performRequest(url: path)
        return response
    }

    func fetchOdds() async throws -> OddsAPIResponse{
        let path = OddsEndpoint.path(queryType: .odds)
        dump(path)
        let response: OddsAPIResponse = try await performRequest(url: path)
        return response
    }

}

struct MockOddsAPIClient: OddsAPI {
    func fetchSports() async throws -> SportsAPIResponse {
        SportsAPIResponse.mock()
    }
    func fetchOdds() async throws -> OddsAPIResponse {
        OddsAPIResponse.mock()
    }

}
