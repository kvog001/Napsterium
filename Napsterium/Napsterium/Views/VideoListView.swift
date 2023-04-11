//
//  VideoListView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct VideoListView: View {
  @State private var query = ""
  @ObservedObject var songRepository: SongRepository
  @StateObject private var youTubeService = YouTubeService()
  @StateObject private var selectionVM = SelectionViewModel()
  
  var body: some View {
    VStack {
      // MARK: Search area
      HStack {
        TextField("Search songs on YouTube", text: $query)
          .textFieldStyle(.roundedBorder)
          .disableAutocorrection(true)
        
        Button {
          youTubeService.search(q: query)
        } label: {
          Text("Search")
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8))
        .controlSize(.regular)
      }
      .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 10))
      
      // MARK: Results
      List {
        Section {
          ForEach(youTubeService.results) { video in
            VideoRowView(
              video: video,
              isExpanded: selectionVM.selection.contains(video.id),
              songRepository: songRepository
            )
              .onTapGesture {
                selectionVM.selectOrDeselect(videoId: video.id)
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
    VideoListView(songRepository: SongRepository())
  }
}
