//
//  WPConst.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/19.
//  Copyright © 2019 Willie. All rights reserved.
//

import SnapKit
import SwiftyBeaver

let SCREEN_BOUNDS = UIScreen.main.bounds
let SCREEN_WIDTH = SCREEN_BOUNDS.width
let SCREEN_HEIGHT = SCREEN_BOUNDS.height
let SCREEN_SCALE = UIScreen.main.scale
let SCREEN_RATIO = SCREEN_WIDTH / CGFloat(375)
let STATUSBAR_HEIGHT = CGFloat(IS_FULL_SCREEN ? 44 : 20)
let NAVIGATIONBAR_HEIGHT = CGFloat(44)
let STATUSBAR_PLUS_NAVIGATIONBAR_HEIGHT = STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT
let TABBAR_UNSAFE_HEIGHT = CGFloat(IS_FULL_SCREEN ? 34 : 0)
let TABBAR_HEIGHT = CGFloat(49 + TABBAR_UNSAFE_HEIGHT)
let WPLog: SwiftyBeaver.Type = SwiftyBeaver.self
let WPPlayer = WPPlayerManager.default

var IS_FULL_SCREEN: Bool {
    if #available(iOS 11, *) {
        if let window = UIApplication.shared.delegate?.window, let w = window {
            if w.safeAreaInsets.top > 0 {
                return true
            }
        }
    }
    return false
}
