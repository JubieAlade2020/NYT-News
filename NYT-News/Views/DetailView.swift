//
//  DetailView.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import SwiftUI
import Kingfisher

/// This is the view that contains a selected article's full details.
struct DetailView: View {

    // MARK: PROPERTIES
    
    @StateObject var detailVM: DetailVM
    @State private var showingSheet = false
    
    init(story: TopStory) {
        _detailVM = StateObject(wrappedValue: DetailVM(story: story))
    }
    
    // MARK: BODY
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                articleImageAndAuthor
                articleBody
                .padding(.horizontal)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    shareButton
                }
            })
            
            .sheet(isPresented: $showingSheet) {
                SafariWebView(url: detailVM.story.articleURL)
            }
        }
    }
    
    // MARK: BODY COMPONENTS
    
    /// This is the article's image and author(s).
    private var articleImageAndAuthor: some View {
        VStack {
            HStack {
                Text(detailVM.story.byline)
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding([.leading, .top])
                Spacer()
                Text("")
            }
            KFImage(URL(string: detailVM.story.multimedia![0].url))
                .resizable()
                .scaledToFill()
                .clipped()
                .cornerRadius(5)
        }
    }
    
    /// This is the body of the article (title, abstract, publication date).
    private var articleBody: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(detailVM.story.title)
                .font(.headline)
            Text(detailVM.story.abstract)
                .font(.subheadline)
            HStack {
                Text(detailVM.story.date)
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
                readMoreButton
            }
        }
    }
    
    /// This is a button that displays the full article on a Safari browser.
    private var readMoreButton: some View {
        Button("Read More") {
            detailVM.toggleSafariScreen()
            self.showingSheet = detailVM.shouldToggle
        }
    }
    
    /// This is a button that allows you to share the article.
    private var shareButton: some View {
        Button {
            presentShareScreen(url: detailVM.story.articleURL)
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
}


// MARK: EXTENSIONS

extension View {
    
    /// Presents the view containing shareability features.
    /// - Parameter url: This is the url of the selected article.
    func presentShareScreen(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}
