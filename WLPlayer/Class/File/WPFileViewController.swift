//
//  WPHomeViewController.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/14.
//  Copyright © 2019 Willie. All rights reserved.
//

import UIKit

class WPFileViewController: UIViewController {
    
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
        fetchVideos()
        addObserver()
    }
}

// MARK: - WLUIEventDelegate

extension WPFileViewController: WLUIEventDelegate {
    
    func onEvent(info: [String : Any]) {
        
        let event = info["event"] as! String
        let entity = info["entity"]
        
        switch event {
        case "select":
            guard let model = entity as? WPVideoModel else { return }
            WPPlayer.url = model.fileUrl
            WPPlayer.landscapeRight()
        case "edit":
            guard let model = entity as? WPVideoModel else { return }
            do {
                try WPVideoDBManager.shared.delete(model: model)
                fetchVideos()
            } catch {
                WPHUD.error("删除失败: \(model.name)")
            }
        default:
            break
        }
    }
}

// MARK: - WLTableViewDelegate

extension WPFileViewController: WLTableViewDelegate {
    
    func needLoadNewData(in tableView: WLTableView, completion: @escaping () -> Void) {
        fetchVideos()
    }
    
    func needLoadMoreData(in tableView: WLTableView, completion: @escaping () -> Void) {
        
    }
}

// MARK: - prviate

private extension WPFileViewController {
    
    func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func fetchVideos() {
        do {
            guard let videos: [WPVideoModel] = try WPVideoDB.getAllVideo() else {
                WPHUD.error("无本地视频")
                return
            }
            tableView.sourceData = WLTableViewCellData.dataArrayWith(entities: videos,
                                                                     className: "WPVideoInfoCell",
                                                                     editingStyle: .delete)
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        } catch {
            WPHUD.error("读取本地视频数据库失败: \(error.localizedDescription)")
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onNotif(notif:)),
                                               name: WPVideoDidDownloadedNotification,
                                               object: nil)
    }
    
    @objc func onNotif(notif: Notification) {
        switch notif.name {
        case WPVideoDidDownloadedNotification:
            fetchVideos()
        default:
            break
        }
    }
}
