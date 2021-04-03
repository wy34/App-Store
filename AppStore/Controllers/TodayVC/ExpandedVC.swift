//
//  ExpandedVC.swift
//  AppStore
//
//  Created by William Yeung on 3/31/21.
//

import UIKit

class ExpandedVC: UIViewController {
    // MARK: - Properties
    var todayItem: TodayItem?
    var dismissHandler: (() -> Void)?

    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(ExpandedVCCell.self, forCellReuseIdentifier: ExpandedVCCell.reuseId)
        tv.register(ExpandedVCHeaderCell.self, forCellReuseIdentifier: ExpandedVCHeaderCell.reuseId)
        tv.backgroundColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        tv.contentInsetAdjustmentBehavior = .never
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        return tv
    }()
    
    private let closeButton = Button(image: UIImage(systemName: "xmark.circle.fill")!.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 23)))!)
    
    // MARK: - Init
    init(todayItem: TodayItem, dismissHandler: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.todayItem = todayItem
        self.dismissHandler = dismissHandler
        self.tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureUI()
        addPanGesture()
    }
    
    // MARK: - Helpers
    func layoutUI() {
        view.addSubviews(tableView, closeButton)
        tableView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        closeButton.anchor(top: view.topAnchor, trailing: view.trailingAnchor, padTop: 45, padTrailing: 20)
    }
    
    func configureUI() {
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        closeButton.addTarget(self, action: #selector(dismissExpandedView), for: .touchUpInside)
    }
    
    func hideCloseButton() {
        closeButton.isHidden = true
    }
    
    func scrollToTop() {
        tableView.contentOffset = .zero
    }
    
    func headerCell() -> TodayCell? {
        guard let expandedVCHeaderCell = tableView.cellForRow(at: [0, 0]) as? ExpandedVCHeaderCell else { return nil }
        return expandedVCHeaderCell.todayCell
    }
    
    func addPanGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(gesture:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
    }
    
    // MARK: - Selector
    @objc func dismissExpandedView() {
        dismissHandler?()
    }
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        let translationY = gesture.translation(in: view).y
        
        if tableView.contentOffset.y > 0 {
            return
        }
        
        if gesture.state == .changed {
            if translationY > 0 {
                let scale = max(1 - (translationY / 1000), 0.5)
                view.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        } else if gesture.state == .ended {
            if translationY > 0 {
                dismissHandler?()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDatasource
extension ExpandedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedVCHeaderCell.reuseId, for: indexPath) as! ExpandedVCHeaderCell
            cell.configureWith(item: todayItem)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedVCCell.reuseId, for: indexPath) as! ExpandedVCCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }
        
        return tableView.rowHeight
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ExpandedVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
