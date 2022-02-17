//
//  APICaller.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import Foundation

/// Fetches news articles using the New York Times API.
///
/// This data service is initialized with the news category 'Arts'.
///
final class APICaller {
    
    @Published var category: ArticleCategory
    @Published var statusCode: Int?
    @Published var showingAlert: Bool? 
    
    init() {
        self.category = .Arts
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
            self.statusCode = httpResponse.statusCode
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        guard let storyResponse = try? jsonDecoder.decode(TopStoriesResponse.self, from: data) else {
            statusCode = APIError.rateLimitReached.errorCode
            throw APIError.rateLimitReached
        }
        return storyResponse
    }
}

/// Unchanging strings used when fetching JSON data.
struct Constants {
    static let base = "https://api.nytimes.com/svc/topstories/v2/"
    static let noKey = "https://api.nytimes.com/svc/topstories/v2/Arts.json?api-key="
    static let incompleteJson = "incompleteJson"
    static let resultsAreEmpty = "resultsAreEmpty"
    static let emptyTitleemptyMulti = "emptyTitle-emptyMulti"
    static let fetchArtArticles = "fetchArtArticles"
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
