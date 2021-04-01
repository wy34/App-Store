//
//  ExpandedVCHeaderCell.swift
//  AppStore
//
//  Created by William Yeung on 4/1/21.
//

import UIKit

class ExpandedVCHeaderCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "ExpandedVCHeaderCell"
    
    // MARK: - Views
    private let todayCell = TodayCell()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func layoutUI() {
        addSubviews(todayCell)
        todayCell.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
    
    func configureWith(item: TodayItem?) {
        guard let item = item else { return }
        todayCell.configureWith(item: item)
    }
}
