//
//  NetworkManager.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class NetworkManager {
    // MARK: - Properties
    static let shared = NetworkManager()
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Helpers
    func fetchApps<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let response = response  as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(error!))
                    return
                }
                
                if let data = data {
                    do {
                        let apps = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(apps))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    func downloadImage(withURLString urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = imageCache.object(forKey: cacheKey) {
            completion(image)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        let downloadedImage = UIImage(data: data)!
                        self.imageCache.setObject(downloadedImage, forKey: cacheKey)
                        completion(downloadedImage)
                    }
                }
                
                completion(nil)
            }
        }
    }
}



