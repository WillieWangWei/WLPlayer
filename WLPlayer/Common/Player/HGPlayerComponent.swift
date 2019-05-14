//
//  WPPlayerComponent.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/22.
//  Copyright © 2019 Willie. All rights reserved.
//

import AVFoundation

protocol WPPlayerComponent {
    
    func register(toPlayer player: AVPlayer, contentView: UIView)
    
    func unregister()
    
    func player(_ player: WPPlayerManager, itemStatusDidChangedTo status: AVPlayerItem.Status)
    
    func player(_ player: WPPlayerManager, itemIsPlaybackBufferEmptyDidChangedTo isEmpty: Bool)
    
    func player(_ player: WPPlayerManager, itemDidPlayToEndTime item: AVPlayerItem)
    
    func player(_ player: WPPlayerManager, rateDidChangedTo rate: Float)
    
    func player(_ player: WPPlayerManager, timeDidChangedTo time: CMTime)
}

extension WPPlayerComponent {
    func player(_ player: WPPlayerManager, itemStatusDidChangedTo status: AVPlayerItem.Status) {}
    func player(_ player: WPPlayerManager, itemIsPlaybackBufferEmptyDidChangedTo isEmpty: Bool) {}
    func player(_ player: WPPlayerManager, itemDidPlayToEndTime item: AVPlayerItem) {}
    func player(_ player: WPPlayerManager, rateDidChangedTo rate: Float) {}
    func player(_ player: WPPlayerManager, timeDidChangedTo time: CMTime) {}
}
