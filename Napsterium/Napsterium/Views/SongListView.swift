//
//  SongListView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct SongListView: View {
  
    var body: some View {
      List {
        Section {
          ForEach(SongRepository.sampleSongs) { song in
            SongRowView(song: song)
          }
        } header: {
          Text("All songs")
            .font(.title)
        }
      }
      .listStyle(.plain)
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
