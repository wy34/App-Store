//
//  AppDetailController.swift
//  AppStore
//
//  Created by William Yeung on 3/29/21.
//

import UIKit

class AppDetailVC: UIViewController {
    // MARK: - Properties
    var app: FeedItem?
    
    // MARK: - Views
    
    // MARK: - Init
    init(app: FeedItem) {
        super.init(nibName: nil, bundle: nil)
        self.app = app
        navigationItem.title = app.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    // MARK: - Helper
}
