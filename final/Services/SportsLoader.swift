//
//  SportsLoader.swift
//  Final2
//
//  Created by Kai Jennings on 4/11/23.
//

import Foundation

class SportsLoader: ObservableObject {
  let apiClient: OddsAPI

  @Published private(set) var state: LoadingState = .idle

  enum LoadingState {
    case idle
    case loading
    case success(data: [Sport])
    case failed(error: Error)
  }

  init(apiClient: OddsAPI) {
    self.apiClient = apiClient
  }

  @MainActor
  func loadSportData() async {
    self.state = .loading
    do {
      let sport = try await apiClient.fetchSports()
        self.state = .success(data: sport.sports)
    } catch {
      self.state = .failed(error: error)
    }
  }
}
