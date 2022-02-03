//
//  TopStoriesVM_Tests.swift
//  NYTAppTests
//
//  Created by Jubie Alade on 1/28/22.
//

import XCTest
@testable import NYT_News

class TopStoriesVM_Tests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func test_TopStoriesVM_isLoading_shouldBeTrue() {
        //Given
        let isLoading: Bool = true
        let service: APICaller = APICaller()
        let category: ArticleCategory = .Arts
        
        //When
        let vm = TopStoriesVM(service: service, selection: category)
        
        //Then
        XCTAssertEqual(vm.isLoading, isLoading)
    }
    
    @MainActor func test_TopStoriesVM_topStories_shouldBeInitializedEmpty() {
        //Given
        let service: APICaller = APICaller()
        let category: ArticleCategory = .Arts
        
        //When
        let vm = TopStoriesVM(service: service, selection: category)
        
        //Then
        XCTAssertEqual(vm.topStories.count, 0)
    }
    
    @MainActor func test_TopStoriesVM_filterAndPopulateArray_successfullyPopulatesTopStoriesArray() async {
        
        /*
         Check that the function actually appends stories to the array
         */
        
        //Given
        let service: APICaller = APICaller()
        let category: ArticleCategory = .Arts
        let vm = TopStoriesVM(service: service, selection: category)
        
        //When
        do {
            try await vm.getTopStories(category: category.rawValue)
        } catch {
            print(error)
        }
        
        //Then
        XCTAssertGreaterThan(vm.topStories.count, 0)
    }
    
    @MainActor func test_TopStoriesVM_rejectsTopStoryWithNoTitle() async {
        
        /*
         create a fake story
         then pass it to the function
         function should not append the story to the array as it has no title
         check the count of topStories to make sure it is still empty
         */
        
        //Given
        let service: APICaller = APICaller()
        let category: ArticleCategory = .Arts
        let nonEmptyMultimedia = Multimedia(url: "")
        let vm = TopStoriesVM(service: service, selection: category)
            let topStory = [
            TopStory(title: "", abstract: "", url: "", byline: "", published_date: Date(), multimedia: [nonEmptyMultimedia])
            ]
        
        //When
        vm.filterAndPopulateArray(topStories: topStory)
        
        //Then
        XCTAssertEqual(vm.topStories.count, 0)
    }
    
    @MainActor func test_TopStoriesVM_rejectsTopStoryWithNoMultimedia() async {
        
        /*
         create a fake story
         then pass it to the function
         function should not append the story to the array as it has no multimedia
         check the count of topStories to make sure it is still empty
         */
        
        //Given
        let service: APICaller = APICaller()
        let category: ArticleCategory = .Arts
        let vm = TopStoriesVM(service: service, selection: category)
            let topStory = [
            TopStory(title: "not empty", abstract: "", url: "", byline: "", published_date: Date(), multimedia: [])
            ]
        
        //When
        vm.filterAndPopulateArray(topStories: topStory)
        
        //Then
        XCTAssertEqual(vm.topStories.count, 0)
    }
    
    @MainActor func test_TopStoriesVM_apiCallWithBadCategoryShouldFail() async {
        
        /*
         Test for when the network request fails
         I'm using the error alert as an indicator for whether or not the API call was a success
         */
        
        //Given
        let service: APICaller = APICaller()
        let category: ArticleCategory = .Arts
        let vm = TopStoriesVM(service: service, selection: category)
        
        //When
        do {
            try await vm.getTopStories(category: "Random")
        } catch {
            print(error)
        }
        
        //Then
        XCTAssertTrue(vm.showAlert == true)
    }
}
