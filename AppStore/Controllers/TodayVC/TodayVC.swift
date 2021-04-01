//
//  TodayVC.swift
//  AppStore
//
//  Created by William Yeung on 3/31/21.
//

import UIKit


class TodayVC: UIViewController {
    // MARK: - Properties
    var startingExpandedVCFrame: CGRect?
    
    var expandedVCTopAnchor: NSLayoutConstraint?
    var expandedVCLeadingAnchor: NSLayoutConstraint?
    var expandedVCWidthAnchor: NSLayoutConstraint?
    var expandedVCHeightAnchor: NSLayoutConstraint?
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(TodayCell.self, forCellWithReuseIdentifier: TodayCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private var expandedVC: ExpandedVC?
    private var tappedCell: TodayCell?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Helpers
    func layoutUI() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
    }
    
    // MARK: - Selector
    @objc func handleRemoveRedView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.expandedVC?.hideCloseButton()

            self.expandedVCTopAnchor?.constant = self.startingExpandedVCFrame!.origin.y
            self.expandedVCLeadingAnchor?.constant = self.startingExpandedVCFrame!.origin.x
            self.expandedVCWidthAnchor?.constant = self.startingExpandedVCFrame!.width
            self.expandedVCHeightAnchor?.constant = self.startingExpandedVCFrame!.height
            self.view.layoutIfNeeded()
            
            self.expandedVC?.scrollToTop()
            
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height
        } completion: { (_) in
            self.expandedVC?.view.removeFromSuperview()
            self.tappedCell?.imageView.alpha = 1
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TodayVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCell.reuseId, for: indexPath) as! TodayCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TodayCell else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingExpandedVCFrame = startingFrame
        self.tappedCell = cell
        
        expandedVC = ExpandedVC()
        expandedVC?.delegate = self
        expandedVC?.view.layer.cornerRadius = 16
        expandedVC?.view.clipsToBounds = true
        
        addChild(expandedVC!)
        view.addSubview(expandedVC!.view)
        expandedVC!.didMove(toParent: self)
        
        expandedVC?.view.translatesAutoresizingMaskIntoConstraints = false
        expandedVCTopAnchor = expandedVC?.view.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        expandedVCLeadingAnchor = expandedVC?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        expandedVCWidthAnchor = expandedVC?.view.widthAnchor.constraint(equalToConstant: startingFrame.width)
        expandedVCHeightAnchor = expandedVC?.view.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        NSLayoutConstraint.activate([expandedVCTopAnchor!, expandedVCLeadingAnchor!, expandedVCWidthAnchor!, expandedVCHeightAnchor!])
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            cell.imageView.alpha = 0
            self.expandedVCTopAnchor?.constant = 0
            self.expandedVCLeadingAnchor?.constant = 0
            self.expandedVCWidthAnchor?.constant = self.view.frame.width
            self.expandedVCHeightAnchor?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
        }
    }
}

// MARK: - ExpandedVCDelegate
extension TodayVC: ExpandedVCDelegate {
    func dismissExpandedVC() {
        handleRemoveRedView()
    }
}
