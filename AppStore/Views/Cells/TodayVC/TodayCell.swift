//
//  TodayCell.swift
//  AppStore
//
//  Created by William Yeung on 3/31/21.
//

import UIKit

class TodayCell: BaseTodayCell {
    // MARK: - Properties
    var stackViewTopAnchor: NSLayoutConstraint?
    
    // MARK: - Views
    private let categoryLabel = Label(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    private let titleLabel = Label(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 26))
    private let imageView = ImageView(image: UIImage(named: "garden")!)
    private let imageContainerView = UIView()
    private let descriptionLabel = Label(text: "All the tools and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)
    
    lazy var stackView = StackView(views: [categoryLabel, titleLabel, imageContainerView, descriptionLabel], axis: .vertical, spacing: 8)
    
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
        addSubview(stackView)
        
        stackViewTopAnchor = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 32)
        stackViewTopAnchor?.isActive = true
        stackView.anchor(trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTrailing: 32, padBottom: 32, padLeading: 32)

        imageContainerView.addSubview(imageView)
        imageView.setDimension(wConst: 225, hConst: 200)
        imageView.center(x: imageContainerView.centerXAnchor, y: imageContainerView.centerYAnchor)
    }
    
    override func configureWith(item: TodayItem) {
        categoryLabel.text = item.category
        titleLabel.text = item.title
        imageView.image = item.image
        descriptionLabel.text = item.description
        backgroundColor = item.backgroundColor
    }
    
    func setStackViewTopAnchorTo(constant: CGFloat) {
        stackViewTopAnchor?.constant = constant
        layoutIfNeeded()
    }
}
