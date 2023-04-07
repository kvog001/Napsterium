//
//  SongManager.swift
//  Napsterium
//
//  Created by Kamber Vogli on 07.04.23.
//

import Foundation

class SongManager {
  static let shared = SongManager()
  let fileManager = FileManager.default
  let documentsUrl = try! FileManager.default.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
  
  func saveSong(_ song: Song) {
    let fileUrl = documentsUrl.appendingPathComponent("\(song.id).song")
    
    do {
      let songData = try PropertyListEncoder().encode(song)
      try songData.write(to: fileUrl)
    } catch {
      print("Error saving song: \(error.localizedDescription)")
    }
  }
  
  func deleteSong(_ song: Song) {
    let fileUrl = documentsUrl.appendingPathComponent("\(song.id).song")
    
    do {
      try fileManager.removeItem(at: fileUrl)
    } catch {
      print("Error deleting song: \(error.localizedDescription)")
    }
  }
  
  func loadSongs() -> [Song] {
    var songs: [Song] = []
    
    do {
      let songFiles = try fileManager.contentsOfDirectory(atPath: documentsUrl.path)
      
      for songFile in songFiles {
        if songFile.hasSuffix(".song") {
          let fileUrl = documentsUrl.appendingPathComponent(songFile)
          let songData = try Data(contentsOf: fileUrl)
          let song = try PropertyListDecoder().decode(Song.self, from: songData)
          songs.append(song)
        }
      }
    } catch {
      print("Error loading songs: \(error.localizedDescription)")
    }
    
    return songs
  }
  
  func loadSong(withId id: String) -> Song? {
    let fileUrl = documentsUrl.appendingPathComponent("\(id).song")
    
    guard let songData = try? Data(contentsOf: fileUrl) else {
      return nil
    }
    
    do {
      let song = try PropertyListDecoder().decode(Song.self, from: songData)
      return song
    } catch {
      print("Error loading song: \(error.localizedDescription)")
      return nil
    }
  }
}
