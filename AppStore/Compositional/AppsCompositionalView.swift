//
//  AppsCompositionalView.swift
//  AppStore
//
//  Created by William Yeung on 4/4/21.
//

import SwiftUI

class CompositionalHeader: UICollectionReusableView {
    let label = Label(text: "Editor's Choice Games", font: .boldSystemFont(ofSize: 32))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class CompositionalController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    var socialApps = [SocialApp]()
    var editorsChoice: AppGroup?
    
    var diffableDatasource: UICollectionViewDiffableDataSource<AppSection, AnyHashable>?
    
    enum AppSection {
        case topSocial
        case grossing
        case freeGames
        case topFree
    }
    
    // MARK: - Init
    init() {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3333)))
                item.contentInsets = .init(.init(top: 0, leading: 0, bottom: 16, trailing: 16))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 0)
                
                let elementKind = UICollectionView.elementKindSectionHeader
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: elementKind, alignment: .topLeading)
                ]
                
                return section
            }
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.leading = 16
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 16)
        return section
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDiffableDatasource()
        fetchApps2()
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseId)
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: AppRowCell.reuseId)
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        navigationItem.rightBarButtonItem = .init(title: "Fetch Top Free", style: .plain, target: self, action: #selector(handleFetchTopFree))
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func fetchApps() {
        let dispatchGroup = DispatchGroup()
        
        var socialApps: [SocialApp]?
        var editorsChoice: AppGroup?
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchApps(urlString: URLString.social.rawValue) { (result: Result<[SocialApp], Error>) in
            dispatchGroup.leave()
            switch result {
                case .success(let result):
                    socialApps = result
                case .failure(let error):
                    print(error)
            }
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchApps(urlString: URLString.editorChoice.rawValue) { (result: Result<AppGroup, Error>) in
            dispatchGroup.leave()
            switch result {
                case .success(let result):
                    editorsChoice = result
                case .failure(let error):
                    print(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.socialApps = socialApps!
            self.editorsChoice = editorsChoice
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - DiffableDatasource
    func setupDiffableDatasource() {
        diffableDatasource = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
            if let object = object as? SocialApp {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.reuseId, for: indexPath) as! HeaderCell
                cell.configureWith(socialApp: object)
                return cell
            } else if let object = object as? FeedItem {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCell.reuseId, for: indexPath) as! AppRowCell
                cell.configureWith(feedItem: object)
                cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .touchUpInside)
                return cell
            }
            
            return nil
        }
   
        // for header
        diffableDatasource?.supplementaryViewProvider = .some({ (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CompositionalHeader
            
            // changing section titles
//            let snapshot = self.diffableDatasource?.snapshot()
//            let object = self.diffableDatasource?.itemIdentifier(for: indexPath)
//            let section = snapshot?.sectionIdentifier(containingItem: object!)!
//
//            if section == .freeGames {
//                header.label.text = "Free Games"
//            } else {
//                header.label.text = "Top Grossing"
//            }
            
            return header
        })
        
        collectionView.dataSource = diffableDatasource
    }
    
    func fetchApps2() {
        NetworkManager.shared.fetchApps(urlString: URLString.social.rawValue) { (result: Result<[SocialApp], Error>) in
            switch result {
                case .success(let result):
                    self.updateSnapshot(socialApps: result, grossing: nil, games: nil)
                case .failure(let error):
                    print(error)
            }
        }
        
        NetworkManager.shared.fetchApps(urlString: URLString.topGrossing.rawValue) { (result: Result<AppGroup, Error>) in
            switch result {
                case .success(let result):
                    self.updateSnapshot(socialApps: nil, grossing: result, games: nil)
                case .failure(let error):
                    print(error)
            }
        }
        
        NetworkManager.shared.fetchApps(urlString: URLString.editorChoice.rawValue) { (result: Result<AppGroup, Error>) in
            switch result {
                case .success(let result):
                    self.updateSnapshot(socialApps: nil, grossing: nil, games: result)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func updateSnapshot(socialApps: [SocialApp]?, grossing: AppGroup?, games: AppGroup?) {
        var snapshot = diffableDatasource?.snapshot()
        
        if let socialApps = socialApps {
            snapshot!.appendSections([.topSocial, .grossing, .freeGames])
            snapshot?.appendItems(socialApps, toSection: .topSocial)
        } else if let grossing = grossing {
            snapshot?.appendItems(grossing.feed.results, toSection: .grossing)
        } else {
            snapshot?.appendItems(games!.feed.results, toSection: .freeGames)
        }
        
        diffableDatasource?.apply(snapshot!)
    }
    
    // MARK: - Selectors
    @objc func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        var snapshot = diffableDatasource?.snapshot()
        snapshot?.deleteSections([.topFree, .freeGames, .grossing])
        diffableDatasource?.apply(snapshot!)
    }
    
    @objc func handleGet(button: UIView) {
        var superView = button.superview
        
        while superView != nil {
            if let cell = superView as? UICollectionViewCell {
                guard let indexPath = collectionView.indexPath(for: cell) else { return }
                guard let objIClickedOnto = diffableDatasource?.itemIdentifier(for: indexPath) else { return }
                var snapshot = diffableDatasource?.snapshot()
                snapshot?.deleteItems([objIClickedOnto])
                diffableDatasource?.apply(snapshot!)
            }
            
            superView = superView?.superview
        }
    }
    
    @objc func handleFetchTopFree() {
        NetworkManager.shared.fetchApps(urlString: URLString.topFree.rawValue) { (result: Result<AppGroup, Error>) in
            switch result {
                case .success(let result):
                    var snapshot = self.diffableDatasource?.snapshot()
                    snapshot?.insertSections([.topFree], afterSection: .topSocial)
                    snapshot?.appendItems(result.feed.results, toSection: .topFree)
                    self.diffableDatasource?.apply(snapshot!)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    // MARK: - CollectionView
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CompositionalHeader
//        return header
//    }
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return section == 0 ? socialApps.count : (editorsChoice?.feed.results.count ?? 0)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.section == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.reuseId, for: indexPath) as! HeaderCell
//            cell.configureWith(socialApp: socialApps[indexPath.item])
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCell.reuseId, for: indexPath) as! AppRowCell
//            cell.configureWith(feedItem: editorsChoice?.feed.results[indexPath.item])
//            return cell
//        }
//    }
//
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var appId: String
        
        let object = diffableDatasource?.itemIdentifier(for: indexPath)
        
        if let object = object as? SocialApp {
            appId = object.id
        } else if let object = object as? FeedItem {
            appId = object.id
        } else {
            appId = ""
        }
        
//        if indexPath.section == 0 {
//            appId = socialApps[indexPath.item].id
//        } else {
//            appId = editorsChoice!.feed.results[indexPath.item].id
//        }

        let appDetailVC = AppDetailVC(id: appId)
        navigationController?.pushViewController(appDetailVC, animated: true)
    }
}



















struct AppsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct AppsView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}

