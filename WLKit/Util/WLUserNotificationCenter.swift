//
//  WLUserNotificationCenter.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/19.
//  Copyright © 2019 Willie. All rights reserved.
//

import UserNotifications

class WLUserNotificationCenter: NSObject {
    
    static let current = WLUserNotificationCenter()
}

// MARK: - public

extension WLUserNotificationCenter {
    
    func run() {
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound]) { (result, error) in
                    WPLog.debug("推送授权结果: \(result)")
                    if let error = error {
                        WPHUD.error(error.localizedDescription)
                    }
                }
            case .authorized:
                break
            case .denied:
                break
            case .provisional:
                break
            default:
                break
            }
        }
        
        center.delegate = self
    }
    
    func postNotification(title: String, body: String) {
        
        WPLog.info("发起推送: title: \(title), body: \(body)")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "测试", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                WPLog.error(error.localizedDescription)
            }
        }
    }
}

extension WLUserNotificationCenter: UNUserNotificationCenterDelegate {
  
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void) {
        completionHandler([.alert, .sound])
    }
}
