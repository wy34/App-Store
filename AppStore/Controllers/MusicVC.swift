//
//  MusicVC.swift
//  AppStore
//
//  Created by William Yeung on 4/4/21.
//

import UIKit

class MusicVC: UIViewController {
    // MARK: - Properties
    var results = [App]()
    
    var isPaginating = false
    var isDonePaginating = false
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.reuseId)
        cv.register(MusicLoadingViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MusicLoadingViewFooter.reuseId)
        cv.backgroundColor = #colorLiteral(red: 0.9269490838, green: 0.9225396514, blue: 0.9303577542, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        fetchData()
    }

    // MARK: - Helpers
    func layoutUI() {
        view.addSubviews(collectionView)
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
    }
    
    func fetchData() {
        NetworkManager.shared.fetchApps(urlString: URLString.musicSearchUrl(searchTerm: "taylor", offset: results.count)) { [weak self] (result: Result<SearchResult, Error>) in
            guard let self = self else { return }
            switch result {
                case .success(let result):
                    sleep(2)
                    self.isDonePaginating = result.resultCount == 0 ? true : false
                    self.results += result.results
                    self.isPaginating = false
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                case .failure(let error):
                    print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MusicVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MusicLoadingViewFooter.reuseId, for: indexPath) as! MusicLoadingViewFooter
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: isDonePaginating ? 0 : 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        cell.configureWith(app: results[indexPath.row])
        
        if !isDonePaginating {
            if indexPath.item == results.count - 1 && !isPaginating {
                isPaginating = true
                print("fetching data")
                fetchData()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
}

