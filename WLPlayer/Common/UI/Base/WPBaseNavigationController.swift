//
//  WPBaseNavigationController.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/23.
//  Copyright © 2019 Willie. All rights reserved.
//

class WPBaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        setupLeftButton(for: viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension WPBaseNavigationController {
    
    func setupUI() {
        navigationBar.barTintColor = UIColor.WPPrimaryColor
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setupLeftButton(for viewController: UIViewController) {
        if children.count > 0 {
            if viewController.navigationItem.leftBarButtonItem == nil {
                viewController.navigationItem.leftBarButtonItem =
                    UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back").withRenderingMode(.alwaysOriginal),
                                    style: .plain,
                                    target: self,
                                    action: #selector(onPop))
            }
        }
    }
    
    @objc func onPop() {
        popViewController(animated: true)
    }
}
