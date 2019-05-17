//
//  WPVideoInfoCell.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/17.
//  Copyright © 2019 Willie. All rights reserved.
//

import UIKit

class WPVideoInfoCell: WLTableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var downloadedTimeLabel: UILabel!
    
    override func attach(data: WLTableViewCellData) -> CGFloat {
        super.attach(data: data)
        
        guard let model = data.entity as? WPVideoModel else { return 20 }
        nameLabel.text = model.name
        
        return 100
    }
    
    override func selected(by tableView: WLTableView, atIndexPath IndexPath: IndexPath) {
        delegate?.onEvent(info: [
            "event": "selected",
            "entity": self.data!.entity,
            ])
    }
}
