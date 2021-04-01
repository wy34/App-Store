//
//  ImageView.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class ImageView: UIImageView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage, tintColor: UIColor = .black, cornerRadius: CGFloat = 16) {
        super.init(frame: .zero)
        self.image = image
        self.tintColor = tintColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    init(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}
