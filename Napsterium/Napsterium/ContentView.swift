//
//  ContentView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct ContentView: View {
  @State private var tabSelection = 1
  @StateObject private var songRepository = SongRepository()
  @StateObject private var audioPlayerViewModel = AudioPlayerViewModel()
  
  init() {
    UITabBar.appearance().barTintColor = .yellow
    UITabBar.appearance().backgroundColor = .yellow
  }
  
  var body: some View {
    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
      TabView(selection: $tabSelection) {
        SongListView(songRepository: songRepository, audioPlayerViewModel: audioPlayerViewModel)
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
        tabSelection = 1
      }
      .accentColor(.black) // color of tabItem icons and search button
      
      AudioPlayerView(audioPlayerViewModel: audioPlayerViewModel)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
