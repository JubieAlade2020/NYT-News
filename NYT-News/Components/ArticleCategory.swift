//
//  Category.swift
//  NYTApp
//
//  Created by Jubie Alade on 1/27/22.
//

import Foundation

/// The available New York Times categories. 
enum ArticleCategory: String, CaseIterable {
    case Arts
    case Automobiles
    case Books
    case Business
    case Fashion
    case Food
    case Health
    case Movies
    case Obituaries
    case Politics
    case Realestate
    case Science
    case Sports
    case Technology
    case Travel
    case US
    case World
    
    var text: String {
        return rawValue
    }
}

extension ArticleCategory: Identifiable {
    var id: Self {
        self
    }
}
