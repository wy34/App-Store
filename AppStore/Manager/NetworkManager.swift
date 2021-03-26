//
//  NetworkManager.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchiTunesApps(completion: @escaping (Result<SearchResult, Error>) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=clash&entity=software"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(error!))
                    return
                }
                
                if let data = data {
                    do {
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                        completion(.success(searchResult))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}



