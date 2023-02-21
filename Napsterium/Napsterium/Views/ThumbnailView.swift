//
//  ThumbnailView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct ThumbnailView: View {
  let thumbnail: String
  var body: some View {
    AsyncImage(url: URL(string: thumbnail)) { phase in
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
  }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailView(thumbnail: "")
    }
}
