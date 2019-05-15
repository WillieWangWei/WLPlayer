//
//  SwiftyBeaver+WP.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/20.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftyBeaver

extension SwiftyBeaver {
    
    enum RollTime {
        case day
        case week
        case month
    }
    
    static var timeLimit: RollTime = .week
    static var sizeLimit: Double = 50
    
    class func run() {
        initLogCore()
        checkTimeLimit()
        cketSizeLimit()
    }
    
    class func fileURL() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd"
        let fileName = "\(dateFormatter.string(from: Date())).log"
        return URL(fileURLWithPath: WPLogsDirectoryPath).appendingPathComponent(fileName)
    }
    
    class func totalSize() -> Double {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: WPLogsDirectoryPath) {
            return 0
        }
        
        var size: Double = 0
        let enumerator = fileManager.enumerator(atPath: WPLogsDirectoryPath)
        while let fileName = enumerator?.nextObject() as? String {
            let filePath = WPLogsDirectoryPath + "/\(fileName)"
            do {
                try size += fileManager.attributesOfItem(atPath: filePath)[.size] as! Double
            } catch {
                WPLog.error(error)
            }
        }
        return size / 1024 / 1024
    }
}

private extension SwiftyBeaver {
    
    class func initLogCore() {
        
        let log = SwiftyBeaver.self
        
        let console = ConsoleDestination()
        log.addDestination(console)
        
        let file = FileDestination()
        file.logFileURL = fileURL()
        log.addDestination(file)
    }
    
    class func checkTimeLimit() {
        
        var timeLimitValue: TimeInterval = 0
        switch timeLimit {
        case .day:
            timeLimitValue = 60 * 60 * 24
        case .week:
            timeLimitValue = 60 * 60 * 24 * 7
        case .month:
            timeLimitValue = 60 * 60 * 24 * 7 * 30
        }
        let deprecatedTS = Date().timeIntervalSince1970 - timeLimitValue
        
        do {
            let fileManager = FileManager.default
            let contents = try fileManager.contentsOfDirectory(atPath: WPLogsDirectoryPath)
            for fileName in contents {
                let filePath = WPLogsDirectoryPath + "/\(fileName)"
                let attributes = try fileManager.attributesOfItem(atPath: filePath)
                let creationTS = (attributes[.creationDate] as! Date).timeIntervalSince1970
                if creationTS <= deprecatedTS {
                    try fileManager.removeItem(atPath: filePath)
                }
            }
        } catch {
            WPLog.error(error)
        }
    }
    
    class func cketSizeLimit() {
        while totalSize() > sizeLimit {
            do {
                let fileManager = FileManager.default
                let fileName = try fileManager.contentsOfDirectory(atPath: WPLogsDirectoryPath)
                try fileManager.removeItem(atPath: WPLogsDirectoryPath + "/\(fileName)")
            } catch {
                WPLog.error(error)
            }
        }
    }
}
