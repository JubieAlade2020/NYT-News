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
/// The view model gets data from the API. It then processes the data so that it can be used in the views.
///
@MainActor
final class TopStoriesVM: TopStoriesVMProtocol {
    
    // MARK: PROPERTIES
    
    @Published var selection: ArticleCategory
    @Published var topStories: [TopStory] = []
    @Published var isLoading: Bool = true
    @Published var showAlert: Bool = false
    @Published var emptyCategory: Bool = false
    
    let service: APICaller
    var storyArray: [TopStory] = []
    var filteredStoryArray: [TopStory] = []
    private var taskHandler: Task<Void, Never>?
    
    init(service: APICaller, selection: ArticleCategory) {
        self.service = service
        self.selection = selection
    }
    
    // MARK: FUNCTIONS
    
    /// Gets an array of articles from the API. It then calls upon a function that filters the array.
    /// - Parameter category: The category used in the API call. Ex: ('Arts', 'Sports', 'World')
    func getTopStories(category: String) async throws {
        taskHandler?.cancel()
        do {
            emptyArrays()

            let topStories = try await service.getTopStories(section: category)
            
            if topStories.results.isEmpty {
                emptyCategory = true
            }
            
            self.storyArray = topStories.results
            filterAndPopulateArray(topStories: self.storyArray)
        } catch {
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
