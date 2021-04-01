//
//  TodayCell.swift
//  AppStore
//
//  Created by William Yeung on 3/31/21.
//

import UIKit

class TodayCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "TodayCell"
    
    // MARK: - Views
    let imageView = ImageView(image: UIImage(named: "ph")!)
    
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
        addSubview(imageView)
        imageView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
    
}
