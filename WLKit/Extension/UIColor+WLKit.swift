//
//  UIColor+WLKit.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/19.
//  Copyright © 2019 Willie. All rights reserved.
//

extension UIColor {
    
    convenience init(hex: Int) {
        let a = CGFloat(((hex & 0xff000000) >> 24)) / CGFloat(255.0)
        let r = CGFloat(((hex & 0x00ff0000) >> 16)) / CGFloat(255.0)
        let g = CGFloat(((hex & 0x0000ff00) >>  8)) / CGFloat(255.0)
        let b = CGFloat(((hex & 0x000000ff) >>  0)) / CGFloat(255.0)
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    class var wl_randomColor: UIColor {
        get {
            let r = CGFloat(Int.random(in: 0...255)) / CGFloat(255.0)
            let g = CGFloat(Int.random(in: 0...255)) / CGFloat(255.0)
            let b = CGFloat(Int.random(in: 0...255)) / CGFloat(255.0)
            return .init(red: r, green: g, blue: b, alpha: 1)
        }
    }
}
