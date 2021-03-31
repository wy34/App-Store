//
//  ReviewsCell.swift
//  AppStore
//
//  Created by William Yeung on 3/30/21.
//

import UIKit

class ReviewsCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "ReviewsCell"
    
    // MARK: - Views
    private let reviewsVC = ReviewsVC()
    private let reviewsLabel = Label(text: "Reviews & Ratings", font: .boldSystemFont(ofSize: 20))
    
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
        addSubviews(reviewsLabel, reviewsVC.view)
        reviewsLabel.anchor(top: topAnchor, trailing: trailingAnchor, leading: leadingAnchor, padTop: 12, padLeading: 16)
        reviewsVC.view.anchor(top: reviewsLabel.bottomAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 12)
    }
    
    func configureWith(reviews: Reviews?) {
        guard let reviews = reviews else { return }
        reviewsVC.reviewEntries = reviews.feed.entry
    }
}
