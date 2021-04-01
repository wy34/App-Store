//
//  TodayCell.swift
//  AppStore
//
//  Created by William Yeung on 3/31/21.
//

import UIKit

class TodayCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "TodayCell"
    
    // MARK: - Views
    let categoryLabel = Label(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = Label(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 26))
    let imageView = ImageView(image: UIImage(named: "garden")!)
    let imageContainerView = UIView()
    let descriptionLabel = Label(text: "All the tools and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)
    
    lazy var stackView = StackView(views: [categoryLabel, titleLabel, imageContainerView, descriptionLabel], axis: .vertical, spacing: 8)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func layoutUI() {
        addSubview(stackView)
        stackView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 32, padTrailing: 32, padBottom: 32, padLeading: 32)

        imageContainerView.addSubview(imageView)
        imageView.setDimension(wConst: 225, hConst: 200)
        imageView.center(x: imageContainerView.centerXAnchor, y: imageContainerView.centerYAnchor)
    }
    
    func configureWith(item: TodayItem) {
        categoryLabel.text = item.category
        titleLabel.text = item.title
        imageView.image = item.image
        descriptionLabel.text = item.description
        backgroundColor = item.backgroundColor
    }
}
