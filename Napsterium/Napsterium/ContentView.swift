//
//  ContentView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct ContentView: View {
  @State private var tabSelection = 1
  
  init() {
    UITabBar.appearance().barTintColor = .white
    UITabBar.appearance().backgroundColor = .yellow
  }
  
  var body: some View {
    TabView(selection: $tabSelection) {
      SongListView()
        .tabItem {
          Label("Play", systemImage: "play")
        }
        .tag(1)
      
      VideoListView()
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
        .tag(2)
    }
    .onAppear {
      tabSelection = 2
    }
    .accentColor(.black) // color of tabItem icons and search button
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
