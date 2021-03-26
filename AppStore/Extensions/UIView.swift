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
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, padTop: CGFloat = 0, padTrailing: CGFloat = 0, padBottom: CGFloat = 0, padLeading: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padTop).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padTrailing).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padBottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padLeading).isActive = true
        }
    }
    
    func setDimension(wConst: CGFloat? = nil, hConst: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let wConst = wConst {
            widthAnchor.constraint(equalToConstant: wConst).isActive = true
        }
        
        if let hConst = hConst {
            heightAnchor.constraint(equalToConstant: hConst).isActive = true
        }
    }
}
