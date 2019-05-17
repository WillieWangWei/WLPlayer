//
//  WPPlayerControlPanel.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/21.
//  Copyright © 2019 Willie. All rights reserved.
//

import AVFoundation

class WPPlayerControlPanel: UIView {
    
    @IBOutlet weak var replayButton: UIButton!
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var seekSlider: UISlider!
    
    private var sliderBusy: Bool = false
    private var isToolBarHidden: Bool = false
    private var currentWorkItem: DispatchWorkItem?
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.hidesWhenStopped = true
        indicator.isUserInteractionEnabled = false
        addSubview(indicator)
        indicator.snp.makeConstraints({ (make) in
            make.width.height.equalTo(50)
            make.center.equalTo(self)
        })
        return indicator
    }()
    
    private lazy var backControl: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(onBackControl), for: .touchUpInside)
        insertSubview(control, at: 0)
        control.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        return control
    }()
    
    @IBOutlet weak var topToolBar: UIView!
    @IBOutlet weak var bottomToolBar: UIView!
    
    weak var player: AVPlayer?
    
    class func instanceFromNib() -> WPPlayerControlPanel {
        return Bundle.main.loadNibNamed("WPPlayerControlPanel", owner: nil, options: nil)?.first as! WPPlayerControlPanel
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented, use WPPlayerControlView.instanceFromNib() instead")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sendSubviewToBack(backControl)
    }
   
    deinit {
        WPLog.verbose("deinit \(self)")
    }
}

// MARK: - WPPlayerComponent

extension WPPlayerControlPanel: WPPlayerComponent {
    
    func register(toPlayer player: AVPlayer, contentView: UIView) {
        self.player = player
        
        contentView.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.edges.equalTo(contentView)
        })
        
        delayHide(toolbars: [topToolBar, bottomToolBar])
    }
    
    func unregister() {
        currentWorkItem?.cancel()
        player = nil
        self.removeFromSuperview()
    }
    
    func player(_ player: WPPlayerManager, itemStatusDidChangedTo status: AVPlayerItem.Status) {
        
        switch status {
        case .readyToPlay:
            player.play()
        case .failed:
            WPLog.error("playerItemStatusDidChangedTo failed")
        case .unknown:
            WPLog.error("playerItemStatusDidChangedTo unknown")
        default:
            break
        }
    }
    
    func player(_ player: WPPlayerManager, itemIsPlaybackBufferEmptyDidChangedTo isEmpty: Bool) {
        if isEmpty {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
    func player(_ player: WPPlayerManager, itemDidPlayToEndTime item: AVPlayerItem) {
        replayButton.isHidden = false
        hide(toolbars: [bottomToolBar])
        show(toolbars: [topToolBar])
        currentWorkItem?.cancel()
        backControl.isEnabled = false
    }
    
    func player(_ player: WPPlayerManager, rateDidChangedTo rate: Float) {
        playButton.setTitle(rate == 0 ? "播放" : "暂停", for: .normal)
    }
    
    func player(_ player: WPPlayerManager, timeDidChangedTo time: CMTime) {
        
        let currentSeconds = CMTimeGetSeconds(time)
        var currentText = "00:00"
        if currentSeconds > 0 {
            currentText = String(format: "%02d:%02d", Int(currentSeconds) / 60, Int(currentSeconds) % 60)
        }
        let totalSeconds = CMTimeGetSeconds(self.player?.currentItem?.duration ?? .zero)
        var totalText = "00:00"
        if totalSeconds > 0 {
            totalText = String(format: "%02d:%02d", Int(totalSeconds) / 60, Int(totalSeconds) % 60)
        }
        timeLabel.text = currentText + "/" + totalText
        
        if !sliderBusy {
            seekSlider.value = Float(currentSeconds / totalSeconds)
        }
    }
}

// MARK: - private

private extension WPPlayerControlPanel {
    
    @objc func onBackControl() {
        if isToolBarHidden {
            show(toolbars: [topToolBar, bottomToolBar])
        } else {
            hide(toolbars: [topToolBar, bottomToolBar])
        }
    }
    
    func show(toolbars: [UIView]) {
        UIView.animate(withDuration: 0.2, animations: { toolbars.forEach { $0.alpha = 1 } })
        isToolBarHidden = false
        delayHide(toolbars: toolbars)
    }
    
    func hide(toolbars: [UIView]) {
        UIView.animate(withDuration: 0.2, animations: { toolbars.forEach { $0.alpha = 0 } })
        isToolBarHidden = true
    }
    
    func delayHide(toolbars: [UIView]) {
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { [weak self] in
            if WPPlayer.isPlaying() {
                self?.hide(toolbars: toolbars)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: currentWorkItem!)
    }
    
    @IBAction func onExitButton(_ sender: UIButton) {
        WPPlayer.portrait()
        WPPlayer.clear()
    }
    
    @IBAction func onReplayButton(_ sender: UIButton) {
        replayButton.isHidden = true
        show(toolbars: [topToolBar, bottomToolBar])
        backControl.isEnabled = true
        WPPlayer.seek(to: 0) { (result) in
            if result {
                WPPlayer.play()
            }
        }
    }
    
    @IBAction func onPlayButton(_ sender: UIButton) {
        if player?.rate == 0 {
            WPPlayer.play()
            delayHide(toolbars: [topToolBar, bottomToolBar])
        } else {
            WPPlayer.pause()
        }
    }
    
    @IBAction func sliderTouchDown(_ sender: UISlider) {
        currentWorkItem?.cancel()
        sliderBusy = true
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        WPPlayer.seek(to: Double(sender.value)) { (result) in
            if result {
                self.delayHide(toolbars: [self.topToolBar, self.bottomToolBar])
                self.sliderBusy = false
                WPPlayer.play()
            }
        }
    }
}
