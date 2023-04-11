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
  @State private var isTapped = false
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
          Text("\(video.views) views . \(video.duration)")
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
        .scaleEffect(isTapped ? 1.2 : 1.0) // Apply scale effect when tapped
        .onTapGesture {
          withAnimation(.spring()) { // Apply spring animation to smooth the scale effect
            self.isTapped.toggle()
          }
          print("Sending request to server for \(video.title) - \(video.youtubeURL)")
          songRepository.downloadSong(songMetadata: SongMetadata(id: video.id,
                                                                 title: video.title,
                                                                 duration: video.duration,
                                                                 youtubeURL: video.youtubeURL,
                                                                 thumbnailURL: video.thumbnailURL))
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
                   views: "13M",
                   duration: "3:37",
                   youtubeURL: "",
                   publishedAt: "3 years ago",
                   thumbnailURL: ""
                  ),
      isExpanded: true,
      songRepository: SongRepository()
    )
  }
}
