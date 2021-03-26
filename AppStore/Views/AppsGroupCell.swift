//
//  AppsGroupCell.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class AppsGroupCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "AppsGroupCell"
    
    // MARK: - Views
    private let titleLabel = Label(text: "App Section", font: .boldSystemFont(ofSize: 30))
    private let appsHorizontalVC = AppsHorizontalVC()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubviews(titleLabel, appsHorizontalVC.view)
        
        titleLabel.anchor(top: topAnchor, trailing: trailingAnchor, leading: leadingAnchor)
        appsHorizontalVC.view.anchor(top: titleLabel.bottomAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
}
