//
//  WPAppDelegate.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/14.
//  Copyright © 2019 Willie. All rights reserved.
//

import Fabric
import Crashlytics
import AVFoundation

@UIApplicationMain
class WPAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var player: AVPlayer?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupLog()
        setupFabric()
        setupUI()
        setupDownloader()
        setupPlayer()
        
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        WPVideoDB.closeDB()
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
    
    func setupUI() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = WPBaseNavigationController(rootViewController: WPMainTabBarController())
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.setMaximumDismissTimeInterval(4)
    }
    
    func setupDownloader() {
        WPDownloader.run()
    }
    
    func setupPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            WPHUD.error("播放器初始化失败: \(error.localizedDescription)")
            return
        }
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "10s", ofType: "mp3")!)
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.play()
    }
}
