//
//  WPSandbox.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/20.
//  Copyright © 2019 Willie. All rights reserved.
//

import Foundation

// MARK: - system

/// .../Documents
var WPDocumentsDirectoryPath: String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

/// .../Library/Caches
var WPCachesDirectoryPath: String {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
}

// MARK: - log

/// .../Documents/WPLogs
var WPLogsDirectoryPath: String {
    let path = WPDocumentsDirectoryPath + "/WPLogs"
    return createDirectoryIfNeeded(atPath: path) ?? ""
}

// MARK: - private

private func createDirectoryIfNeeded(atPath path: String) -> String? {
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: path) {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            WPLog.error(error)
            return nil
        }
    }
    return path;
}
