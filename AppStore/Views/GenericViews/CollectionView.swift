//
//  CollectionViewController.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class CollectionView: UICollectionView {
    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(scrollDirection: UICollectionView.ScrollDirection = .vertical, showsIndicators: Bool = true) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        super.init(frame: .zero, collectionViewLayout: layout)
        showsVerticalScrollIndicator = showsIndicators
        showsHorizontalScrollIndicator = showsIndicators
    }
}