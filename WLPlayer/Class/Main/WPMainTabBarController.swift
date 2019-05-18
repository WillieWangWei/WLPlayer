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
        
        DispatchQueue.main.async {
            self.present(WPLaunchViewController(), animated: false)
        }
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
        tabBar.barTintColor = .WPPrimaryColor
        delegate = self
    }
    
    func initViewContollers() {
        
        let vc1 = WPHomeViewController()
        vc1.tabBarItem = UITabBarItem(title: "文件",
                                      image: #imageLiteral(resourceName: "sideslip_collect").withRenderingMode(.alwaysOriginal),
                                      selectedImage: #imageLiteral(resourceName: "videoRoom_comment_collect").withRenderingMode(.alwaysOriginal))
        vc1.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            ], for: .normal)
        
        let vc2 = WPDownloadViewController()
        vc2.tabBarItem = UITabBarItem(title: "下载",
                                      image: #imageLiteral(resourceName: "videoRoom_comment_unfavour").withRenderingMode(.alwaysOriginal),
                                      selectedImage: #imageLiteral(resourceName: "videoRoom_comment_favour").withRenderingMode(.alwaysOriginal))
        vc2.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            ], for: .normal)
        setViewControllers([vc1, vc2], animated: false)
        
        navigationItem.title = vc1.tabBarItem.title
    }
}
