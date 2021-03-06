//
//  TrackCell.swift
//  AppStore
//
//  Created by William Yeung on 4/4/21.
//

import UIKit

class TrackCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "TrackCell"
    
    // MARK: - Views
    let imageView = ImageView(cornerRadius: 16)
    let nameLabel = Label(text: "Track Name", font: .boldSystemFont(ofSize: 18))
    let subtitleLabel = Label(text: "Subtitle Label", font: .systemFont(ofSize: 16), numberOfLines: 2)
    lazy var labelStackView = StackView(views: [nameLabel, subtitleLabel], axis: .vertical, spacing: 5)
    lazy var stackView = StackView(views: [imageView, labelStackView], spacing: 15, alignment: .center)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubview(stackView)
        stackView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTrailing: 16, padLeading: 16)
        imageView.setDimension(wConst: 80, hConst: 80)
    }
    
    func configureWith(app: App?) {
        guard let app = app else { return }
        nameLabel.text = app.trackName
        subtitleLabel.text = "\(app.artistName)"
        imageView.setImage(from: app.artworkUrl100)
    }
}
