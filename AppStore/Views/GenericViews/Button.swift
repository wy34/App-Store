//
//  Button.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class Button: UIButton {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.init(type: .system)
        setTitle(title, for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 14)
        backgroundColor = UIColor(white: 0.9, alpha: 1)
        layer.cornerRadius = 16
    }
}
