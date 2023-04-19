//
//  Song.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import Foundation

/// `id: String` is the YouTube id of the song
/// `duration: Int` is the duration of the song in seconds
struct Song: Identifiable, Codable, Equatable {
  let id: String
  let title: String
  let mp3Data: Data?
  let duration: Int
  let dateAdded: Date
  var thumbnailURL: String
  var isDataLoaded = false
  
  static func == (lhs: Song, rhs: Song) -> Bool {
    return lhs.id == rhs.id
                && lhs.title == rhs.title
                && lhs.duration == rhs.duration
                && lhs.dateAdded == rhs.dateAdded
                && lhs.thumbnailURL == rhs.thumbnailURL
                && lhs.isDataLoaded == rhs.isDataLoaded
  }
}

struct SongMetadata {
  let id: String
  let title: String
  let duration: String
  let youtubeURL: String
  let thumbnailURL: String
}
