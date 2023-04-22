//
//  PickSport.swift
//  final
//
//  Created by Adar Schwarzbach on 4/21/23.
//

import SwiftUI



struct PickSport: View {
    struct SportOption: Identifiable {
        let id = UUID()
        let sport: String
        let imageName: String
    }

    let sports: [SportOption] = [
        SportOption(sport: "baseball", imageName: "baseball"),
        SportOption(sport: "basketball", imageName: "basketball"),
    ]

    var body: some View {
        NavigationView {
            List(sports) { sport in
                NavigationLink(destination: GetOdds(sport: sport.sport)) {
                    HStack {
                        Image(systemName: sport.imageName)
                        Text(sport.sport.capitalized)
                    }
                }
            }
        }
        .navigationTitle("Sports")
    }
}


struct PickSport_Previews: PreviewProvider {
    static var previews: some View {
        PickSport()
    }
}
