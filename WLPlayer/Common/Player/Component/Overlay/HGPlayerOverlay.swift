//
//  WPPlayerOverlay.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/22.
//  Copyright © 2019 Willie. All rights reserved.
//

import AVFoundation

class WPPlayerOverlay: UIView {
    
    private let cellReuseID = "WPRecommendCell"
    
    private lazy var recommendView: UIView = {
        let view = UIView()
        view.isHidden = true
        addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        isHidden = true
        initColletionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        WPLog.debug(self)
    }
}

extension WPPlayerOverlay: WPPlayerComponent {
    
    func register(toPlayer player: AVPlayer, contentView: UIView) {
        for view in contentView.subviews {
            if view is WPPlayerControlPanel {
                let controlPanel = view as! WPPlayerControlPanel
                controlPanel.insertSubview(self, at: 0)
                self.snp.makeConstraints { (make) in
                    make.edges.equalTo(controlPanel)
                }
                break
            }
        }
    }
    
    func unregister() {
        self.removeFromSuperview()
    }
    
    func player(_ player: WPPlayerManager, rateDidChangedTo rate: Float) {
        if rate == 0 {
            isHidden = false
            recommendView.isHidden = false
        } else if rate == 1 {
            isHidden = true
            recommendView.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension WPPlayerOverlay: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath)
        cell.backgroundColor = UIColor.wl_randomColor
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension WPPlayerOverlay: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        WPPlayer.clear()
        WPPlayer.url = URL(string: "http://mediacdn.mengliaoba.cn/fanchang/mv/2019/4-1/54/9833154-22434830-1554108305.mp4")
    }
}

private extension WPPlayerOverlay {
    
    func initColletionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 220, height: 180)
        flowLayout.minimumInteritemSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        collection.register(.init(nibName: cellReuseID, bundle: .main), forCellWithReuseIdentifier: cellReuseID)
        collection.dataSource = self
        collection.delegate = self
        recommendView.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(recommendView)
            make.height.equalTo(180)
            make.centerY.equalTo(recommendView).offset(10)
        }
        collection.reloadData()
    }
}
