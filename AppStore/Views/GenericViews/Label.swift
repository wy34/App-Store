//
//  CustomLabel.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class Label: UILabel {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, bgColor: UIColor) {
        super.init(frame: .zero)
        self.text = text
//        self.backgroundColor = bgColor
    }
}
