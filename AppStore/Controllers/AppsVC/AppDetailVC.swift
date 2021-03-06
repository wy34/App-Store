//
//  AppDetailController.swift
//  AppStore
//
//  Created by William Yeung on 3/29/21.
//

import UIKit

class AppDetailVC: UIViewController {
    // MARK: - Properties
    var app: App?
    var reviews: Reviews?
 
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(AppDetailCell.self, forCellWithReuseIdentifier: AppDetailCell.reuseId)
        cv.register(PreviewCell.self, forCellWithReuseIdentifier: PreviewCell.reuseId)
        cv.register(ReviewsCell.self, forCellWithReuseIdentifier: ReviewsCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Init
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
        fetchAppDetails(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Helper
    func layoutUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    func fetchAppDetails(id: String) {
        NetworkManager.shared.fetchApps(urlString: URLString.appDetailUrl(id: id)) { [weak self] (result: Result<SearchResult, Error>) in
            guard let self = self else { return }
            
            switch result {
                case .success(let searchResult):
                    self.app = searchResult.results[0]
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        NetworkManager.shared.fetchApps(urlString: URLString.appReviewsUrl(id: id)) { [weak self] (result: Result<Reviews, Error>) in
            guard let self = self else { return }
            
            switch result {
                case .success(let reviews):
                    self.reviews = reviews
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                case .failure(let error):
                    print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AppDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailCell.reuseId, for: indexPath) as! AppDetailCell
            cell.configureWith(app: app)
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.reuseId, for: indexPath) as! PreviewCell
            cell.configureWith(app: app)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewsCell.reuseId, for: indexPath) as! ReviewsCell
            cell.configureWith(reviews: reviews)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))

            dummyCell.configureWith(app: app)
            dummyCell.layoutIfNeeded()
            
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            return CGSize(width: view.frame.width, height: estimatedSize.height)
        } else if indexPath.item == 1 {
            return .init(width: view.frame.width, height: 500)
        } else {
            return .init(width: view.frame.width, height: 280)
        }
    }
}

