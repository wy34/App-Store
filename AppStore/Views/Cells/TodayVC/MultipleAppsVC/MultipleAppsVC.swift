//
//  TodayMultipleAppsVC.swift
//  AppStore
//
//  Created by William Yeung on 4/1/21.
//

import UIKit


class MultipleAppsVC: UIViewController {
    // MARK: - Properties
    var results: [FeedItem]?
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(MultipleCell.self, forCellWithReuseIdentifier: MultipleCell.reuseId)
        cv.backgroundColor = .white
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        fetchApps()
    }

    // MARK: - Helpers
    private func layoutUI() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, padTop: 10)
    }
    
    func fetchApps() {
        NetworkManager.shared.fetchApps(urlString: URLString.editorChoice.rawValue) { [weak self] (result: Result<AppGroup, Error>) in
            guard let self = self else { return }
            switch result {
                case .success(let appGroup):
                    self.results = appGroup.feed.results
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                case .failure(let error):
                    print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MultipleAppsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, results?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleCell.reuseId, for: indexPath) as! MultipleCell
        cell.configureWith(feedItem: results?.shuffled()[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

