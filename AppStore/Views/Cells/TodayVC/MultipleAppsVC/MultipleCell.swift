//
//  MultipleCell.swift
//  AppStore
//
//  Created by William Yeung on 4/1/21.
//

import UIKit

class MultipleCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "MultipleCell"
    
    // MARK: - Views
    private let appIconImageView = ImageView(cornerRadius: 12)
    
    private let nameLabel = Label(text: "App Name", font: .boldSystemFont(ofSize: 16))
    private let companyLabel = Label(text: "Company Name", font: .systemFont(ofSize: 12))
    private lazy var labelStack = StackView(views: [nameLabel, companyLabel], axis: .vertical)
    
    private let getButton = Button(title: "GET", textColor: .systemBlue, font: .boldSystemFont(ofSize: 14), bgColor: #colorLiteral(red: 0.9146333933, green: 0.9102825522, blue: 0.9179967046, alpha: 1))
    
    private lazy var stackView = StackView(views: [appIconImageView, labelStack, getButton], spacing: 16, alignment: .center)
    
    private let separator = PlainView(bgColor: #colorLiteral(red: 0.8808360696, green: 0.8841300607, blue: 0.8920767903, alpha: 1))
    
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
        addSubviews(stackView, separator)
        
        stackView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
        appIconImageView.setDimension(wConst: 64, hConst: 64)
        getButton.setDimension(wConst: 65, hConst: 32)
        
        separator.anchor(top: stackView.bottomAnchor, trailing: trailingAnchor)
        separator.setDimension(wConst: frame.width - 80, hConst: 1)
    }
    
    func configureWith(feedItem: FeedItem?) {
        guard let feedItem = feedItem else { return }
        nameLabel.text = feedItem.name
        companyLabel.text = feedItem.artistName
        appIconImageView.setImage(from: feedItem.artworkUrl100)
    }
}
