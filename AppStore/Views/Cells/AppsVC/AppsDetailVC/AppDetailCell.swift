//
//  AppDetailCell.swift
//  AppStore
//
//  Created by William Yeung on 3/29/21.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "AppDetailCell"
    
    // MARK: - Views
    let appIconImageView = ImageView(cornerRadius: 20)
    
    let nameLabel = Label(text: "App Name App Name", font: .boldSystemFont(ofSize: 20), numberOfLines: 2)
    let artistLabel = Label(text: "", textColor: .systemGray, font: .systemFont(ofSize: 14))
    let priceButton = Button(title: "$4.99", textColor: .white, font: UIFont.boldSystemFont(ofSize: 14), bgColor: .systemBlue)
    lazy var labelAndButtonStack = StackView(views: [nameLabel, artistLabel, UIView(), priceButton], axis: .vertical, spacing: 5, alignment: .leading)
    
    lazy var topStack = StackView(views: [appIconImageView, labelAndButtonStack], axis: .horizontal, spacing: 20)
    
    let whatsNewLabel = Label(text: "What's New", font: .boldSystemFont(ofSize: 20))
    let versionLabel = Label(text: "1.1.12", textColor: .systemGray, font: .systemFont(ofSize: 16))
    let releaseNotesLabel = Label(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
    lazy var releaseNotesStack = StackView(views: [whatsNewLabel, versionLabel, releaseNotesLabel], axis: .vertical, spacing: 10)
    
    lazy var overallStack = StackView(views: [topStack, releaseNotesStack], axis: .vertical, spacing: 18)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func layoutUI() {
        addSubview(overallStack)
        
        overallStack.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 20, padTrailing: 20, padBottom: 20, padLeading: 20)
        appIconImageView.setDimension(wConst: 110, hConst: 110)
        priceButton.setDimension(wConst: 80, hConst: 32)
        whatsNewLabel.setDimension(hConst: 35)
    }
    
    func configureWith(app: App?) {
        guard let app = app else { return }
        nameLabel.text = app.trackName
        artistLabel.text = app.artistName
        priceButton.setTitle(app.formattedPrice, for: .normal)
        appIconImageView.setImage(from: app.artworkUrl100)
        versionLabel.text = "Version " + app.version
        releaseNotesLabel.text = app.releaseNotes
    }
}
