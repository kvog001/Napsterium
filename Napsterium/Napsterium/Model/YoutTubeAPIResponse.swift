//
//  YoutTubeAPIResponse.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import Foundation

struct YouTubeAPIResponse: Codable {
    let items: [APIItem]
}

struct APIItem: Codable {
    let id: APIItemId
    let snippet: APISnippet
}

struct APIItemId: Codable {
    let videoId: String
}

struct APISnippet: Codable {
    let title: String
    let thumbnails: APIThumbnails
}

struct APIThumbnails: Codable {
    let medium: APIThumbnail
}

struct APIThumbnail: Codable {
    let url: String
}
