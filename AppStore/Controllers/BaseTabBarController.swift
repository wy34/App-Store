//
//  BaseTabBarController.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class BaseTabBarController: UITabBarController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
    }

    // MARK: - Helpers
    fileprivate func configureTabBarController() {
        let todayVC = createNavigationController(withTitle: "Today", iconName: "newspaper.fill", tag: 0, viewController: UIViewController())
        let appsVC = createNavigationController(withTitle: "Apps", iconName: "square.stack.3d.up.fill", tag: 1, viewController: AppsVC())
        let appsSearchVC = createNavigationController(withTitle: "Search", iconName: "magnifyingglass", tag: 2, viewController: SearchVC())
        viewControllers = [appsVC, todayVC, appsSearchVC]
    }
    
    fileprivate func createNavigationController(withTitle title: String, iconName: String, tag: Int, viewController: UIViewController) -> UINavigationController {
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: iconName), tag: tag)
        return navigationController
    }
}

