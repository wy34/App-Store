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
    private let imageView = ImageView(cornerRadius: 8)
    
    private let nameLabel = Label(text: "App Name", font: .boldSystemFont(ofSize: 16))
    private let companyLabel = Label(text: "Company Name", font: .systemFont(ofSize: 12))
    private lazy var labelStack = StackView(views: [nameLabel, companyLabel], axis: .vertical)
    
    private let getButton = Button(title: "GET")
    
    private lazy var stackView = StackView(views: [imageView, labelStack, getButton], spacing: 16, alignment: .center)
    
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
        
        stackView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
        imageView.setDimension(wConst: 64, hConst: 64)
        getButton.setDimension(wConst: 65, hConst: 32)
    }
}
