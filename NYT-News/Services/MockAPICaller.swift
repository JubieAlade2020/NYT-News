//
//  MockAPICaller.swift
//  NYT-News
//
//  Created by Jubie Alade on 2/15/22.
//

import Foundation

/// Mock data service responsible for handling mock API responses.
///
/// This mock service is used for testing purposes. It is responsible for fetching data from local JSON files.
///
final class MockAPICaller {
    
    var statusCode: Int?
    let json = "json"
    
    /// Simulates the fetching of all articles in a given category.
    /// - Returns: The response decoded from the JSON.
    func fetchFakeStories() throws -> TopStoriesResponse {
        guard let url = Bundle.main.url(forResource: Constants.fetchArtArticles, withExtension: json) else {
            statusCode = APIError.defaultError.errorCode
            throw APIError.defaultError
        }
        let data = try? Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return try jsonDecoder.decode(TopStoriesResponse.self, from: data!)
    }
    
    
    /// Fetches three stories - one has no title, one has no multimedia, one is normal.
    ///
    /// This is used to simulate fetching an article from the API that is missing critical data. These articles should be disregarded and not displayed.
    ///
    /// - Returns: The response decoded from the JSON.
    func filterForEmptyTitleAndMultimedia() throws -> TopStoriesResponse {
        guard let url = Bundle.main.url(forResource: Constants.emptyTitleemptyMulti, withExtension: json) else {
            statusCode = APIError.defaultError.errorCode
            throw APIError.defaultError
        }
        let data = try? Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let response = try jsonDecoder.decode(TopStoriesResponse.self, from: data!)
        return response
    }
    
    /// Simulates the fetching of incomplete/corrupted JSON data.
    ///
    /// When testing, this should return a default error.
    ///
    func fetchCorruptJson() throws {
        guard let url = Bundle.main.url(forResource: Constants.incompleteJson, withExtension: json) else {
            statusCode = APIError.defaultError.errorCode
            throw APIError.defaultError
        }
        let data = try? Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        guard let _ = try? jsonDecoder.decode(TopStoriesResponse.self, from: data!) else {
            statusCode = APIError.defaultError.errorCode
            throw APIError.defaultError
        }
    }
    
    /// Simulates the attempt to fetch from the API without providing an API key.
    ///
    /// When testing, this should return the 401 error.
    ///
    func fetchAPINoKey() async throws {
        let urlSession = URLSession.shared
        let url = URL(string: Constants.base+"Arts.json?api-key=")
        guard let (data, _) = try? await urlSession.data(from: url!) else {
            statusCode = APIError.defaultError.errorCode
            throw APIError.defaultError
        }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        guard let _ = try? jsonDecoder.decode(TopStoriesResponse.self, from: data) else {
            statusCode = APIError.noKeyProvided.errorCode
            throw APIError.noKeyProvided
        }
    }
    
    /// Simulates fetching articles for a particular category when the category contains no articles.
    ///
    /// This should return a default error and display an alert to the user.
    ///
    func fetchEmptyResults() throws {
        guard let url = Bundle.main.url(forResource: Constants.resultsAreEmpty, withExtension: json) else {
            statusCode = APIError.defaultError.errorCode
            throw APIError.defaultError
        }
        let data = try Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        guard let _ = try? jsonDecoder.decode(TopStoriesResponse.self, from: data) else {
            statusCode = APIError.defaultError.errorCode
            throw APIError.defaultError
        }
    }
}

