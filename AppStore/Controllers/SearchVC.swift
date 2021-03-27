//
//  AppsSearchVC.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class SearchVC: UIViewController {
    // MARK: - Properties
    fileprivate var apps = [App]()
    fileprivate var searchTimer: Timer?
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(SearchResultsCell.self, forCellWithReuseIdentifier: SearchResultsCell.reuseId)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let emptySearchLabel = Label(text: "Please enter search term above...", alignment: .center, font: .boldSystemFont(ofSize: 20))
    
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        setupSearchController()
    }
    
    // MARK: - Helpers
    fileprivate func layoutUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        collectionView.addSubview(emptySearchLabel)
        emptySearchLabel.center(to: collectionView, by: .centerX, withMultiplierOf: 1)
        emptySearchLabel.center(to: collectionView, by: .centerY, withMultiplierOf: 0.25)
    }
    
    fileprivate func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    fileprivate func fetchSearchedApps(searchTerm: String) {
        NetworkManager.shared.fetchiTunesApps(searchTerm: searchTerm) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
                case .success(let searchResult):
                    self.apps = searchResult.results
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - UISearchBarDelegate
extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != "" else {
            emptySearchLabel.isHidden = false
            apps.removeAll()
            collectionView.reloadData()
            return
        }
        
        emptySearchLabel.isHidden = true

        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            self?.fetchSearchedApps(searchTerm: searchController.searchBar.text!)
        })
    }
}