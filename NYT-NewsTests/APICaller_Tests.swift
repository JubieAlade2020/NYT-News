//
//  APICaller_Tests.swift
//  NYT-NewsTests
//
//  Created by Jubie Alade on 2/14/22.
//

import XCTest
@testable import NYT_News

class APICaller_Tests: XCTestCase {
    
    let api = MockAPICaller()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func test_APIError() throws {
        XCTAssertThrowsError(try api.fetchCorruptJson())
    }
    
    // Tests a call that contains no key
    @MainActor func test_APIError_ShouldBeErrorDueToNoKey() async throws {
        var errorMessage = ""
        
        do {
            try await api.fetchAPINoKey()
        } catch {
            errorMessage = "No API Key"
        }
        
        XCTAssertTrue(errorMessage != "")
    }
    
    func test_APIError_ShouldBeErrorDueToBadCategory() async throws {
        let category = ""
        var errorMessage = ""

        let api = APICaller(category: category)
        
        do {
            let _ = try await api.getTopStories(category: category)
        } catch let theErrorMessage {
            errorMessage = theErrorMessage.localizedDescription
        }
        
        XCTAssertTrue(errorMessage != "")
    }
}

