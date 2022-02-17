//
//  TopStoriesVM.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import Foundation

// MARK: PROTOCOL

/// This protocol is to be implemented when attemping to fetch articles from the API.
protocol TopStoriesVMProtocol: ObservableObject {
    func getTopStories(category: String) async throws
}

// MARK: VIEW MODEL

/// This view model serves as the mediary between the API caller and  views displaying the API results.
///
/// The view model processes the data so that it can be used in the views.
///
@MainActor
final class TopStoriesVM: TopStoriesVMProtocol {
    
    // MARK: PROPERTIES
    
    @Published var showingAlert: Bool = false
    @Published var topStories: [TopStory] = []
    @Published var isLoading: Bool = true
    @Published var showAlert: Bool = false
    @Published var service: APICaller
    @Published var errorMessage: String = ""
    @Published var errorDescription: String = ""

    var storyArray: [TopStory] = []
    var filteredStoryArray: [TopStory] = []
    private var taskHandler: Task<Void, Never>?
    
    init(service: APICaller) {
        self.service = service
    }
    
    // MARK: FUNCTIONS
    
    /// Gets an array of articles from the API. It then calls upon a function that filters the array.
    /// - Parameter category: The category used in the API call. Ex: ('Arts', 'Sports', 'World')
    func getTopStories(category: String) async throws {
        taskHandler?.cancel()
        do {
            emptyArrays()
            let response = try await service.getTopStories(category: category)
            if response.results.isEmpty {
                showAlert.toggle()
                showingAlert = true 
            }
            self.storyArray = response.results
            filterAndPopulateArray(topStories: self.storyArray)
        } catch {
            switch service.statusCode {
            case 401:
                errorMessage = "Invalid API Key"
                errorDescription = "You must provide a valid API key."
            case 429:
                errorMessage = "Rate Limit Reached"
                errorDescription = "You've reached the rate limit. Wait a few seconds and try again."
            case 1:
                errorMessage = "There has been a network error."
                errorDescription = "Please try again."
            default:
                break
            }
            showAlert.toggle()
        }
    }
    
    /// Emptys the array of articles before each API call.
    private func emptyArrays() {
        self.storyArray.removeAll()
        self.filteredStoryArray.removeAll()
        self.topStories.removeAll()
    }
    
    /// Removes undesired articles from the API call response.
    /// - Parameter topStories: This is the array of articles being processed.
    func filterAndPopulateArray(topStories: [TopStory]) {
        for story in topStories {
            if story.title != "" {
                self.filteredStoryArray.append(story)
            }
        }
        
        for storyObject in self.filteredStoryArray {
            if !(storyObject.multimedia?.isEmpty ?? true) {
                self.topStories.append(storyObject)
            }
        }
    }
}
