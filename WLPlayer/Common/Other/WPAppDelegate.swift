//
//  WPAppDelegate.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/14.
//  Copyright © 2019 Willie. All rights reserved.
//

import Fabric
import Crashlytics

@UIApplicationMain
class WPAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupLog()
        setupFabric()
        setupWindow()
        
        return true
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        switch WPPlayer.orientation {
        case .portrait:
            return .portrait
        case .landscapeRight:
            return .landscapeRight
        default:
            return .portrait
        }
    }
}

private extension WPAppDelegate {
    
    func setupLog() {
        WPLog.run()
        WPLog.verbose(WPLog.fileURL().absoluteString)
    }
    
    func setupFabric() {
        Fabric.with([Crashlytics.self])
    }
    
    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = WPBaseNavigationController(rootViewController: WPMainTabBarController())
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
