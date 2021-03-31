//
//  AppsVC.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class AppsVC: LoadingViewController {
    // MARK: - Properties
    var socialApps = [SocialApp]()
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
        showLoading()
        fetchAppGroups()
    }
    
    // MARK: - Helpers
    func layoutUI() {
        view.addSubviews(collectionView)
        collectionView.frame = view.bounds
    }
    
    func fetchAppGroups() {
        let dispatchGroup = DispatchGroup()
        
        var editorsChoice: AppGroup?
        var topGrossing: AppGroup?
        var topFree: AppGroup?
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchApps(urlString: URLString.social.rawValue) { [weak self] (result: Result<[SocialApp], Error>) in
            guard let self = self else { return }
            dispatchGroup.leave()
            switch result {
                case .success(let socialApps):
                    self.socialApps = socialApps
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
     
        dispatchGroup.enter()
        NetworkManager.shared.fetchApps(urlString: URLString.editorChoice.rawValue) { (result: Result<AppGroup, Error>) in
            dispatchGroup.leave()
            switch result {
            case .success(let appGroup):
                editorsChoice = appGroup
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchApps(urlString: URLString.topGrossing.rawValue) { (result: Result<AppGroup, Error>) in
            dispatchGroup.leave()
            switch result {
            case .success(let appGroup):
                topGrossing = appGroup
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchApps(urlString: URLString.topFree.rawValue) { (result: Result<AppGroup, Error>) in
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
            self.dismissLoading()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AppsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AppsVCHeaderView.reuseId, for: indexPath) as! AppsVCHeaderView
        header.socialApps = socialApps
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsGroupCell.reuseId, for: indexPath) as! AppsGroupCell
        let appGroup = appGroups[indexPath.item]
        cell.configureWith(appGroup: appGroup, viewController: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - AppsGroupVCDelegate
extension AppsVC: AppsGroupVCDelegate {
    func showAppDetail(app: FeedItem?) {
        guard let app = app else { return }
        let vc = AppDetailVC(id: app.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
