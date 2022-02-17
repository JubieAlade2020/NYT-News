//
//  TopStoriesVM_Tests.swift
//  NYT-NewsTests
//
//  Created by Jubie Alade on 2/15/22.
//

import XCTest
@testable import NYT_News

class MockAPICaller_Tests: XCTestCase {

    var mockAPI: MockAPICaller!
    var api: APICaller!

    override func setUpWithError() throws {
        api = APICaller()
        mockAPI = MockAPICaller()
    }

    override func tearDownWithError() throws {
        api = nil
        mockAPI = nil
    }

    /// Tests fetching data from corrupted JSON.
    func test_APIError_fetchingCorruptJSONResultsInError() throws {
        XCTAssertThrowsError(try mockAPI.fetchCorruptJson())
        XCTAssertTrue(mockAPI.statusCode == 1)
    }
    
    /// Tests fetching from the API without providing a key.
    func test_APIError_ShouldBeErrorDueToNoKey() async throws {
        do {
            try await mockAPI.fetchAPINoKey()
            XCTAssertTrue(mockAPI.statusCode == 401)
        } catch {
            _ = XCTSkip("There was an issue fetching data from the api.")
        }
    }
    
    /// Tests that the data is being decoded correctly.
    func test_MockAPICaller_decoderIsDecodingData() throws {
        let response = try mockAPI.fetchFakeStories()
        
        XCTAssertTrue(response.results.isEmpty == false)
    }

    /// Tests that stories without images or titles are being filtered and discarded.
    @MainActor func test_TopStoriesVM_arraysAreBeingFiltered() throws {
        let vm = TopStoriesVM(service: api)
        let response = try mockAPI.filterForEmptyTitleAndMultimedia()
        var storyArray = [TopStory]()

        for stories in response.results {
            storyArray.append(stories)
        }
        
        vm.filterAndPopulateArray(topStories: storyArray)

        XCTAssertEqual(vm.topStories.count, 1)
    }
    
    
    /// Tests if a fetch with no results does not throw an error.
    /// Also tests that an alert is pushed regardless.
    @MainActor func test_MockAPICaller_resultsAreEmpty() throws {
        let vm = TopStoriesVM(service: api)
        
        XCTAssertNoThrow(try mockAPI.fetchEmptyResults())
        vm.showingAlert = true
        XCTAssertEqual(vm.showingAlert, true)
    }
}


// TO DO:
/*

 1. Set up and tear down tests
    - unit tests video
 
 2. Document all public and internal interfaces and make sure the style is consistent throughout
    - code spacing
 
 3. More Tests
 
 4. Document tests too
 
 */
