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
    
    private let floatingContainerView: View = {
        let view = View()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
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
        setupFloatingControls()
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
    
    func setupFloatingControls() {
        view.addSubview(floatingContainerView)
        floatingContainerView.setDimension(hConst: 90)
        floatingContainerView.anchor(trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, padTrailing: 16, padBottom: -150, padLeading: 16)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        floatingContainerView.addSubview(visualEffectView)
        visualEffectView.setDimension(wAnchor: floatingContainerView.widthAnchor, hAnchor: floatingContainerView.heightAnchor)
        visualEffectView.center(x: floatingContainerView.centerXAnchor, y: floatingContainerView.centerYAnchor)
        
        let imageView = ImageView(image: todayItem!.image, cornerRadius: 16)
        let titleLabel = Label(text: "Life Hack", font: .boldSystemFont(ofSize: 18))
        let captionLabel = Label(text: "Utilizing your Time", font: .systemFont(ofSize: 16))
        let getButton = Button(title: "GET", textColor: .white, font: .boldSystemFont(ofSize: 16), bgColor: .darkGray)
        getButton.layer.cornerRadius = 16
        
        let labelStackView = StackView(views: [titleLabel, captionLabel], axis: .vertical)
        let stackView = StackView(views: [imageView, labelStackView, getButton], spacing: 16, alignment: .center)
        
        floatingContainerView.addSubview(stackView)
        stackView.anchor(top: floatingContainerView.topAnchor, trailing: floatingContainerView.trailingAnchor, bottom: floatingContainerView.bottomAnchor, leading: floatingContainerView.leadingAnchor, padTop: 0, padTrailing: 16, padBottom: 0, padLeading: 16)
        imageView.setDimension(wConst: 68, hConst: 68)
        getButton.setDimension(wConst: 80, hConst: 32)
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
                
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            let translationY: CGFloat = scrollView.contentOffset.y < 100 || (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) ? 175 : -175
            let transformation = CGAffineTransform(translationX: 0, y: translationY)
            self.floatingContainerView.transform = transformation
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
        
        return UITableView.automaticDimension
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ExpandedVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
