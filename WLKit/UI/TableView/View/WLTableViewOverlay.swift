//
//  WLTableViewOverlay.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/23.
//  Copyright © 2019 Willie. All rights reserved.
//

class WLTableViewOverlay: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(60)
            make.centerX.equalTo(self)
            make.bottom.equalTo(titleLabel.snp_top).offset(-30)
        })
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
        })
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(30)
        })
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // for lazy var
        imageView.image = nil
        titleLabel.text = nil
        actionButton.setTitle(nil, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        WPLog.debug(self)
    }
}
