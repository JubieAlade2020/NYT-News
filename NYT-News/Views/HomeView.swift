//
//  ContentView.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import SwiftUI

/// Root view of the app containing the list of articles.
struct HomeView: View {
    let service = APICaller()
        
    var body: some View {
        NavigationView {
            TopStoryListView(dataService: service)
        }
    }
}
