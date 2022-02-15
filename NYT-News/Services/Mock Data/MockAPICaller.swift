//
//  MockAPICaller.swift
//  NYT-News
//
//  Created by Jubie Alade on 2/15/22.
//

import Foundation

final class MockAPICaller {
    
    // using mock data to fetch all articles for arts
    func fetchFakeStories() throws -> TopStoriesResponse {
        let url = Bundle.main.url(forResource: "mockAPIResponse-fetchArticles", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return try jsonDecoder.decode(TopStoriesResponse.self, from: data!)
    }
    
    // fetching three stories - one has no title, one has no multimedia, one is normal
    func filterForEmptyTitleAndMultimedia() throws -> TopStoriesResponse {
        let url = Bundle.main.url(forResource: "emptyTitle-emptyMulti", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let response = try jsonDecoder.decode(TopStoriesResponse.self, from: data!)
        return response
    }
    
    // fetching and decoding corrupt json - should throw error
    func fetchCorruptJson() throws -> TopStoriesResponse {
        let url = Bundle.main.url(forResource: "mockAPIErrorResponse", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let response = try jsonDecoder.decode(TopStoriesResponse.self, from: data!)
        print(response)
        return response
    }
    
    func fetchAPINoKey() async throws {
        let urlSession = URLSession.shared
        let url = URL(string: Constants.base+"Arts.json?api-key=")
        let (data, _) = try await urlSession.data(from: url!)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        guard let _ = try? jsonDecoder.decode(TopStoriesResponse.self, from: data) else {
            throw APIError.noKeyProvided
        }
    }
}

enum APIError: Error {
    case noKeyProvided
}

extension APIError {
    public var description: String {
        switch self {
        case .noKeyProvided:
            return "You need to provide an API key."
        }
    }
}
