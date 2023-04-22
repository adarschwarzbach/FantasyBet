//
//  TabContainer.swift
//  Final2
//
//  Created by Kai Jennings on 4/10/23.
//

import SwiftUI

struct TabContainer: View {
  
  var body: some View {
    TabView{
        
      NavigationView {
        HomeDetails()
      }
      .tabItem {
        Label("Home", systemImage: "house")
      }
      NavigationView {
        SearchView()
      }
      .tabItem {
          Label("Users", systemImage: "magnifyingglass")
      }
        
        NavigationView {
          PickSport()
        }
        .tabItem {
            Label("Bet", systemImage: "suit.spade")
        }
      
    }

  }
}

struct TabContainer_Previews: PreviewProvider {
  static var previews: some View {
    TabContainer()
  }
}
