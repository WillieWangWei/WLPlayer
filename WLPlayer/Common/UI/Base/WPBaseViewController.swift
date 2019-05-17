//
//  WPBaseViewController.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/21.
//  Copyright © 2019 Willie. All rights reserved.
//

class WPBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    deinit {
        WPLog.verbose("deinit \(self)")
    }
}
