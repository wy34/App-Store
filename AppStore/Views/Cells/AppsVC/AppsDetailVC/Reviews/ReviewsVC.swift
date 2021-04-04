//
//  ReviewsVC.swift
//  AppStore
//
//  Created by William Yeung on 3/30/21.
//

import UIKit

class ReviewsVC: UIViewController {
    // MARK: - Properties
    var reviewEntries: [Entry]? {
        didSet {
            guard let _ = reviewEntries else { return }
            collectionView.reloadData()
        }
    }
    
    // MARK: - Views    
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(scrollDirection: .horizontal, showsIndicators: false, enableSnap: true)
        cv.register(RatingCell.self, forCellWithReuseIdentifier: RatingCell.reuseId)
        cv.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    // MARK: - Helper
    func layoutUI() {
        view.addSubviews(collectionView)
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ReviewsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewEntries?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCell.reuseId, for: indexPath) as! RatingCell
        cell.configureWith(reviewEntry: reviewEntries?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 32, height: view.frame.height)
    }
}
