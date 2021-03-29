//
//  AppsVC.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class AppsVC: UIViewController {
    // MARK: - Properties
    var appGroups = [AppGroup]()
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(AppsGroupCell.self, forCellWithReuseIdentifier: AppsGroupCell.reuseId)
        cv.register(AppsVCHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AppsVCHeaderView.reuseId)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        fetchAppGroups()
    }
    
    // MARK: - Helpers
    func layoutUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    func fetchAppGroups() {
        let dispatchGroup = DispatchGroup()
        
        var editorsChoice: AppGroup?
        var topGrossing: AppGroup?
        var topFree: AppGroup?
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json") { (result) in
            dispatchGroup.leave()
            switch result {
                case .success(let appGroup):
                    editorsChoice = appGroup
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json") { (result) in
            dispatchGroup.leave()
            switch result {
                case .success(let appGroup):
                    topGrossing = appGroup
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }

        dispatchGroup.enter()
        NetworkManager.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json") { (result) in
            dispatchGroup.leave()
            switch result {
                case .success(let appGroup):
                    topFree = appGroup
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }

        dispatchGroup.notify(queue: .main) {
            for appGroup in [editorsChoice, topGrossing, topFree] {
                if let group = appGroup {
                    self.appGroups.append(group)
                }
            }
            
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AppsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AppsVCHeaderView.reuseId, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsGroupCell.reuseId, for: indexPath) as! AppsGroupCell
        let appGroup = appGroups[indexPath.item]
        cell.configureWith(appGroup: appGroup)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}
