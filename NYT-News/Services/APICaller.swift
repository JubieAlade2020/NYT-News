//
//  APICaller.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import Foundation

protocol APICallerService: ObservableObject {
    
    /// Gets the articles from the API.
    ///
    /// After getting the data from the API, the data is decoded using the TopStoriesResponse.
    ///
    /// - Returns: Returns the data in a form that's accessible to us.
    func getTopStories(section: String) async throws -> TopStoriesResponse
}

final class APICaller: APICallerService {
    
    /// Gets the articles from the API.
    ///
    /// After getting the data from the API, the data is decoded using the TopStoriesResponse.
    ///
    /// - Returns: Returns the data in a form that's accessible to us.
    func getTopStories(section: String) async throws -> TopStoriesResponse {
        let urlSession = URLSession.shared
        let url = URL(string: Constants.base+section+".json?api-key=") //<<<<<<<< key needed 🔐
        let (data, _) = try await urlSession.data(from: url!)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return try jsonDecoder.decode(TopStoriesResponse.self, from: data)
    }
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
