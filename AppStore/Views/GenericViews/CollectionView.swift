//
//  CollectionViewController.swift
//  AppStore
//
//  Created by William Yeung on 3/26/21.
//

import UIKit

class CollectionView: UICollectionView {
    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(scrollDirection: UICollectionView.ScrollDirection = .vertical, showsIndicators: Bool = true, enableSnap: Bool = false) {
        let layout = SnappingLayout()
        layout.scrollDirection = scrollDirection
        
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .white
        showsVerticalScrollIndicator = showsIndicators
        showsHorizontalScrollIndicator = showsIndicators
        decelerationRate = enableSnap ? .fast : .normal
    }
}

// MARK: - CustomFlowLayout
class SnappingLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
