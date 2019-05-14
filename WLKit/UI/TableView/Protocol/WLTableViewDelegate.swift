//
//  WLTableViewDelegate.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/23.
//  Copyright © 2019 Willie. All rights reserved.
//

protocol WLTableViewDelegate: class {
    
    func needLoadNewData(in tableView: WLTableView, completion: @escaping () -> Void)
    
    func needLoadMoreData(in tableView: WLTableView,  completion: @escaping () -> Void)
}
