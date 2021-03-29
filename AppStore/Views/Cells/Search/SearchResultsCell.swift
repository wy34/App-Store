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
    private let appIconImageView = ImageView(cornerRadius: 12)
    private let nameLabel = Label(text: "App Name")
    private let categoryLabel = Label(text: "Photos & Video")
    private let ratingLabel = Label(text: "9.26M")
    private lazy var labelStackView = StackView(views: [nameLabel, categoryLabel, ratingLabel], axis: .vertical)
 
    private let getButton = Button(title: "GET")
    
    private lazy var topInfoStackView = StackView(views: [appIconImageView, labelStackView, getButton], spacing: 12, alignment: .center)
    
    private let screenshot1ImageView = ImageView(cornerRadius: 8, borderWidth: 0.5, borderColor: UIColor(white: 0.5, alpha: 0.5))
    private let screenshot2ImageView = ImageView(cornerRadius: 8, borderWidth: 0.5, borderColor: UIColor(white: 0.5, alpha: 0.5))
    private let screenshot3ImageView = ImageView(cornerRadius: 8, borderWidth: 0.5, borderColor: UIColor(white: 0.5, alpha: 0.5))
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
        getButton.setDimension(wConst: 65, hConst: 32)
    }
    
    func configureWith(app: App) {
        nameLabel.text = app.trackName
        categoryLabel.text = app.primaryGenreName
        ratingLabel.text = String(app.averageUserRating ?? 0.0)
        setImages(forApp: app)
    }
    
    func setImages(forApp app: App) {
        appIconImageView.image = nil
        appIconImageView.setImage(from: app.artworkUrl100)
        
        for i in 0...2 {
            [screenshot1ImageView, screenshot2ImageView, screenshot3ImageView][i].image = nil
            
            if app.screenshotUrls.count > i {
                switch i {
                    case 0:
                        screenshot1ImageView.setImage(from: app.screenshotUrls[i])
                    case 1:
                        screenshot2ImageView.setImage(from: app.screenshotUrls[i])
                    default:
                        screenshot3ImageView.setImage(from: app.screenshotUrls[i])
                }
            }
        }
    }
}
