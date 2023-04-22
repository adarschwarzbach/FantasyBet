//
//  SportsView.swift
//  Final2
//
//  Created by Kai Jennings on 4/11/23.
//

import SwiftUI
import Foundation

struct SportsView: View {
    @EnvironmentObject var sportsLoader: SportsLoader
    
    var body: some View {
        VStack{
            switch sportsLoader.state{
            case .idle: Color.clear
            case .loading: ProgressView()
            case .failed(let error): Text("Error \(error.localizedDescription)")
            case .success(let data): //connects to HeadlinesLoader and declare
                SportsDisplay(data: data) // this is unsure w variable
            }
        }
        .task {
            await sportsLoader.loadSportData()
        }
    }
}

struct SportsDisplay: View {
    @EnvironmentObject var sportsLoader: SportsLoader
    
    let data: [Sport]
    
    var body: some View {
        List(data){ data in
            
            VStack(alignment: .leading) {
                Text(data.title ?? "")
                    .font(.headline)
                Text(data.description ?? "")
                    .font(.subheadline)
                    .italic()
            }
            Spacer()
            }
        .padding(10)
        
        }
    }

struct SportsView_Previews: PreviewProvider {
    static var previews: some View {
        SportsView()
            .environmentObject(SportsLoader(apiClient: MockOddsAPIClient()))
        //some error regarding dictionary that have to fix to make buttons work
    }
}
