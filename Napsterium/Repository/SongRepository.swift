//
//  SongRepository.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import Foundation

class SongRepository: ObservableObject {
  @Published var songs: [Song] = []
  private let songManager = SongManager.shared
  
  init() {
    print("loading songs ...")
    songs = songManager.loadSongs()
    print("songs.size = \(songs.count)")
  }
  
  /// sorts `songs` by `dateAdded`, latest first
  var sortedSongsByDate: [Song] {
    songs.sorted(by: { $0.dateAdded > $1.dateAdded })
  }
  
  func getNextSongAfter(song: Song) -> Song? {
    let sortedSongs = sortedSongsByDate
    let currentIndex = sortedSongs.firstIndex(of: song)
    if let currIndex = currentIndex {
      return sortedSongs[(currIndex + 1) % sortedSongs.count]
    } else {
      return nil
    }
  }
  
  func addSong(_ newSong: Song) {
    if songs.contains(where: { $0.id == newSong.id }) {
      print("song is already in the playlist") //TODO: check to not download twice beforehand
      return
    }
    songs.append(newSong)
    songManager.saveSong(newSong)
  }
  
  func deleteSong(_ song: Song) {
    guard let index = songs.firstIndex(of: song) else { return }
    songs.remove(at: index)
    songManager.deleteSong(song)
  }
  
  func updateSong(index: Array<Song>.Index, newSong: Song) {
    self.songs[index] = newSong
    songManager.saveSong(newSong)
  }
  
  func downloadSong(songMetadata: SongMetadata) {
    // Create a song object without mp3Data
    let songWithoutData = Song(
        id: songMetadata.id,
        title: songMetadata.title,
        mp3Data: nil,
        duration: 0,
        dateAdded: Date(),
        thumbnailURL: songMetadata.thumbnailURL
    )
    DispatchQueue.main.async {
      self.addSong(songWithoutData)
    }
    
    guard let url = URL(string: "https://kvogli.xyz:443/helloworld") else {
      print("Invalid URL")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = songMetadata.youtubeURL.data(using: .utf8)
    
    let config = URLSessionConfiguration.default
    config.tlsMinimumSupportedProtocolVersion = .TLSv10

    let session = URLSession(configuration: config)

    let task = session.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      } else if let data = data, let response = response as? HTTPURLResponse {
        print("Response status code: \(response.statusCode)")
        // TODO: handle status codes != 200
        
        let durationInSeconds = self.calcDurationInSeconds(fromTimeString: songMetadata.duration)
        print("saving song with duration \(durationInSeconds)")
        // Save the song to file system and to the repository
        let song = Song(id: songMetadata.id,
                        title: songMetadata.title,
                        mp3Data: data,
                        duration: durationInSeconds,
                        dateAdded: Date(),
                        thumbnailURL: songMetadata.thumbnailURL,
                        isDataLoaded: true)
        
        if let index = self.songs.firstIndex(where: { $0.id == song.id }) {
            DispatchQueue.main.async {
              self.updateSong(index: index, newSong: song)
            }
        }
      }
    }
    
    task.resume()
  }
  
  private func calcDurationInSeconds(fromTimeString timeString: String) -> Int {
      let timeComponents = timeString.split(separator: ":")
      if timeComponents.count == 2 {
          // Handle mm:ss format
          if let minutes = Int(timeComponents[0]),
             let seconds = Int(timeComponents[1]) {
              let totalSeconds = minutes * 60 + seconds
              return totalSeconds
          } else {
              // Invalid component format, failed to convert to integers
              return 0
          }
      } else if timeComponents.count == 3 {
          // Handle h:mm:ss format
          if let hours = Int(timeComponents[0]),
             let minutes = Int(timeComponents[1]),
             let seconds = Int(timeComponents[2]) {
              let totalSeconds = hours * 3600 + minutes * 60 + seconds
              return totalSeconds
          } else {
              // Invalid component format, failed to convert to integers
              return 0
          }
      } else {
          // Invalid time string, should have either 2 or 3 components (mm:ss or h:mm:ss)
          return 0
      }
  }

}


extension SongRepository {
  static let sampleSongs: [Song] = [
    Song(id: "1",
         title: "Ojitos Lindos",
         mp3Data: Data(),
         duration: 120,
         dateAdded: Date(),
         thumbnailURL: "https://i.ytimg.com/vi/tbPcoG7f5sI/hq720.jpg?sqp=-oaymwExCNAFEJQDSFryq4qpAyMIARUAAIhCGAHwAQH4Ac4FgALQBYoCDAgAEAEYfyArKBMwDw==&amp;rs=AOn4CLCnOleT_9stYXhbWQNtPQyzyxnuzw"
        ),
    
    Song(id: "2",
         title: "Cheap Thrills",
         mp3Data: Data(),
         duration: 120,
         dateAdded: Date(),
         thumbnailURL: "https://i.ytimg.com/vi/31crA53Dgu0/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLB9ISPAaF174upf9QMvw6ap1i3t4A"
        ),
    
    Song(id: "3",
         title: "Wake me up",
         mp3Data: Data(),
         duration: 120,
         dateAdded: Date(),
         thumbnailURL: "https://i.ytimg.com/vi/IcrbM1l_BoI/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLDEKeYfubdW5-4v8fkYI_8fv0UqhA"
        ),
    
    Song(id: "4",
         title: "I took a pill in Ibiza",
         mp3Data: Data(),
         duration: 120,
         dateAdded: Date(),
         thumbnailURL: "https://i.ytimg.com/vi/foE1mO2yM04/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLClo35Y31sLiEfDnHeC3Bzd5wWCzA"
        ),
    
    Song(id: "5",
         title: "Yonagumi",
         mp3Data: Data(),
         duration: 120,
         dateAdded: Date(),
         thumbnailURL: "https://i.ytimg.com/vi/doLMt10ytHY/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLDmMn9QkbSmIYlYJqk37BTynlQ_eQ"
        ),
    
    Song(id: "6",
         title: "Paradise",
         mp3Data: Data(),
         duration: 120,
         dateAdded: Date(),
         thumbnailURL: "https://i.ytimg.com/vi/6KW1PG41hCo/hq720.jpg?sqp=-oaymwExCNAFEJQDSFryq4qpAyMIARUAAIhCGAHwAQH4Af4JgALQBYoCDAgAEAEYZSBlKGUwDw==&amp;rs=AOn4CLAAw1Hy_hhc1a28XMNRgCfM4Dh_RQ"
        )
  ]
}
