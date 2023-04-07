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
    songs = songManager.loadSongs()
  }
  
  func addSong(_ song: Song) {
    songs.append(song)
    songManager.saveSong(song)
  }
  
  func deleteSong(_ song: Song) {
    guard let index = songs.firstIndex(of: song) else { return }
    songs.remove(at: index)
    songManager.deleteSong(song)
  }
  
  func downloadSong(youTubeLink: String,  ytThumbnail: String, ytTitle: String) {
    guard let url = URL(string: "https://kvogli.xyz:443/helloworld") else {
      print("Invalid URL")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = youTubeLink.data(using: .utf8)
    
    let config = URLSessionConfiguration.default
    config.tlsMinimumSupportedProtocolVersion = .TLSv10

    let session = URLSession(configuration: config)

    let task = session.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      } else if let data = data, let response = response as? HTTPURLResponse {
        print("Response status code: \(response.statusCode)")
        
        // Save the song to file system
        let song = Song(id: ytTitle, title: ytTitle, thumbnailURL: ytThumbnail, mp3Data: data)
        DispatchQueue.main.async {
          self.addSong(song)
        }
      }
    }
    
    task.resume()
  }
}


extension SongRepository {
  static let sampleSongs: [Song] = [
    Song(id: "1", title: "Ojitos Lindos",
         thumbnailURL: "https://i.ytimg.com/vi/tbPcoG7f5sI/hq720.jpg?sqp=-oaymwExCNAFEJQDSFryq4qpAyMIARUAAIhCGAHwAQH4Ac4FgALQBYoCDAgAEAEYfyArKBMwDw==&amp;rs=AOn4CLCnOleT_9stYXhbWQNtPQyzyxnuzw",
         mp3Data: Data()
        ),
    
    Song(id: "2", title: "Cheap Thrills",
         thumbnailURL: "https://i.ytimg.com/vi/31crA53Dgu0/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLB9ISPAaF174upf9QMvw6ap1i3t4A",
         mp3Data: Data()
        ),
    
    Song(id: "3", title: "Wake me up",
         thumbnailURL: "https://i.ytimg.com/vi/IcrbM1l_BoI/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLDEKeYfubdW5-4v8fkYI_8fv0UqhA",
         mp3Data: Data()
        ),
    
    Song(id: "4", title: "I took a pill in Ibiza",
         thumbnailURL: "https://i.ytimg.com/vi/foE1mO2yM04/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLClo35Y31sLiEfDnHeC3Bzd5wWCzA",
         mp3Data: Data()
        ),
    
    Song(id: "5", title: "Yonagumi",
         thumbnailURL: "https://i.ytimg.com/vi/doLMt10ytHY/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLDmMn9QkbSmIYlYJqk37BTynlQ_eQ",
         mp3Data: Data()
        ),
    
    Song(id: "6", title: "Paradise",
         thumbnailURL: "https://i.ytimg.com/vi/6KW1PG41hCo/hq720.jpg?sqp=-oaymwExCNAFEJQDSFryq4qpAyMIARUAAIhCGAHwAQH4Af4JgALQBYoCDAgAEAEYZSBlKGUwDw==&amp;rs=AOn4CLAAw1Hy_hhc1a28XMNRgCfM4Dh_RQ",
         mp3Data: Data()
        )
  ]
}
