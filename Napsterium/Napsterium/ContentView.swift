//
//  ContentView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct ContentView: View {
  @State private var tabSelection = 1
  @State private var expand = false
  @Namespace var animation
  @StateObject private var songRepository = SongRepository()
  @StateObject private var songSelection = SongSelection()
  
  init() {
    UITabBar.appearance().barTintColor = .yellow
    UITabBar.appearance().backgroundColor = .yellow
  }
  
  var body: some View {
    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
      TabView(selection: $tabSelection) {
        SongListView(songs: $songRepository.songs, songSelection: songSelection)
//        {
//          songRepository.save(songs: songRepository.songs) { result in
//              if case .failure(let error) = result {
//                  fatalError(error.localizedDescription)
//              }
//          }
//        }
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
        // happens now at init of songRepository (line 14)
//        SongStore.load { result in
//            switch result {
//            case .failure(let error):
//                fatalError(error.localizedDescription)
//            case .success(let songs):
//                store.songs = songs
//            }
//        }
        tabSelection = 2
      }
      .accentColor(.black) // color of tabItem icons and search button
      
      SongPlayer(animation: animation,
                 expand: $expand,
                 songSelection: songSelection)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
