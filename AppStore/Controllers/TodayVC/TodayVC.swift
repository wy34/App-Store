//
//  TodayVC.swift
//  AppStore
//
//  Created by William Yeung on 3/31/21.
//

import UIKit


class TodayVC: LoadingViewController {
    // MARK: - Properties
    var startingExpandedVCFrame: CGRect?
    
    var expandedVCTopAnchor: NSLayoutConstraint?
    var expandedVCLeadingAnchor: NSLayoutConstraint?
    var expandedVCWidthAnchor: NSLayoutConstraint?
    var expandedVCHeightAnchor: NSLayoutConstraint?
    
    var todayItems: [TodayItem] = []
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let cv = CollectionView(showsIndicators: false)
        cv.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        cv.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        cv.backgroundColor = #colorLiteral(red: 0.9269490838, green: 0.9225396514, blue: 0.9303577542, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.alpha = 0
        return view
    }()
    
    private var expandedVC: ExpandedVC?
    private var tappedCell: TodayCell?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        fetchApps()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Helpers
    func layoutUI() {
        view.addSubviews(collectionView, visualEffectView)
        collectionView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        visualEffectView.frame = view.bounds
    }
    
    func fetchApps() {
        showLoading()

        let dispatchGroup = DispatchGroup()
        
        var topGrossing: AppGroup?
        var editorsChoice: AppGroup?
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchApps(urlString: URLString.topGrossing.rawValue) { (result: Result<AppGroup, Error>) in
            dispatchGroup.leave()
            
            switch result {
                case .success(let appGroup):
                    topGrossing = appGroup
                case .failure(let error):
                    print(error)
            }
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchApps(urlString: URLString.editorChoice.rawValue) { (result: Result<AppGroup, Error>) in
            dispatchGroup.leave()
            
            switch result {
                case .success(let appGroup):
                    editorsChoice = appGroup
                case .failure(let error):
                    print(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.todayItems = [
                TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: UIImage(named: "garden")!, description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
                TodayItem(category: "Daily List", title: topGrossing?.feed.title ?? "", image: UIImage(named: "holiday")!, description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossing?.feed.results ?? []),
                TodayItem(category: "Daily List", title: editorsChoice?.feed.title ?? "", image: UIImage(named: "holiday")!, description: "", backgroundColor: .white, cellType: .multiple, apps: editorsChoice?.feed.results ?? []),
                TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: UIImage(named: "holiday")!, description: "Findout all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9850718379, green: 0.9644803405, blue: 0.7262819409, alpha: 1), cellType: .single, apps: [])
            ]
            
            self.collectionView.reloadData()
            self.dismissLoading()
        }
    }
    
    func showDailyListFullScreen(indexPath: IndexPath) {
        let multipleAppsVC = MultipleAppsVC(mode: .fullscreen)
        multipleAppsVC.results = todayItems[indexPath.item].apps
        let navController = UINavigationController(rootViewController: multipleAppsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    func expandedVCFullScreenSetup(indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        startingExpandedVCFrame = startingFrame
        collectionView.isUserInteractionEnabled = false
    }
    
    func layoutExpandedVC(indexPath: IndexPath) {
        guard let startingExpandedVCFrame = self.startingExpandedVCFrame else { return }
        expandedVC = ExpandedVC(todayItem: todayItems[indexPath.row], dismissHandler: { self.handleRemoveExpandedView() })
        tappedCell = expandedVC?.headerCell()
        
        addChild(expandedVC!)
        view.addSubview(expandedVC!.view)
        expandedVC!.didMove(toParent: self)
        
        expandedVC?.view.translatesAutoresizingMaskIntoConstraints = false
        expandedVCTopAnchor = expandedVC?.view.topAnchor.constraint(equalTo: view.topAnchor, constant: startingExpandedVCFrame.origin.y)
        expandedVCLeadingAnchor = expandedVC?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingExpandedVCFrame.origin.x)
        expandedVCWidthAnchor = expandedVC?.view.widthAnchor.constraint(equalToConstant: startingExpandedVCFrame.width)
        expandedVCHeightAnchor = expandedVC?.view.heightAnchor.constraint(equalToConstant: startingExpandedVCFrame.height)
        
        NSLayoutConstraint.activate([expandedVCTopAnchor!, expandedVCLeadingAnchor!, expandedVCWidthAnchor!, expandedVCHeightAnchor!])
        view.layoutIfNeeded()
    }
    
    func setExpandedVCAnchorConstants(top: CGFloat, leading: CGFloat, width: CGFloat, height: CGFloat) {
        self.expandedVCTopAnchor?.constant = top
        self.expandedVCLeadingAnchor?.constant = leading
        self.expandedVCWidthAnchor?.constant = width
        self.expandedVCHeightAnchor?.constant = height
        self.view.layoutIfNeeded()
    }
    
    func animateExpandedVCFullScreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.visualEffectView.alpha = 1
            self.tappedCell?.setStackViewTopAnchorTo(constant: 64)
            self.setExpandedVCAnchorConstants(top: 0, leading: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
        }
    }
    
    func showSingleAppFullScreen(indexPath: IndexPath) {
        expandedVCFullScreenSetup(indexPath: indexPath)
        layoutExpandedVC(indexPath: indexPath)
        animateExpandedVCFullScreen()
    }
    
    // MARK: - Selector
    @objc fileprivate func handleRemoveExpandedView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.expandedVC?.hideCloseButton()
            self.tappedCell?.setStackViewTopAnchorTo(constant: 32)
            
            self.visualEffectView.alpha = 0
            self.expandedVC?.view.transform = .identity

            self.setExpandedVCAnchorConstants(top: self.startingExpandedVCFrame!.origin.y, leading: self.startingExpandedVCFrame!.origin.x, width: self.startingExpandedVCFrame!.width, height: self.startingExpandedVCFrame!.height)
            
            self.expandedVC?.scrollToTop()
            
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height
        } completion: { (_) in
            self.expandedVC?.view.removeFromSuperview()
            self.collectionView.isUserInteractionEnabled = true
        }
    }
    
    @objc fileprivate func handleCellTapped(gesture: UIGestureRecognizer) {
        let collectionView = gesture.view
        var superView = collectionView?.superview

        while superView != nil {
            if let cell = superView as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                showDailyListFullScreen(indexPath: indexPath)
                return
            }

            superView = superView?.superview
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TodayVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = todayItems[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.cellType.rawValue, for: indexPath) as! BaseTodayCell
        (cell as? TodayMultipleAppCell)?.multipleAppsVC.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCellTapped(gesture:))))
        cell.configureWith(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: todayItems[indexPath.row].cellType == .single ? 450 : 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch todayItems[indexPath.item].cellType {
            case .single:
                showSingleAppFullScreen(indexPath: indexPath)
            case .multiple:
                showDailyListFullScreen(indexPath: indexPath)
        }
    }
}
