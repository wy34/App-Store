//
//  RatingCell.swift
//  AppStore
//
//  Created by William Yeung on 3/30/21.
//

import UIKit

class RatingCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "RatingCell"
    
    // MARK: - Views
    private let titleLabel = Label(text: "Review Title", font: .boldSystemFont(ofSize: 16))
    private let authorLabel = Label(text: "Author Title", textColor: .systemGray, alignment: .right, font: .systemFont(ofSize: 14))
    private lazy var titleAuthorStack = StackView(views: [titleLabel, authorLabel], spacing: 5)
    
//    private let starsLabel = Label(text: "Stars", font: .systemFont(ofSize: 14))
    private lazy var starsStack = StackView(arrangedSubviews: [])
    private let bodyLabel = Label(text: "Review Review", font: .systemFont(ofSize: 14), numberOfLines: 0)
    
    private lazy var labelStack = StackView(views: [titleAuthorStack, starsStack, bodyLabel, UIView()], axis: .vertical, spacing: 8)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
//        setupStarRatings(ratingString: "2")
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func layoutUI() {
        addSubview(labelStack)
        labelStack.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 15, padTrailing: 15, padBottom: 13, padLeading: 15)
    }
    
    func setupStarRatings(ratingString: String) {
        for view in starsStack.arrangedSubviews {
            starsStack.removeArrangedSubview(view)
        }
        
        var unfilledStars = 0
        
        if let ratingNum = Int(ratingString) {
            unfilledStars = 5 - ratingNum
            
            for _ in 0..<ratingNum {
                starsStack.addArrangedSubview(ImageView(image: UIImage(systemName: "star.fill")!, tintColor: #colorLiteral(red: 1, green: 0.5303313732, blue: 0.005718221888, alpha: 1)))
            }
        }
        
        for _ in 0..<unfilledStars {
            starsStack.addArrangedSubview(ImageView(image: UIImage(systemName: "star")!, tintColor: #colorLiteral(red: 1, green: 0.5303313732, blue: 0.005718221888, alpha: 1)))
        }
        
        starsStack.addArrangedSubview(UIView())
    }
    
    func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9146333933, green: 0.9102825522, blue: 0.9179967046, alpha: 1)
        layer.cornerRadius = 16
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
    }
    
    func configureWith(reviewEntry: Entry?) {
        guard let reviewEntry = reviewEntry else { return }
        titleLabel.text = reviewEntry.title.label
        authorLabel.text = reviewEntry.author.name.label
        bodyLabel.text = reviewEntry.content.label
        setupStarRatings(ratingString: reviewEntry.rating.label)
    }
}
