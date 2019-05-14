//
//  WPMainTabBarController.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/19.
//  Copyright © 2019 Willie. All rights reserved.
//

class WPMainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        initViewContollers()
    }
}

extension WPMainTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        navigationItem.title = item.title
    }
}

private extension WPMainTabBarController {
    
    func setupUI() {
        tabBar.isTranslucent = false
        delegate = self
    }
    
    func initViewContollers() {
        let vc1 = WPHomeViewController()
        vc1.tabBarItem = UITabBarItem(title: "首页", image: #imageLiteral(resourceName: "public_weixin").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "videoRoom_comment_collect").withRenderingMode(.alwaysOriginal))
        vc1.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.WPPrimaryColor,
            ], for: .normal)
        setViewControllers([vc1], animated: false)
        navigationItem.title = vc1.tabBarItem.title
    }
}
