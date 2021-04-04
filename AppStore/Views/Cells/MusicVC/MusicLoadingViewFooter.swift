//
//  MusicLoadingView.swift
//  AppStore
//
//  Created by William Yeung on 4/4/21.
//

import UIKit

class MusicLoadingViewFooter: UICollectionReusableView {
    // MARK: - Properties
    static let reuseId = "MusicLoadingViewFooter"
    
    // MARK: - Views
    private let spinner: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.style = .large
        a.startAnimating()
        a.hidesWhenStopped = true
        return a
    }()
    
    private let loadingLabel = Label(text: "Loading more...", alignment: .center, font: .systemFont(ofSize: 16))
    private lazy var stackView = StackView(views: [spinner, loadingLabel], axis: .vertical, spacing: 10)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubviews(stackView)
        stackView.center(x: centerXAnchor, y: centerYAnchor)
        stackView.setDimension(wConst: 200)
    }
}
