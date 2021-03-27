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
    private let titleLabel = Label(text: "App Section", font: .boldSystemFont(ofSize: 25))
    private let appsHorizontalVC = AppsGroupVC()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubviews(titleLabel, appsHorizontalVC.view)
        
        titleLabel.anchor(top: topAnchor, trailing: trailingAnchor, leading: leadingAnchor, padLeading: 16)
        appsHorizontalVC.view.anchor(top: titleLabel.bottomAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
}
