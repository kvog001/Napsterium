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
  var body: some View {
    HStack {
      ThumbnailView(thumbnail: song.thumbnailURL)
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
          print("Heart of \(song.title) was pressed!")
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
    SongRowView(song: SongRepository.sampleSongs[0])
  }
}
