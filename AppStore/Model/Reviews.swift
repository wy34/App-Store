//
//  ReviewFeed.swift
//  AppStore
//
//  Created by William Yeung on 3/30/21.
//

import Foundation

struct Reviews: Codable {
    var feed: ReviewFeed
}

struct ReviewFeed: Codable {
    var entry: [Entry]
}

struct Entry: Codable {
    var author: Author
    var title: ReviewContent
    var content: ReviewContent
}

struct Author: Codable {
    var name: ReviewContent
}

struct ReviewContent: Codable {
    var label: String
}
