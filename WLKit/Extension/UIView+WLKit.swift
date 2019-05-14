//
//  UIView+WLKit.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/21.
//  Copyright © 2019 Willie. All rights reserved.
//

extension UIView {
    
    var wl_top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    var wl_leading: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    var wl_bottom: CGFloat {
        get {
            return wl_top + wl_height
        }
        set {
            wl_top = newValue - wl_height
        }
    }
    
    var wl_trailing: CGFloat {
        get {
            return wl_leading + wl_width
        }
        set {
            wl_leading = newValue - wl_width
        }
    }
    
    var wl_width: CGFloat {
        get {
            return wl_size.width
        }
        set {
            wl_size.width = newValue
        }
    }
    
    var wl_height: CGFloat {
        get {
            return wl_size.height
        }
        set {
            wl_size.height = newValue
        }
    }
    
    var wl_centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    var wl_centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
    
    var wl_size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
}
