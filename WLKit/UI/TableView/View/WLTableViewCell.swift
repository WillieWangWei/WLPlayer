//
//  WLTableViewCell.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/19.
//  Copyright © 2019 Willie. All rights reserved.
//

class WLTableViewCell: UITableViewCell {

    private(set) var data: WLTableViewCellData?
    weak var delegate: WLUIEventDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectionStyle = .none
    }
    
    @discardableResult
    func attach(data: WLTableViewCellData) -> CGFloat {
        self.data = data
        return wl_height
    }
    
    func selected(by tableView: WLTableView, atIndexPath IndexPath: IndexPath) {}
}
