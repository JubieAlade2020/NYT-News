//
//  TopStoryListView.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import Foundation
import SwiftUI

/// This is the view that shows a list of article previews.
struct TopStoryListView: View {
    
    // MARK: PROPERTIES
    @StateObject var topStoriesVM: TopStoriesVM
        
    init(dataService: APICaller) {
        _topStoriesVM = StateObject(wrappedValue: TopStoriesVM(service: dataService))
    }
    
    // MARK: BODY
    
    var body: some View {
        if topStoriesVM.isLoading {
            ProgressView()
                .task {
                    do {
                        try await topStoriesVM.getTopStories(category: topStoriesVM.service.category)
                        topStoriesVM.isLoading = false
                    } catch let err {
                        print(err)
                    }
                }
        } else {
            ZStack {
                storyScrollView
                    .navigationBarItems(leading: navigationItems, trailing: refreshButton)
                    .onChange(of: topStoriesVM.service.category) { _ in
                        topStoriesVM.isLoading = true
                    }
                networkRequestErrorAlert
            }
        }
    }
    
    // MARK: BODY COMPONENTS
    
    /// This is a ScrollView that holds the article previews.
    private var storyScrollView: some View {
        VStack {
            ScrollView {
                ForEach(topStoriesVM.topStories.indices, id: \.self) { story in
                    TopStoryRowView(topStory: topStoriesVM.topStories[story])
                        .padding(.horizontal, 3)
                    Divider()
                }
            }
        }
    }
    
    /// These are the navigation items for the view.
    private var navigationItems: some View {
        HStack {
            categoryPicker
            Text("Top News: \(topStoriesVM.service.category)")
        }
    }
    
    /// This is a button that refreshes the view by making a new API call.
    private var refreshButton: some View {
        Button {
            topStoriesVM.isLoading = true
        } label: {
            Image(systemName: "arrow.clockwise")
        }
    }
    
    /// This is a picker that allows you to change categories. The selection will be used in a new API call.
    private var categoryPicker: some View {
        Menu {
            Picker("Category", selection: $topStoriesVM.service.category) {
                ForEach(ArticleCategory.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "text.justify")
                .imageScale(.large)
        }
    }
    
    /// This is an alert that becomes visible if the network call fails.
    private var networkRequestErrorAlert: some View {
        Text("")
            .alert(isPresented: $topStoriesVM.showAlert, content: {
                Alert(title: Text(topStoriesVM.errorMessage), message: Text(topStoriesVM.errorDescription), primaryButton: .cancel(), secondaryButton:
                            .default(Text("Retry"), action: {
                    Task {
                        do {
                            try await topStoriesVM.getTopStories(category: topStoriesVM.service.category)
                            topStoriesVM.isLoading = false
                        } catch {
                            print(error)
                        }
                    }
                }))
            })
    }
}
