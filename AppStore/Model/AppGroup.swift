//
//  AppGroup.swift
//  AppStore
//
//  Created by William Yeung on 3/27/21.
//

import Foundation

struct AppGroup: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let title: String
    let results: [FeedItem]
}

struct FeedItem: Codable, Hashable {
    let id: String
    let artistName: String
    let name: String
    let artworkUrl100: String
}
