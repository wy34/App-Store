//
//  TodayMultipleAppsVC.swift
//  AppStore
//
//  Created by William Yeung on 4/1/21.
//

import UIKit

enum Mode {
    case small, fullscreen
}

class MultipleAppsVC: UIViewController {
    // MARK: - Properties
    var results: [FeedItem]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var mode: Mode?
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(MultipleCell.self, forCellWithReuseIdentifier: MultipleCell.reuseId)
        cv.backgroundColor = .white
        cv.isScrollEnabled = mode == .small ? false : true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let closeButton = Button(image: UIImage(systemName: "xmark.circle.fill")!.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 23)))!)
    
    // MARK: - Init
    init(mode: Mode) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
        closeButton.alpha = (mode == .small) ? 0 : 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        closeButton.addTarget(self, action: #selector(dismissMultipleAppsVC), for: .touchUpInside)
    }

    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - Helpers
    private func layoutUI() {
        view.addSubviews(collectionView, closeButton)
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, padTop: 10)
        closeButton.anchor(top: view.topAnchor, trailing: view.trailingAnchor, padTop: 45, padTrailing: 20)
    }
    
    // MARK: - Selectors
    @objc func dismissMultipleAppsVC() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate UICollectionViewDelegateFlowLayout
extension MultipleAppsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode == .small ? min(4, results?.count ?? 0) : results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleCell.reuseId, for: indexPath) as! MultipleCell
        cell.configureWith(feedItem: results?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = mode == .small ? view.frame.height / 4 : 74
        let width = mode == .small ? view.frame.width : view.frame.width - 48
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard mode == .small else { return .init(top: 25, left: 0, bottom: 0, right: 0) }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

