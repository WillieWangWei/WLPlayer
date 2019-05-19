//
//  WPLaunchViewController.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/18.
//  Copyright © 2019 Willie. All rights reserved.
//

import UIKit

class WPLaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .wl_randomColor
        
        let touchView = UIView()
        touchView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        view.addSubview(touchView)
        touchView.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(view)
            make.width.height.equalTo(100)
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGR.numberOfTapsRequired = 2
        touchView.addGestureRecognizer(tapGR)
    }
    
    @objc func onTap() {
        dismiss(animated: true)
    }
}
