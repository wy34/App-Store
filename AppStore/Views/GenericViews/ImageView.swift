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
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .blue
    }
}
