//
//  TopStoriesVM_Tests.swift
//  NYT-NewsTests
//
//  Created by Jubie Alade on 2/15/22.
//

import XCTest
@testable import NYT_News

class TopStoriesVM_Tests: XCTestCase {

    let mockAPI = MockAPICaller()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    // Test to ensure the json is being decoded
    func test_TopStoriesVM_decoderIsDecodingData() throws {
        let response = try mockAPI.fetchFakeStories()
        
        XCTAssertTrue(response.results.isEmpty == false)
    }

    @MainActor func test_TopStoriesVM_arraysAreBeingFiltered() throws {
        let api = APICaller(category: "Arts")
        let vm = TopStoriesVM(service: api)
        let response = try mockAPI.filterForEmptyTitleAndMultimedia()
        var storyArray = [TopStory]()

        for stories in response.results {
            storyArray.append(stories)
        }
        
        vm.filterAndPopulateArray(topStories: storyArray)
        XCTAssertEqual(vm.topStories.count, 1)
    }
}


// TO DO:
/*
 
 1. Make sure the unit tests do not rely on an internet connection
    - create and use mock responses
 2. Unit tests for when a network error occurs
    - differentiate network error types
 3. Document all public and internal interfaces and make sure the style is consistent throughout
    - code spacing
 4. Delete UI test boilerplate
 5. Delete unit test boilerplate
 6. Fix inconsistent vertical whitespace in UI
 7. The APICallerService protocol is never referenced. It should be used to inject the APICaller implementation which could then be mocked in the unit tests.
 8. Write more tests
    - I had 6 (bad ones)
 
 */
