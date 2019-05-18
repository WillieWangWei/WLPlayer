//
//  WLTableView.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/19.
//  Copyright © 2019 Willie. All rights reserved.
//

class WLTableView: UITableView {
    
    private var loadMoreBusy: Bool = false
    
    var sourceData: [WLTableViewCellData] = [WLTableViewCellData]()
    weak var cellDelegate: WLUIEventDelegate?
    weak var tableViewDelegate: WLTableViewDelegate?
    
    var overlayImage: UIImage?
    var overlayTitle: String?
    var overlayActionText: String?
    var overlayActionHandler: (() -> Void)?
    lazy var overlay: WLTableViewOverlay = {
        let overlay = WLTableViewOverlay()
        return overlay
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    override func reloadData() {
        super.reloadData()
    }
    
    deinit {
        WPLog.verbose("deinit \(self)")
    }
}

// MARK: - UIScrollViewDelegate

extension WLTableView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if loadMoreBusy {
            return
        }
        
        if contentSize.height > bounds.size.height,
            contentOffset.y >= contentSize.height - bounds.size.height - SCREEN_HEIGHT {
            loadMoreBusy = true
            tableViewDelegate?.needLoadMoreData(in: self, completion: {
                self.loadMoreBusy = false
            })
        }
    }
}

// MARK: - UITableViewDataSource

extension WLTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sourceData.count == 0 {
            showOverlay()
        } else {
            hideOverlay()
        }
        return sourceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = sourceData[indexPath.row]
        let className = cellData.className
        var cell = tableView.dequeueReusableCell(withIdentifier: className)
        if cell == nil {
            cell = creatCellWith(className: className)
        }
        if let cell = cell as? WLTableViewCell {
            cell.wl_width = wl_width
            cell.delegate = cellDelegate
            let rowHeight = cell.attach(data: cellData)
            sourceData[indexPath.row].rowHeight = rowHeight
            return cell
        } else {
            return WLTableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension WLTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellData = sourceData[indexPath.row]
        if cellData.rowHeight == 0 {
            let tempCell = creatCellWith(className: cellData.className)
            var tempCellData =  WLTableViewCellData(entity: cellData.entity,
                                                    className: cellData.className,
                                                    addtion: cellData.addtion)
            tempCellData.isTemp = true
            let height = tempCell?.attach(data: tempCellData)
            cellData.rowHeight = height ?? 1
        }
        return cellData.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WLTableViewCell
        cell.selected(by: self, atIndexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - private

private extension WLTableView {
    
    func initSetup() {
        delegate = self;
        dataSource = self;
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        separatorStyle = .none
        estimatedRowHeight = 0
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }
    
    func showOverlay() {
        addSubview(overlay)
        overlay.frame = bounds
//        if WPReachability.isReachable {
//            overlay.imageView.image = overlayImage
//            overlay.titleLabel.text = overlayTitle
//            overlay.actionButton.setTitle(overlayActionText, for: .normal)
//            overlay.actionButton.addTarget(self, action: #selector(onOverlayActionButton), for: .touchUpInside)
//        } else {
//            overlay.imageView.image = #imageLiteral(resourceName: "search_empty")
//            overlay.titleLabel.text = "网络异常, 请重新加载"
//            overlay.actionButton.setTitle("重新加载", for: .normal)
//            overlay.actionButton.addTarget(self, action: #selector(onOverlayActionButton), for: .touchUpInside)
//        }
    }
    
    func hideOverlay() {
        overlay.removeFromSuperview()
    }
    
    @objc func onOverlayActionButton() {
        overlayActionHandler?()
    }
    
    @objc func onRefresh() {
        tableViewDelegate?.needLoadNewData(in: self, completion: {
            self.refreshControl?.endRefreshing()
        })
    }
    
    func creatCellWith(className: String) -> WLTableViewCell? {
        var cell: WLTableViewCell? = nil
        let nibPath = Bundle.main.path(forResource: className, ofType: "nib")
        if (nibPath?.count != 0) {
            cell = Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.first as? WLTableViewCell
        } else {
            let name = "WLPlayer.\(className)"
            let aClass = NSClassFromString(name) as! UITableViewCell.Type
            cell = aClass.init(style: .default, reuseIdentifier: className) as? WLTableViewCell
        }
        return cell
    }
}
