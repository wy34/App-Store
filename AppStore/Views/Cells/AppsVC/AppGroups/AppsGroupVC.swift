//
//  AppsHorizontalVC.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

protocol AppsGroupVCDelegate: class {
    func showAppDetail(app: FeedItem?)
}

class AppsGroupVC: UIViewController {
    // MARK: - Properties
    var feedItems: [FeedItem]? {
        didSet {
            guard let _ = feedItems else { return }
            collectionView.reloadData()
        }
    }
    
    weak var delegate: AppsGroupVCDelegate?
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(scrollDirection: .horizontal, showsIndicators: false, enableSnap: true)
        cv.register(AppRowCell.self, forCellWithReuseIdentifier: AppRowCell.reuseId)
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

    // MARK: - Helpers
    func layoutUI() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AppsGroupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionViewSpacings: (horizontalBetweenSpacing: CGFloat, verticalBetweenSpacing: CGFloat, edgeInset: CGFloat) {
        return (horizontalBetweenSpacing: 10, verticalBetweenSpacing: 3, edgeInset: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCell.reuseId, for: indexPath) as! AppRowCell
        cell.configureWith(feedItem: feedItems?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedItem = feedItems?[indexPath.item]
        delegate?.showAppDetail(app: feedItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - (collectionViewSpacings.horizontalBetweenSpacing * 4)
        let height = ((view.frame.height - collectionViewSpacings.edgeInset * 2)) / 3 - (collectionViewSpacings.verticalBetweenSpacing * 2)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewSpacings.horizontalBetweenSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewSpacings.verticalBetweenSpacing
    }
}
