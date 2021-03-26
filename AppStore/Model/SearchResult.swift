//
//  SearchResult.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import Foundation

struct SearchResult: Codable {
    let resultCount: Int
    let results: [App]
}

struct App: Codable {
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
}