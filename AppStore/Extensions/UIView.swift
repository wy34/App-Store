//
//  UIView.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
