//
//  View.swift
//  AppStore
//
//  Created by William Yeung on 3/29/21.
//

import UIKit

class PlainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(bgColor: UIColor) {
        super.init(frame: .zero)
        backgroundColor = bgColor
    }
}
