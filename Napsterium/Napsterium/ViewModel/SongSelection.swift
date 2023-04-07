//
//  SongSelection.swift
//  Napsterium
//
//  Created by Kamber Vogli on 07.04.23.
//

import Foundation

class SongSelection: ObservableObject {
  @Published var selectedSong: Song?
  
  func select(song: Song) {
    selectedSong = song
  }
}
