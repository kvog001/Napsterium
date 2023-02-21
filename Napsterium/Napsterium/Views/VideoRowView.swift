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
  
  var body: some View {
    VStack {
      HStack {
        ThumbnailView(thumbnail: video.thumbnailURL)
        .frame(width: 180)
        
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
        Button {
          print("TODO: add song to playlist")
        } label: {
          Text("Add song to playlist")
            .foregroundColor(.white)
        }
        .padding()
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
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
      isExpanded: true
    )
  }
}
