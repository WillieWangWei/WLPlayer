//
//  WPDownloaderManager.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/15.
//  Copyright © 2019 Willie. All rights reserved.
//

import AVFoundation

class WPDownloaderManager: NSObject {
    
    private var currentModel: WPVideoModel?
    private var generator: WLAssetImageGenerator?
    
    static let shared = WPDownloaderManager()
}

// MARK: - public

extension WPDownloaderManager {
    
    func run() {
        initFFmpeg()
        addNotifObserver()
    }
}

// MARK: - LogDelegate

extension WPDownloaderManager: LogDelegate {
    
    func logCallback(_ level: Int32, _ message: String!) {
        WPLog.verbose(message!)
    }
}

// MARK: - private

private extension WPDownloaderManager {
    
    func initFFmpeg() {
        MobileFFmpegConfig.setLogDelegate(WPDownloader)
    }
    
    func addNotifObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onNotif(notif:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc func onNotif(notif: NSNotification) {
        switch notif.name {
        case UIApplication.didBecomeActiveNotification:
            
//            UIPasteboard.general.string = "https://video.twimg.com/ext_tw_video/1129597911954857984/pu/pl/8Sno30suDjAIHLNI.m3u8?tag=9"
//            UIPasteboard.general.string = "https://video.twimg.com/ext_tw_video/1128129173610844161/pu/pl/w5uy7Xo0QjeGj2WL.m3u8?tag=9"
            
            guard let string = UIPasteboard.general.string, let url = URL(string: string) else {
                WPHUD.error("URL为空")
                return
            }
            
            guard let model = WPVideoModel(url: url) else {
                WPHUD.error("创建model失败: \(url)")
                return
            }
            
            do {
                let isExists = try WPVideoDB.isExists(name: model.name)
                if isExists {
                    WPHUD.info("已下载此文件: \(model.name)")
                    return
                }
            } catch {
                WPHUD.error("查找文件失败: \(model.name), \(error.localizedDescription)")
                return
            }
            
            currentModel = model
            download()
            
        default:
            break
        }
    }
    
    func download() {
        
        if FileManager.default.fileExists(atPath: currentModel!.fileUrl.absoluteString) {
            do {
                try FileManager.default.removeItem(at: currentModel!.fileUrl)
            } catch {
                WPHUD.error("删除原有文件失败: \(currentModel!.name), \(error.localizedDescription)")
                return
            }
        }
        
        guard let command = getCommand() else {
            WPHUD.info("生成下载命令失败: \(currentModel!.name)")
            return
        }
        
        WPHUD.info("开始下载: \(currentModel!.name)")
        
        DispatchQueue.global().async {
            
            WPLog.debug("执行下载命令: \(command)")
            let result = MobileFFmpeg.execute(command)
            WPLog.debug("执行下载命令结束: \(result)")
            
            DispatchQueue.main.async {
                
                if result == RETURN_CODE_SUCCESS {
                    
                    WPLog.debug("下载成功: \(self.currentModel!.name)")
                    self.getDownloadedTime()
                    self.getDuration()
                    self.getCover(completion: {
                        do {
                            try WPVideoDB.insert(model: self.currentModel!)
                            WPHUD.succesee("写入数据库成功: \(self.currentModel!.name)")
                            WLUserNotificationCenter.current.postNotification(
                                title: "下载成功", body: "文件下载成功: \(self.currentModel!.name)")
                            NotificationCenter.default.post(name: WPVideoDidDownloadedNotification,
                                                            object: self.currentModel!)
                        } catch {
                            WPHUD.error("写入数据库失败: \(self.currentModel!.name), \(error.localizedDescription)")
                        }
                    })
                    
                } else if result == RETURN_CODE_SUCCESS {
                    WPHUD.error("下载取消: \(self.currentModel!.name)")
                } else {
                    WPHUD.error("下载失败: \(self.currentModel!.name)")
                }
            }
        }
    }
    
    func getCommand() -> String? {
        if currentModel == nil { return nil }
        let command = "-i \(currentModel!.url.absoluteString) \(currentModel!.fileUrl.absoluteString)"
        return command
    }
    
    func getDownloadedTime() {
        if currentModel == nil { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        let string = dateFormatter.string(from: Date())
        currentModel!.downloadedTime = string
    }
    
    func getDuration() {
        if currentModel == nil { return }
        let asset = AVAsset(url: currentModel!.fileUrl)
        let duration = CMTimeGetSeconds(asset.duration)
        currentModel!.duration = duration
    }
    
    func getCover(completion: @escaping () -> ()) {
        if currentModel == nil { return }
        
        let FPS: Int = 10
        let timeScale: CMTimeScale = 600
        let imageDuration: TimeInterval = 3
        let asset = AVAsset(url: currentModel!.fileUrl)
        let videoDuration = CMTimeGetSeconds(asset.duration)
        let begin: TimeInterval = (currentModel?.duration)! * 0.5 - imageDuration / 2
        let count = FPS * Int(imageDuration) / 2
        var times = [NSValue]()
        
        for i in 0..<count {
            let value = begin + TimeInterval(i) * (1.0 / TimeInterval(FPS))
            if value >= videoDuration {
                continue
            }
            times.append(NSValue(time: CMTime(value: CMTimeValue(value * Double(timeScale)), timescale: timeScale)))
        }
        
        generator?.cancel()
        generator = WLAssetImageGenerator(with: asset)
        generator?.asyncGenerateImages(at: times, appendReverse: false, completion: { (images) in
            
            let encoder = YYImageEncoder(type: .webP)
            encoder?.loopCount = 0
            images.forEach { encoder?.add($0, duration: 1 / TimeInterval(FPS)) }
            let data = encoder?.encode()
            let path = WPCoversDirectoryPath + "/\(self.currentModel!.name).webp"
            do {
                try data?.write(to: URL(fileURLWithPath: path))
                self.currentModel!.coverUrl = URL(fileURLWithPath: path)
                completion()
            } catch {
                WPLog.error(error.localizedDescription)
            }
        })
    }
}
