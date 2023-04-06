//
//  SongStore.swift
//  Napsterium
//
//  Created by Kamber Vogli on 02.03.23.
//

import Foundation

class SongStore: ObservableObject {
  @Published var songs: [Song] = []
  
  private static func fileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                   in: .userDomainMask,
                                   appropriateFor: nil,
                                   create: false)
      .appendingPathComponent("xyz.kvogli.napsterium.songs.data")
  }
  
  static func load(completion: @escaping (Result<[Song], Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let fileURL = try fileURL()
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
          DispatchQueue.main.async {
            completion(.success([]))
          }
          return
        }
        let storedSongs = try PropertyListDecoder().decode([Song].self, from: file.availableData)
        DispatchQueue.main.async {
          completion(.success(storedSongs))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
  /// Persist `songs` in the file system.
  static func save(songs: [Song], completion: @escaping (Result<Int, Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let data = try PropertyListEncoder().encode(songs)
        let outfile = try fileURL()
        try data.write(to: outfile)
        DispatchQueue.main.async {
          completion(.success(songs.count))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
}
