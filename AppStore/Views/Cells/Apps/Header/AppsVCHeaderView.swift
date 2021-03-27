//
//  AppsVCHeaderView.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class AppsVCHeaderView: UICollectionReusableView {
    // MARK: - Properties
    static let reuseId = "AppsVCHeaderView"
    
    // MARK: - Views
    let headerVC = HeaderVC()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func layoutUI() {
        addSubview(headerVC.view)
        
        headerVC.view.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
}
