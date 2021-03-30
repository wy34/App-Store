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
 
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(AppDetailCell.self, forCellWithReuseIdentifier: AppDetailCell.reuseId)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Init
    init(app: FeedItem) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
        fetchAppDetails(id: app.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
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
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AppDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailCell.reuseId, for: indexPath) as! AppDetailCell
        cell.configureWith(app: app)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        dummyCell.configureWith(app: app)
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
}

