//
//  VideoRowView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct VideoRowView: View {
  let video: Video
  let isExpanded: Bool
  @ObservedObject var songRepository: SongRepository
  
  var body: some View {
    VStack {
      HStack {
        ThumbnailView(thumbnail: video.thumbnailURL)
          .frame(width: 180, height: 100)
        
        Spacer()
        
        VStack(spacing: 20) {
          Text(video.title)
            .lineLimit(2)
            .font(.body)
          Text("512M views . 1 year ago")
            .font(.caption2)
        }
      }
      
      if isExpanded {
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .frame(width: 150, height: 50)
          Text("Add to playlist")
            .foregroundColor(.white)
        }
        .onTapGesture {
          print("Sending request to server for \(video.title) - \(video.youtubeLink)")
          songRepository.downloadSong(youTubeLink: video.youtubeLink,
                                      ytThumbnail: video.thumbnailURL,
                                      ytTitle: video.title)
        }
      }
    }
  }
}

struct VideoRowView_Previews: PreviewProvider {
  static var previews: some View {
    VideoRowView(
      video: Video(id: "uuid",
                   title: "Ojitos lindos bad bunny - james west singing till midnight",
                   thumbnailURL: "",
                   youtubeLink: ""),
      isExpanded: true,
      songRepository: SongRepository()
    )
  }
}
