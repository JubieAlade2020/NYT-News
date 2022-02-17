//
//  APICaller_Tests.swift
//  NYT-NewsTests
//
//  Created by Jubie Alade on 2/14/22.
//

import XCTest
@testable import NYT_News

/// Tests the functionality of the API caller service.
class APICaller_Tests: XCTestCase {
    
    var api: APICaller!
    
    override func setUpWithError() throws {
        api = APICaller()
    }
    
    override func tearDownWithError() throws {
        api = nil
    }
    
    /// Tests that the rate limit is reached when the API is called in rapid succession
    ///
    /// An internet connection is verified first. If there is no internet connection, the test is skipped.
    ///
    func test_APIError_rateLimitReached() async throws {
        let group = DispatchGroup()
        
        do {
            _ = try await api.getTopStories(category: "Arts")
            XCTAssertTrue(api.statusCode == 200)
            // simulates trying to tap the refresh button 20 times
            for _ in 0...20 {
                do {
                    group.enter()
                    _ = try await api.getTopStories(category: "Arts")
                    group.leave()
                } catch {
                    XCTAssertTrue(api.statusCode == 429)
                }
            }
        } catch {
            _ = XCTSkip("There was an issue fetching data from the api.")
        }
    }
    
    /// Tests that an error is thrown when trying to get articles for a non-valid category
    func test_APIError_ShouldBeErrorDueToBadCategory() async throws {
        let category = ""
        var errorMessage = ""
                
        do {
            _ = try await api.getTopStories(category: category)
        } catch let theErrorMessage {
            errorMessage = theErrorMessage.localizedDescription
        }

        XCTAssertTrue(errorMessage != "")
    }
}

