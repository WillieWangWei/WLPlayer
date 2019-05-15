//
//  WPHomeViewController.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/14.
//  Copyright © 2019 Willie. All rights reserved.
//

import UIKit

class WPHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - prviate

private extension WPHomeViewController {
    
    func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
