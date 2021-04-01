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
    
    init(title: String, textColor: UIColor, font: UIFont, bgColor: UIColor) {
        super.init(frame: .zero)
        self.init(type: .system)
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        backgroundColor = bgColor
        layer.cornerRadius = 16
    }
    
    init(image: UIImage) {
        super.init(frame: .zero)
        self.init(type: .system)
        setImage(image, for: .normal)
        tintColor = #colorLiteral(red: 0.2272714972, green: 0.2261967659, blue: 0.2281063497, alpha: 1)
    }
}
