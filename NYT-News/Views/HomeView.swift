//
//  ContentView.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import SwiftUI

struct HomeView: View {
    let service = APICaller()
    let category: ArticleCategory = .Arts
    
    var body: some View {
        NavigationView {
            TopStoryListView(dataService: service, category: category)
        }
    }
}
