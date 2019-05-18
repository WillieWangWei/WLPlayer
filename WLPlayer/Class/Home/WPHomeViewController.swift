//
//  WPHomeViewController.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/14.
//  Copyright © 2019 Willie. All rights reserved.
//

import UIKit

class WPHomeViewController: UIViewController {
    
    private lazy var tableView: WLTableView = {
        let tableView = WLTableView()
        tableView.cellDelegate = self
        tableView.tableViewDelegate = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchVideos()
    }
}

// MARK: - WLUIEventDelegate

extension WPHomeViewController: WLUIEventDelegate {
    
    func onEvent(info: [String : Any]) {
        
        let event = info["event"] as! String
        let entity = info["entity"]
        
        switch event {
        case "selected":
            guard let model = entity as? WPVideoModel else { return }
            WPPlayer.url = model.fileUrl
            WPPlayer.landscapeRight()
        default:
            break
        }
    }
}

// MARK: - WLTableViewDelegate

extension WPHomeViewController: WLTableViewDelegate {
    
    func needLoadNewData(in tableView: WLTableView, completion: @escaping () -> Void) {
        fetchVideos()
    }
    
    func needLoadMoreData(in tableView: WLTableView, completion: @escaping () -> Void) {
        
    }
}

// MARK: - prviate

private extension WPHomeViewController {
    
    func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func fetchVideos() {
        do {
            guard let videos: [WPVideoModel] = try WPVideoDB.getAllVideo() else {
                WPHUD.error("无本地视频")
                return
            }
            tableView.sourceData = WLTableViewCellData.dataArrayWith(entities: videos, className: "WPVideoInfoCell")
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        } catch {
            WPHUD.error("读取本地视频数据库失败: \(error.localizedDescription)")
        }
    }
}
