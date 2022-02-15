//
//  DetailViewModel.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/27/22.
//

import Foundation

// MARK: PROTOCOL

/// This protocol is to be implemented when attempting to toggle the Safari screen.
protocol DetailViewModelProtocol: ObservableObject {
    func toggleSafariScreen()
}

// MARK: VIEW MODEL

final class DetailVM: DetailViewModelProtocol {
    
    // MARK: PROPERTIES

    @Published var shouldToggle = false
    @Published var story: TopStory
    
    init(story: TopStory) {
        self.story = story
    }
    
    // MARK: FUNCTIONS
    
    /// This function toggles the Safari screen.
    func toggleSafariScreen() {
        shouldToggle.toggle()
    }
}
