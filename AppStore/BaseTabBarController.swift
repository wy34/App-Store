//
//  ViewController.swift
//  AppStore
//
//  Created by William Yeung on 3/25/21.
//

import UIKit

class BaseTabBarController: UIViewController {
    // MARK: - Views
    var baseTabBarController = UITabBarController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseTabBarController()
    }

    // MARK: - Helpers
    func configureBaseTabBarController() {
        let todayVC = createNavigationControllerTab(withTitle: "Today", iconName: "newspaper", tag: 0, viewController: UIViewController())
        let appsVC = createNavigationControllerTab(withTitle: "Apps", iconName: "square.stack.3d.up.fill", tag: 1, viewController: UIViewController())
        let searchVC = createNavigationControllerTab(withTitle: "Search", iconName: "magnifyingglass", tag: 2, viewController: UIViewController())
        baseTabBarController.viewControllers = [todayVC, appsVC, searchVC]
        
        view.addSubview(baseTabBarController.view)
    }
    
    func createNavigationControllerTab(withTitle title: String, iconName: String, tag: Int, viewController: UIViewController) -> UINavigationController {
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: iconName), tag: tag)
        return navigationController
    }
}

