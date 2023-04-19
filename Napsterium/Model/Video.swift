//
//  Video.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import Foundation

struct Video: Identifiable {
  let id: String
  let title: String
  let views: String
  let duration: String
  let youtubeURL: String
  let publishedAt: String
  var thumbnailURL: String
}
