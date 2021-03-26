//
//  StackView.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class StackView: UIStackView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(views: [UIView], axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        views.forEach({ addArrangedSubview($0) })
    }
    
}
