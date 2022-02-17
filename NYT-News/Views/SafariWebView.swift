//
//  SafariWebView.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/26/22.
//

import SwiftUI
import SafariServices

/// This is the view that displays the Safari browser.
struct SafariWebView: UIViewControllerRepresentable {
    
    // MARK: PROPERTIES

    let url: URL
    
    // MARK: FUNCTIONS
    
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
