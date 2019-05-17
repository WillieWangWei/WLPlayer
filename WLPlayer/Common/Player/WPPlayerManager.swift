//
//  WPPlayerManager.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/21.
//  Copyright © 2019 Willie. All rights reserved.
//

import Foundation
import AVFoundation

class WPPlayerManager: NSObject {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var contentView: UIView?
    private var components: [WPPlayerComponent] = [WPPlayerComponent]()
    
    private let playerItemKeyPathForObserver = [
        #keyPath(AVPlayerItem.status),
        #keyPath(AVPlayerItem.isPlaybackBufferEmpty),
    ]
    private var playerContext = 0
    private var playerItemContext = 0
    private var timeObserverToken: Any?
    
    static let shared = WPPlayerManager()
    var orientation: UIInterfaceOrientation = .portrait
    
    override init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            WPHUD.error(error.localizedDescription)
        }
    }
    
    var url: URL? {
        didSet {
            if let url = url {
                let playerItem = AVPlayerItem(url: url)
                if player == nil {
                    initPlayer(withItem: playerItem)
                    initcomponents()
                } else {
                    player?.replaceCurrentItem(with: playerItem)
                }
            } else {
                player?.replaceCurrentItem(with: nil)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        switch context {
            
        case &playerItemContext:
            
            let item = object as! AVPlayerItem
            
            switch keyPath {
                
            case #keyPath(AVPlayerItem.status):
                
                let status: AVPlayerItem.Status
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                components.forEach { $0.player(self,
                                               itemStatusDidChangedTo: status) }

            case #keyPath(AVPlayerItem.isPlaybackBufferEmpty):
                components.forEach { $0.player(self,
                                               itemIsPlaybackBufferEmptyDidChangedTo: item.isPlaybackBufferEmpty) }
                
            default:
                break
            }
            
        case &playerContext:
            
            if keyPath == #keyPath(AVPlayer.rate) {
                
                if let rate = change?[.newKey] as? Float {
                    components.forEach { $0.player(self, rateDidChangedTo: rate) }
                }
            }
            
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        WPLog.verbose("deinit \(self)")
    }
}

// MARK: - public

extension WPPlayerManager {
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func isPlaying() -> Bool {
        return player?.rate == 1
    }
    
    func seek(to value: Double, completionHandler: @escaping (Bool) -> Void) {
        guard let duration = player?.currentItem?.duration else { return }
        let totalDuration = Double(CMTimeGetSeconds(duration))
        player?.seek(to: CMTime(seconds: totalDuration * value, preferredTimescale: CMTimeScale(USEC_PER_SEC)),
                     completionHandler: completionHandler)
    }
    
    func landscapeRight() {
        changeOrientation(to: .landscapeRight)
    }
    
    func portrait() {
        changeOrientation(to: .portrait)
    }
    
    func clear() {
        removeObservers()
        deinitcomponents()
        player?.replaceCurrentItem(with: nil)
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
    }
}

// MARK: - private

private extension WPPlayerManager {
    
    func initPlayer(withItem item: AVPlayerItem) {
        player = AVPlayer(playerItem: item)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        playerLayer?.frame = contentView?.superview?.bounds ?? .zero
        contentView = contentView ?? UIView()
        contentView?.layer.insertSublayer(playerLayer!, at: 0)
        addObservers()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidPlayToEndTime(notif:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        playerItemKeyPathForObserver.forEach {
            player?.currentItem?.addObserver(self, forKeyPath: $0, options: .new, context: &playerItemContext)
        }
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: &playerContext)
        
        let time = CMTime(seconds: 1, preferredTimescale: CMTimeScale(USEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { (time) in
            self.components.forEach { $0.player(self, timeDidChangedTo: time) }
        })
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                  object: player?.currentItem)
        playerItemKeyPathForObserver.forEach {
            player?.currentItem?.removeObserver(self, forKeyPath: $0, context: &playerItemContext)
        }
        player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate), context: &playerContext)
        
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func initcomponents() {
        components.append(contentsOf: [
            WPPlayerControlPanel.instanceFromNib(),
//            WPPlayerOverlay(),
            ])
        components.forEach { $0.register(toPlayer: player!, contentView: contentView!) }
    }
    
    func deinitcomponents() {
        components.forEach { $0.unregister() }
        components.removeAll()
    }
    
    func changeOrientation(to orientation: UIInterfaceOrientation) {
        
        guard let contentView = contentView else { return }
        
        self.orientation = orientation
        let value = orientation.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        if orientation == .landscapeRight {
            UIApplication.shared.keyWindow?.addSubview(contentView)
            contentView.snp.remakeConstraints { (make) in
                make.edges.equalTo(contentView.superview!)
            }
            playerLayer?.frame = contentView.superview!.bounds
            
        } else if orientation == .portrait {
            contentView.removeFromSuperview()
        }
    }
    
    @objc func playerItemDidPlayToEndTime(notif: Notification) {
        components.forEach { $0.player(self, itemDidPlayToEndTime: notif.object as! AVPlayerItem) }
    }
}
