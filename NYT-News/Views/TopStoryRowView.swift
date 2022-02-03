//
//  TopStoryRowView.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import SwiftUI
import Kingfisher

/// This is the preview of a story. It includes the article image, author(s), publication date, and abstract summary.
struct TopStoryRowView: View {
    
    // MARK: PROPERTIES
    
    let topStory: TopStory

    // MARK: BODY
    
    var body: some View {
        VStack {
            NavigationLink(destination: DetailView(story: topStory)) {
                VStack(alignment: .leading, spacing: 15) {
                    
                    articleImage
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        articleBody
                        articleDetails
                    }
                }
                .frame(maxHeight: 1000)
            }
            .buttonStyle(PlainButtonStyle())
            .padding([.horizontal, .bottom])
        }
    }
    
    // MARK: BODY COMPONENTS
    
    /// This contains the article's author(s) and publication date.
    private var articleDetails: some View {
        HStack {
            Text(topStory.byline)
                .foregroundColor(.secondary)
                .font(.caption)
            Spacer()
            Text(topStory.date)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
    
    /// This contains the article's title and abstract summary.
    private var articleBody: some View {
        VStack(alignment: .leading) {
            Text(topStory.title)
                .font(.headline)
            Text(topStory.abstract)
                .font(.subheadline)
                .lineLimit(3)
        }
    }
    
    /// This contains the article's image.
    private var articleImage: some View {
        KFImage(URL(string: topStory.multimedia![0].url)!)
            .resizable()
            .scaledToFit()
            .frame(minHeight: 200, maxHeight: 900)
            .clipped()
            .cornerRadius(20)
            .shadow(color: .black, radius: 5)
    }
}
