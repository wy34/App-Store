//
//  TodayMultipleAppCell.swift
//  AppStore
//
//  Created by William Yeung on 4/1/21.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    // MARK: - Properties
    
    // MARK: - Views
    private let categoryLabel = Label(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    private let titleLabel = Label(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 26), numberOfLines: 2)
    private let multipleAppsVC = MultipleAppsVC(mode: .small)
    
    private lazy var stackView = StackView(views: [categoryLabel, titleLabel, multipleAppsVC.view], axis: .vertical, spacing: 8)
    
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
    private func layoutUI() {
        addSubview(stackView)
        stackView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 32, padTrailing: 32, padBottom: 32, padLeading: 32)
    }
    
    override func configureWith(item: TodayItem) {
        categoryLabel.text = item.category
        titleLabel.text = item.title
        backgroundColor = item.backgroundColor
        multipleAppsVC.results = item.apps
    }
}
