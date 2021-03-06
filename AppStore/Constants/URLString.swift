//
//  Constants.swift
//  AppStore
//
//  Created by William Yeung on 3/29/21.
//

import Foundation

enum URLString: String {
    case topGrossing = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
    case social = "https://api.letsbuildthatapp.com/appstore/social"
    case topFree = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json"
    case editorChoice = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json"
    
    static func searchUrl(searchTerm: String) -> String {
        return "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
    }
    
    static func appDetailUrl(id: String) -> String {
        return "https://itunes.apple.com/lookup?id=\(id)"
    }
    
    static func appReviewsUrl(id: String) -> String {
        return "https://itunes.apple.com/rss/customerreviews/page=1/id=\(id)/sortby=mostrecent/json?en&cc=us"
    }
    
    static func musicSearchUrl(searchTerm: String, offset: Int) -> String {
        return "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(offset)&limit=20"
    }
}

