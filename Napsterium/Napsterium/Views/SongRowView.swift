//
//  SongRowView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct SongRowView: View {
  let song: Song
  var body: some View {
    HStack {
      ThumbnailView(thumbnail: song.thumbnailURL)
        .frame(width: 65, height: 85, alignment: .leading)
      
      Text(song.title)
        .lineLimit(2)
        .font(.body)
    }
  }
}

struct SongRowView_Previews: PreviewProvider {
  static var previews: some View {
    SongRowView(song: SongRepository.sampleSongs[0])
  }
}
