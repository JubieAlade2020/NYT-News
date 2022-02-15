//
//  APICaller.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import Foundation

final class APICaller {
    
    @Published var category: String
    @Published var statusCode: Int?
    
    init(category: String) {
        self.category = category
    }
    
    /// Gets the articles from the API.
    ///
    /// After getting the data from the API, the data is decoded using the TopStoriesResponse.
    ///
    /// - Returns: Returns the data in a form that's accessible to us.
    func getTopStories(category: String) async throws -> TopStoriesResponse {
        let urlSession = URLSession.shared
        let url = URL(string: Constants.base+category+".json?api-key=52ZUl4wMOV7BwRGlWdFOJJWSQYq8zHW1") //<<<<<<<< key needed 🔐
        let (data, response) = try await urlSession.data(from: url!)
        
        if let httpResponse = response as? HTTPURLResponse {
            statusCode = httpResponse.statusCode
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        guard let storyResponse = try? jsonDecoder.decode(TopStoriesResponse.self, from: data) else {
            throw APIError.noKeyProvided
        }
        return storyResponse
    }
    
    // 52ZUl4wMOV7BwRGlWdFOJJWSQYq8zHW1
}

struct Constants {
    static let base = "https://api.nytimes.com/svc/topstories/v2/"
}


extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()
}
