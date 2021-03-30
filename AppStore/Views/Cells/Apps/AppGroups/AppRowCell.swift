//
//  AppRowCell.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class AppRowCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "AppRowCell"
    
    // MARK: - Views
    private let appIconImageView = ImageView(cornerRadius: 8)
    
    private let nameLabel = Label(text: "App Name", font: .boldSystemFont(ofSize: 16))
    private let companyLabel = Label(text: "Company Name", font: .systemFont(ofSize: 12))
    private lazy var labelStack = StackView(views: [nameLabel, companyLabel], axis: .vertical)
    
    private let getButton = Button(title: "GET", textColor: .systemBlue, font: .boldSystemFont(ofSize: 14), bgColor: #colorLiteral(red: 0.9146333933, green: 0.9102825522, blue: 0.9179967046, alpha: 1))
    
    private lazy var stackView = StackView(views: [appIconImageView, labelStack, getButton], spacing: 16, alignment: .center)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func layoutUI() {
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
        appIconImageView.setDimension(wConst: 64, hConst: 64)
        getButton.setDimension(wConst: 65, hConst: 32)
    }
    
    func configureWith(feedItem: FeedItem?) {
        guard let feedItem = feedItem else { return }
        nameLabel.text = feedItem.name
        companyLabel.text = feedItem.artistName
        appIconImageView.setImage(from: feedItem.artworkUrl100)
    }
}
