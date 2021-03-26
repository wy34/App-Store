//
//  AppsSearchVC.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class AppsSearchVC: UIViewController {
    // MARK: - Properties
    fileprivate var apps = [App]()
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SearchResultsCell.self, forCellWithReuseIdentifier: SearchResultsCell.reuseId)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        fetchSearchedApps()
    }
    
    // MARK: - Helpers
    fileprivate func layoutUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    fileprivate func fetchSearchedApps() {
        NetworkManager.shared.fetchiTunesApps { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
                case .success(let searchResult):
                    print(searchResult.resultCount)
                    print(searchResult.results[0].artworkUrl100)
                    self.apps = searchResult.results
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AppsSearchVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCell.reuseId, for: indexPath) as! SearchResultsCell
        cell.configureCellWith(app: apps[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
}
