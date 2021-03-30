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
        let cv = CollectionView(scrollDirection: .horizontal, showsIndicators: false, enableSnap: true)
        cv.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseId)
        cv.backgroundColor = .white
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
extension HeaderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var horizontalBetweenSpacing: CGFloat {
        return 10
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
        let width = view.frame.width - (horizontalBetweenSpacing * 4)
        let height = view.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalBetweenSpacing
    }
}
