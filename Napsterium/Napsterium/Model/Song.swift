//
//  Song.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import Foundation

/// `id: String` is the YouTube id of the video
struct Song: Identifiable, Codable, Equatable {
  let id: String
  let title: String
  var thumbnailURL: String
  let mp3Data: Data
  let dateAdded: Date
//  let duration: String
  
  static func == (lhs: Song, rhs: Song) -> Bool {
    return lhs.id == rhs.id
  }
}
