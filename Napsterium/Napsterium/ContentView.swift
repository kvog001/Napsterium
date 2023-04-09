//
//  ContentView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct ContentView: View {
//  @Namespace var animation
//  @State private var expand = false
  @State private var tabSelection = 1
  @StateObject private var songRepository = SongRepository()
  @StateObject private var songSelection = SongSelection()
  
  init() {
    UITabBar.appearance().barTintColor = .yellow
    UITabBar.appearance().backgroundColor = .yellow
  }
  
  var body: some View {
    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
      TabView(selection: $tabSelection) {
        SongListView(songRepository: songRepository, songSelection: songSelection)
          .tabItem {
            Label("Play", systemImage: "play")
          }
          .tag(1)
        
        VideoListView(songRepository: songRepository)
          .tabItem {
            Label("Search", systemImage: "magnifyingglass")
          }
          .tag(2)
      }
      .onAppear {
        tabSelection = 2
      }
      .accentColor(.black) // color of tabItem icons and search button
      
      AudioPlayerView(songSelection: songSelection)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
