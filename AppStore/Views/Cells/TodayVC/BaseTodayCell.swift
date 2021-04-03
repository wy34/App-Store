//
//  BaseTodayCell.swift
//  AppStore
//
//  Created by William Yeung on 4/1/21.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {
    // MARK: - Properties
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.transform = self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureWith(item: TodayItem) {
        
    }
}
