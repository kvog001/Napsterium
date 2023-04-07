//
//  VideoListView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct VideoListView: View {
  @State private var query = ""
  @StateObject private var viewModel = VideoListViewModel()
  
  var body: some View {
    VStack {
      // MARK: Search area
      HStack {
        TextField("Search songs on YouTube", text: $query)
          .textFieldStyle(.roundedBorder)
          .disableAutocorrection(true)
        
        Button {
          viewModel.search(query: query)
        } label: {
          Text("Search")
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8))
        .controlSize(.regular)
      }
      .padding()
      
      // MARK: Results
      List {
        Section {
          ForEach(viewModel.videos) { video in
            VideoRowView(
              video: video,
              isExpanded: viewModel.selection.contains(video.id)
            )
              .onTapGesture {
                viewModel.selectOrDeselect(videoId: video.id)
                // send request to server
                viewModel.downloadSong(youTubeLink: video.youtubeLink)
              }
          }
        } header: {
          Text("Results")
        }
      }
      .listStyle(.plain)
    }
  }
}


struct VideoListView_Previews: PreviewProvider {
  static var previews: some View {
    VideoListView()
  }
}
