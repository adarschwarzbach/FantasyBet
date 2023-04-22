//
//  SportOdds.swift
//  final
//
//  Created by Adar Schwarzbach on 4/21/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct GetOdds: View {
    let sport: String

    @State private var games: [Game]?
    @State private var originalGames: [Game]?
    @State private var selectedTeam: Game.TeamLine?
    @State private var searchTerm = ""

    var body: some View {
        VStack {
            if let games = games {
                SearchBar(text: $searchTerm)
                    .padding(.horizontal)
                
                List(filteredGames) { game in
                    Button(action: {}) {
                        VStack(alignment: .leading) {
                            ForEach(game.teamLines.indices, id: \.self) { index in
                                let teamLine = game.teamLines[index]
                                let moneylineOdds = convertToMoneylineOdds(teamLine.price)
                                HStack {
                                    Button(action: {
                                        self.selectedTeam = teamLine
                                    }) {
                                        Text(teamLine.team)
                                    }
                                    Text(moneylineOdds)
                                }
                            }
                        }
                    }
                }



            } else {
                ProgressView()
            }
        }
        .navigationTitle("\(sport.capitalized) Odds")
        .onAppear {
            switch sport {
            case "baseball":
                BaseballOddsAPI.fetchMoneylineOdds { games in
                    self.games = games
                    self.originalGames = games
                }
            case "basketball":
                NBAOddsAPI.fetchMyBookieMoneylineOdds { games in
                    self.games = games
                    self.originalGames = games
                }
            default:
                break
            }
        }
        .sheet(item: $selectedTeam) { teamLine in
            TeamFormView(teamLine: teamLine)
        }
    }
    
    var filteredGames: [Game] {
        if searchTerm.isEmpty {
            return originalGames ?? []
        } else {
            return originalGames?.filter { game in
                game.teamLines.contains { teamLine in
                    teamLine.team.localizedCaseInsensitiveContains(searchTerm)
                }
            } ?? []
        }
    }
}



//struct SportOdds_Previews: PreviewProvider {
//    static var previews: some View {
//        SportOdds()
//    }
//}
