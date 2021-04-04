//
//  PreviewCell.swift
//  AppStore
//
//  Created by William Yeung on 3/29/21.
//

import UIKit

class PreviewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "PreviewCell"
    
    // MARK: - Views
    private let previewLabel = Label(text: "Preview", font: .boldSystemFont(ofSize: 20))
    private let previewsVC = PreviewsVC()
    
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
        addSubviews(previewLabel, previewsVC.view)
        previewLabel.anchor(top: topAnchor, trailing: trailingAnchor, leading: leadingAnchor, padLeading: 16)
        previewsVC.view.anchor(top: previewLabel.bottomAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 12)
    }
    
    func configureWith(app: App?) {
        guard let app = app else { return }
        previewsVC.app = app
    }
}
