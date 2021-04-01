//
//  PreviewsVC.swift
//  AppStore
//
//  Created by William Yeung on 3/29/21.
//

import UIKit

class PreviewsVC: UIViewController {
    // MARK: - Properties
    var app: App? {
        didSet {
            guard let _ = app else { return }
            collectionView.reloadData()
        }
    }
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(scrollDirection: .horizontal, showsIndicators: false, enableSnap: true)
        cv.register(ScreenshotCell.self, forCellWithReuseIdentifier: ScreenshotCell.reuseId)
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
extension PreviewsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.screenshotUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotCell.reuseId, for: indexPath) as! ScreenshotCell
        let screenshotUrl = app?.screenshotUrls[indexPath.item]
        cell.configureWith(screenshotUrl: screenshotUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 250, height: view.frame.height)
    }
}
