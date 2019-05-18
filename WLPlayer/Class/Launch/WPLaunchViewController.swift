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
            make.trailing.bottom.equalTo(view)
            make.width.height.equalTo(40)
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGR.numberOfTapsRequired = 4
        touchView.addGestureRecognizer(tapGR)
    }
    
    @objc func onTap() {
        dismiss(animated: true)
    }
}