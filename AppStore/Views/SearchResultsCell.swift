//
//  SearchResultsCell.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class SearchResultsCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "SearchResultsCell"
    
    // MARK: - Views
    private let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let nameLabel = Label(text: "App Name", bgColor: .blue)
    private let categoryLabel = Label(text: "Photos & Video", bgColor: .purple)
    private let ratingLabel = Label(text: "9.26M", bgColor: .systemPink)
    private lazy var labelStackView = StackView(views: [nameLabel, categoryLabel, ratingLabel], axis: .vertical)
    
    private let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var topInfoStackView = StackView(views: [appIconImageView, labelStackView, getButton], spacing: 12, alignment: .center)
    
    private let screenshot1ImageView = ImageView()
    private let screenshot2ImageView = ImageView()
    private let screenshot3ImageView = ImageView()
    private lazy var screenShotStackView = StackView(views: [screenshot1ImageView, screenshot2ImageView, screenshot3ImageView], spacing: 12, distribution: .fillEqually)
    
    private lazy var overallStackView = StackView(views: [topInfoStackView, screenShotStackView], axis: .vertical, spacing: 16)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    fileprivate func layoutUI() {
        addSubview(overallStackView)
        
        overallStackView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 16, padTrailing: 16, padBottom: 16, padLeading: 16)
        appIconImageView.setDimension(wConst: 64, hConst: 64)
        getButton.setDimension(wConst: 80, hConst: 32)
    }
    
    func set(app: App) {
        nameLabel.text = app.trackName
        categoryLabel.text = app.primaryGenreName
        ratingLabel.text = String(app.averageUserRating ?? 0.0)
    }
}
