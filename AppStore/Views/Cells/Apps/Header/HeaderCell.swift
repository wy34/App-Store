//
//  HeaderCell.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "HeaderCell"
    
    // MARK: - Views
    private let companyLabel = Label(text: "Facebook", textColor: .blue, font: .systemFont(ofSize: 12))
    private let titleLabel = Label(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 22), numberOfLines: 2)
    private let imageView = ImageView(cornerRadius: 8)
    
    private lazy var stackView = StackView(views: [companyLabel, titleLabel, imageView], axis: .vertical, spacing: 12)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = .red
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func layoutUI() {
        addSubview(stackView)
        stackView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 16)
    }
}
