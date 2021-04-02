//
//  ExpandedVCCell.swift
//  AppStore
//
//  Created by William Yeung on 3/31/21.
//

import UIKit

class ExpandedVCCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "ExpandedVCCell"
    
    // MARK: - Views
    private let descriptionLabel: Label = {
        let label = Label()
        let attributedText = NSMutableAttributedString(string: "Great games", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: " are all about the details, from subtle visual effects to imaginative art styles. In these titles, you're sure to find something to marvel at, whether you're into fantasy worlds or neon-soaked dartboards.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSAttributedString(string: "\n\n\nHeroic adventure", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedText.append(NSAttributedString(string: "\nBattle in dungeons. Collection treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSAttributedString(string: "\n\n\nHeroic adventure", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedText.append(NSAttributedString(string: "\nBattle in dungeons. Collection treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
        label.attributedText = attributedText
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
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
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 32, padTrailing: 32, padBottom: 32, padLeading: 32)
    }
}
