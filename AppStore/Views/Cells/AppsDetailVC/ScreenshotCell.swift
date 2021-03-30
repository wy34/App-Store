//
//  ScreenshotCell.swift
//  AppStore
//
//  Created by William Yeung on 3/30/21.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "ScreenshotCell"
    
    // MARK: - Views
    private let screenshotImageView = ImageView(cornerRadius: 12)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func layoutUI() {
        addSubview(screenshotImageView)
        screenshotImageView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
    
    func configureWith(screenshotUrl: String?) {
        guard let screenshotUrl = screenshotUrl else { return }
        screenshotImageView.setImage(from: screenshotUrl)
    }
}
