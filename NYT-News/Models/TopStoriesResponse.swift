//
//  GetTopStories.swift
//  NYT
//
//  Created by Jubie Alade on 1/25/22.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

public struct TopStoriesResponse: Codable {
    let results: [TopStory]
}

struct TopStory: Codable {
    let title, abstract, url, byline: String
    let published_date: Date
    let multimedia: [Multimedia]?
    
    var articleURL: URL {
        let url = url
        return URL(string: url)!
    }
        
    var date: String {
        "\(relativeDateFormatter.localizedString(for: published_date, relativeTo: Date()))"
    }
}

struct Multimedia: Codable {
    let url: String
}
