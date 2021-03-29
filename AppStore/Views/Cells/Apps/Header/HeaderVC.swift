//
//  ViewController.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class HeaderVC: UIViewController {
    // MARK: - Properties
    var socialApps: [SocialApp]? {
        didSet {
            guard let _ = socialApps else { return }
            collectionView.reloadData()
        }
    }
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(scrollDirection: .horizontal, showsIndicators: false)
        cv.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseId)
        cv.backgroundColor = .white
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
extension HeaderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionViewSpacings: (horizontalBetweenSpacing: CGFloat, edgeInset: CGFloat) {
        return (horizontalBetweenSpacing: 10, edgeInset: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialApps?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.reuseId, for: indexPath) as! HeaderCell
        let socialApp = socialApps?[indexPath.item]
        cell.configureWith(socialApp: socialApp)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - (collectionViewSpacings.edgeInset * 3), height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewSpacings.horizontalBetweenSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewSpacings.edgeInset, left: collectionViewSpacings.edgeInset, bottom: collectionViewSpacings.edgeInset, right: collectionViewSpacings.edgeInset)
    }
}
