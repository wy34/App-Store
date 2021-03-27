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
    
    init(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}
