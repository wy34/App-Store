//
//  UIImageView.swift
//  AppStore
//
//  Created by William Yeung on 3/28/21.
//

import UIKit

extension UIImageView {
    func downloadImage(from urlString: String) {
        NetworkManager.shared.downloadImage(withURLString: urlString) { [weak self] (image) in
            guard let self = self else { return }
            guard let image = image else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
