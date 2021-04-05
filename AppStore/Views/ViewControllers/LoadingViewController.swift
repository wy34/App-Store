//
//  LoadingViewController.swift
//  AppStore
//
//  Created by William Yeung on 3/29/21.
//

import UIKit

class LoadingViewController: UIViewController {
    // MARK: - Views
    private let loadingContainerView = PlainView(bgColor: .white)
    
    private let activityIndicator: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.style = .large
        a.startAnimating()
        a.hidesWhenStopped = true
        return a
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    func showLoading() {
        view.addSubview(loadingContainerView)
        loadingContainerView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
        
        loadingContainerView.addSubview(activityIndicator)
        activityIndicator.center(x: loadingContainerView.centerXAnchor, y: loadingContainerView.centerYAnchor)
    }
    
    func dismissLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.loadingContainerView.removeFromSuperview()
        }
    }
}
