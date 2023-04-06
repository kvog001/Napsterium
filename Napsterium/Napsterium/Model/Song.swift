//
//  Song.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import Foundation

struct Song: Identifiable, Codable {
  let id: String
  let title: String
  var thumbnailURL: String
  let mp3Data: Data
}
