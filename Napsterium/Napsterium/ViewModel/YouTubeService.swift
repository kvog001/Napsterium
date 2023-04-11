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
  @Published var results: [Video] = []
  private let service = GTLRYouTubeService()
  
  func search(q: String) {
    results = []
    service.apiKey = "AIzaSyCUWYjsCsdFf3XjfbE71uiN0Ia2jlREtho"
    
    // Set up the search query
    let query = GTLRYouTubeQuery_SearchList.query(withPart: ["id","snippet"])
    query.q = q
    query.maxResults = 50
    
    // Execute the search request
    service.executeQuery(query) { (_, result, error) in
      guard error == nil else {
        print("An error occurred: \(error!)")
        return
      }
      
      // Process the search results
      if let searchResult = result as? GTLRYouTube_SearchListResponse {
        let videoIds = searchResult.items?.compactMap { $0.identifier?.videoId } ?? []
        let videoDetailsQuery = GTLRYouTubeQuery_VideosList.query(withPart: ["contentDetails","statistics"])
        videoDetailsQuery.identifier = videoIds
        self.service.executeQuery(videoDetailsQuery) { (_, result, error) in
          guard error == nil else {
            print("An error occurred: \(error!)")
            return
          }
          if let videoResult = result as? GTLRYouTube_VideoListResponse {
            let videos = videoResult.items ?? []
            for video in searchResult.items ?? [] {
              if let videoData = videos.first(where: { $0.identifier == video.identifier?.videoId }),
                 let duration = videoData.contentDetails?.duration,
                 let viewCount = videoData.statistics?.viewCount {
                let videoId = video.identifier?.videoId ?? ""
                let title = video.snippet?.title ?? ""
                let thumbnailUrl = video.snippet?.thumbnails?.defaultProperty?.url ?? ""
                let youtubeUrl = "https://www.youtube.com/watch?v=\(videoId)"
//                print("\(title) - \(videoId) - \(thumbnailUrl) - \(youtubeUrl) - \(duration) - \(viewCount)")
                
                let viewsString = self.viewsString(fromViewCount: viewCount)
                let durationString = self.durationString(fromISO8601Duration: duration)
                let result = Video(id: videoId,
                                   title: title,
                                   views: "\(viewsString)",
                                   duration: "\(durationString)",
                                   youtubeURL: youtubeUrl,
                                   publishedAt: "",
                                   thumbnailURL: thumbnailUrl
                )
                self.results.append(result)
              }
            }
          }
        }
      }
    }
  }
  
  private func viewsString(fromViewCount viewCount: NSNumber) -> String {
    let viewCountInt = viewCount.intValue
    if viewCountInt > 1000000000 {
      let nrOfBillions = viewCountInt / 1000000000
      return "\(nrOfBillions)B"
    } else if viewCountInt > 1000000 {
      let nrOfMillions = viewCountInt / 1000000
      return "\(nrOfMillions)M"
    } else if viewCountInt > 1000 {
      let nrOfThousands = viewCountInt / 1000
      return "\(nrOfThousands)K"
    } else {
      return "\(viewCountInt)"
    }
  }
  
  private func durationString(fromISO8601Duration duration: String) -> String {
    guard let durationRegex = try? NSRegularExpression(pattern: #"PT(\d+H)?(\d+M)?(\d+S)?"#),
          let match = durationRegex.firstMatch(in: duration, range: NSRange(duration.startIndex..., in: duration))
    else {
      return ""
    }
    
    var hours = 0, minutes = 0, seconds = 0
    
    if let hourRange = Range(match.range(at: 1), in: duration) {
      hours = Int(duration[hourRange].dropLast()) ?? 0
    }
    
    if let minuteRange = Range(match.range(at: 2), in: duration) {
      minutes = Int(duration[minuteRange].dropLast()) ?? 0
    }
    
    if let secondRange = Range(match.range(at: 3), in: duration) {
      seconds = Int(duration[secondRange].dropLast()) ?? 0
    }
    
    var durationString = ""
    
    if hours > 0 {
      durationString += "\(hours):"
    }
    
    durationString += String(format: "%02d:%02d", minutes, seconds)
    
    return durationString
  }
}
