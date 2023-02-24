//
//  VideoListViewModel.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import Foundation

class VideoListViewModel: ObservableObject {
  let maxResults = 50
  let apiKey = "AIzaSyCUWYjsCsdFf3XjfbE71uiN0Ia2jlREtho"
  @Published var videos: [Video] = []
  @Published var selection: Set<String> = []
  
  func search(query: String) {
    let noWhitespaceQuery = query.replacingOccurrences(of: " ", with: "%20")
    let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(noWhitespaceQuery)&key=\(apiKey)&maxResults=\(maxResults)"
    if let url = URL(string: urlString) {
      URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
          do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(YouTubeAPIResponse.self, from: data)
            DispatchQueue.main.async {
              self.videos = response.items.map {
                Video(
                  id: $0.id.videoId,
                  title: $0.snippet.title,
                  thumbnailURL: $0.snippet.thumbnails.medium.url,
                  youtubeLink: "https://www.youtube.com/watch?v=\($0.id.videoId)"
                )
              }
            }
          } catch {
            print("Error decoding response: \(error)")
          }
        } else if let error = error {
          print("Error fetching videos: \(error)")
        }
      }.resume()
    }
  }
  
  func selectOrDeselect(videoId: String) {
    if selection.contains(videoId) {
      selection.remove(videoId)
    } else {
      selection.insert(videoId)
    }
  }
  
  func downloadSong(youTubeLink: String) {
    guard let url = URL(string: "https://193.233.202.119:8080/helloworld") else {
      print("Invalid URL")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let text = "Hello from iOS app, Napsterium!"
    request.httpBody = text.data(using: .utf8)
    
    let config = URLSessionConfiguration.default
    config.tlsMinimumSupportedProtocolVersion = .TLSv10

    let session = URLSession(configuration: config)

    let task = session.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      } else if let data = data, let response = response as? HTTPURLResponse {
        print("Response status code: \(response.statusCode)")
        // handle response data
        print(data)
      }
    }
    
    task.resume()
  }
  
}
