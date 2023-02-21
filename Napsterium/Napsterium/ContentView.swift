//
//  ContentView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct ContentView: View {
  @State private var tabSelection = 1
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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
