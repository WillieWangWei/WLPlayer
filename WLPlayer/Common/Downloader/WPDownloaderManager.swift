//
//  WPDownloaderManager.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/15.
//  Copyright © 2019 Willie. All rights reserved.
//

class WPDownloaderManager: NSObject {
    
    private var currentModel: WPVideoModel?
    
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
            
            UIPasteboard.general.string = "https://video.twimg.com/ext_tw_video/1128129173610844161/pu/pl/w5uy7Xo0QjeGj2WL.m3u8?tag=9"
            
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
        
        guard var model = currentModel else {
            WPHUD.error("需要下载的model数据异常")
            return
        }
        
        guard let command = getCommand() else {
            WPHUD.error("生成下载命令失败: \(model.name)")
            return
        }
        
        let filePath = model.localPath
        
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                WPHUD.error("删除原有文件失败: \(model.name), \(error.localizedDescription)")
                return
            }
        }
        
        WPHUD.info("执行下载命令: \(command)")
        
        DispatchQueue.global().async {
            
            let result = MobileFFmpeg.execute(command)
            WPHUD.info("执行下载命令结束: \(result)")
            
            DispatchQueue.main.async {
                
                if result == RETURN_CODE_SUCCESS {
                    
                    WPHUD.succesee("下载成功: \(model.name)")
                    do {
                        model.downloadedTime = self.getCurrentTime()
                        try WPVideoDB.insert(model: model)
                        WPHUD.succesee("写入数据库成功: \(model.name)")
                    } catch {
                        WPHUD.error("写入数据库失败: \(model.name), \(error.localizedDescription)")
                    }
                    
                } else if result == RETURN_CODE_SUCCESS {
                    WPHUD.error("下载取消: \(model.name)")
                } else {
                    WPHUD.error("下载失败: \(model.name)")
                }
            }
        }
    }
    
    func getCommand() -> String? {
        guard let model = currentModel else { return nil }
        let command = "-i \(model.url.absoluteString) \(model.localPath)"
        return command
    }
    
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let string = dateFormatter.string(from: Date())
        return string
    }
}
