//
//  AppsCompositionalView.swift
//  AppStore
//
//  Created by William Yeung on 4/4/21.
//

import SwiftUI

class CompositionalHeader: UICollectionReusableView {
    private let label = Label(text: "Editor's Choice Games", font: .boldSystemFont(ofSize: 32))
    
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
        fetchApps()
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
    
    // MARK: - CollectionView
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CompositionalHeader
        return header
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? socialApps.count : (editorsChoice?.feed.results.count ?? 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.reuseId, for: indexPath) as! HeaderCell
            cell.configureWith(socialApp: socialApps[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCell.reuseId, for: indexPath) as! AppRowCell
            cell.configureWith(feedItem: editorsChoice?.feed.results[indexPath.item])
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var appId: String
        
        if indexPath.section == 0 {
            appId = socialApps[indexPath.item].id
        } else {
            appId = editorsChoice!.feed.results[indexPath.item].id
        }
        
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

