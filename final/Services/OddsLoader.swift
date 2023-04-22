//
//  OddsLoader.swift
//  Final2
//
//  Created by Kai Jennings on 4/15/23.
//

import Foundation

class OddsLoader: ObservableObject {
  let apiClient: OddsAPI

  @Published private(set) var state: LoadingState = .idle

  enum LoadingState {
    case idle
    case loading
    case success(data: [Odd])
    case failed(error: Error)
  }

  init(apiClient: OddsAPI) {
    self.apiClient = apiClient
  }

  @MainActor
  func loadOddData() async {
    self.state = .loading
    do {
      let odd = try await apiClient.fetchOdds()
        self.state = .success(data: odd.Odds)
    } catch {
      self.state = .failed(error: error)
    }
  }
}
