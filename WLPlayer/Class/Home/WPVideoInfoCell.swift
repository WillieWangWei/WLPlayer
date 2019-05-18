//
//  WPVideoInfoCell.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/17.
//  Copyright © 2019 Willie. All rights reserved.
//

import UIKit
import YYWebImage

class WPVideoInfoCell: WLTableViewCell {
    
    @IBOutlet weak var coverImageView: YYAnimatedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var downloadedTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImageView.layer.cornerRadius = 5
        coverImageView.layer.masksToBounds = true
    }
    
    override func attach(data: WLTableViewCellData) -> CGFloat {
        super.attach(data: data)
        
        guard let model = data.entity as? WPVideoModel else { return 20 }
        coverImageView.yy_setImage(with: model.coverUrl)
        nameLabel.text = model.name
        let minutesString = String(format: "%02d", Int(model.duration! / 60))
        durationLabel.text = "\(minutesString):\(Int(model.duration!.truncatingRemainder(dividingBy: 60)))"
        downloadedTimeLabel.text = model.downloadedTime
        
        return 100
    }
    
    override func selected(by tableView: WLTableView, atIndexPath IndexPath: IndexPath) {
        delegate?.onEvent(info: [
            "event": "selected",
            "entity": self.data!.entity,
            ])
    }
}
