//
//  SongRowView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct SongRowView: View {
  let alertButtonDelete = "Remove"
  @State private var showDeleteAlert = false
  let song: Song
  @ObservedObject var songRepository: SongRepository
  
  var body: some View {
    HStack {
      ZStack {
        ThumbnailView(thumbnail: song.thumbnailURL)
          
        if !song.isDataLoaded {
          ProgressView()
            .scaleEffect(1.0, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
        }
      }
      .frame(width: 55, height: 55, alignment: .leading)
      Text(song.title)
        .lineLimit(2)
        .font(.body)
        .foregroundColor(.white)
      Spacer() // this spacer pushes thumbnail and title to the left :)
        // and the heart to the right end
      Image(systemName: "heart.fill")
        .foregroundColor(.yellow)
        .padding()
        .onTapGesture {
          showDeleteAlert = true
          // TODO: song is deleted before alert is confirmed: wait for alert to show up and user press delete otherwise ignore
          songRepository.deleteSong(song)
        }
        .alert(isPresented: $showDeleteAlert) {
          Alert(
            title: Text("Remove song?"),
            message: Text("Press \(alertButtonDelete) to remove song from your playlist"),
            primaryButton: .destructive(Text(alertButtonDelete)),
            secondaryButton: .cancel()
          )
        }
    }
    .frame(alignment: .leading)
  }
}

struct SongRowView_Previews: PreviewProvider {
  static var previews: some View {
    SongRowView(song: SongRepository.sampleSongs[0], songRepository: SongRepository())
  }
}
