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
          AsyncImage(url: URL(string: video.thumbnailURL)) { phase in
              switch phase {
              case .empty:
                  ProgressView()
              case .success(let image):
                  image
                      .resizable()
                      .aspectRatio(contentMode: .fit)
              case .failure:
                  Image(systemName: "photo")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
              @unknown default:
                  EmptyView()
              }
          }
          .frame(width: 180)
          
          Spacer()
          
          VStack(spacing: 20) {
              Text("Title")
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
              .clipShape(RoundedRectangle(cornerRadius: 15))
              .background(Color.black)
              .foregroundColor(.white)
          }
          .buttonBorderShape(.roundedRectangle)

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
          isExpanded: false
        )
    }
}
