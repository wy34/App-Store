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
        closeButton.addTarget(self, action: #selector(dismissExpandedView), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    func layoutUI() {
        view.addSubviews(tableView, closeButton)
        tableView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        closeButton.anchor(top: view.topAnchor, trailing: view.trailingAnchor, padTop: 45, padTrailing: 20)
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
    
    // MARK: - Selector
    @objc func dismissExpandedView() {
        dismissHandler?()
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
