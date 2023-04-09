//
//  YouTubeService.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import Foundation
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_YouTube

class YouTubeService: ObservableObject {
  let maxResults = 50
  let apiKey = "AIzaSyCUWYjsCsdFf3XjfbE71uiN0Ia2jlREtho"
  @Published var videos: [Video] = []
  
  func search(query: String) {
    let queryWithNoWhitespaces = query.replacingOccurrences(of: " ", with: "%20")
    let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(queryWithNoWhitespaces)&key=\(apiKey)&maxResults=\(maxResults)"
    
    let logDate = Date()
    print("\(logDate): YouTube API Request URL: \(urlString)")
    
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
      }
      .resume()
    }
  }
  
  let service = GTLRYouTubeService()
  func foo() {
    service.apiKey = "AIzaSyCUWYjsCsdFf3XjfbE71uiN0Ia2jlREtho"

    // Set up the search query
    let query = GTLRYouTubeQuery_SearchList.query(withPart: ["id","snippet"])
    query.q = "swift programming"

    // Execute the search request
    service.executeQuery(query) { (_, result, error) in
        guard error == nil else {
            print("An error occurred: \(error!)")
            return
        }

        // Process the search results
        if let searchResult = result as? GTLRYouTube_SearchListResponse {
            for video in searchResult.items ?? [] {
                print("\(video.snippet?.title ?? "")")
            }
        }
    }
  }
}
