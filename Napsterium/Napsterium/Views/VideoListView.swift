//
//  VideoListView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

import SwiftUI

struct VideoListView: View {
  @State private var query = ""
  @StateObject private var viewModel = VideoListViewModel()
  
  var body: some View {
    VStack {
      HStack {
        TextField("Search videos", text: $query)
          .padding()
        
        Button {
          viewModel.search(query: query)
        } label: {
          Text("Search")
        }
        
      }
      
      List {
        Section {
          ForEach(viewModel.videos) { video in
            VideoRowView(video: video, isExpanded: false)
          }
        }
      }
    }
  }
}


struct VideoListView_Previews: PreviewProvider {
  static var previews: some View {
    VideoListView()
  }
}
