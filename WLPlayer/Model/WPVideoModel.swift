//
//  WPVideoModel.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/15.
//  Copyright © 2019 Willie. All rights reserved.
//

import WCDBSwift

struct WPVideoModel: WCDBSwift.TableCodable {
    
    // for db
    var isAutoIncrement: Bool = true
    var dbID: Int?
    
    var name: String
    var url: URL
    var localPath: String
    var downloadedTime: String?
    var duration: TimeInterval?
    var coverPath: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WPVideoModel
        
        case dbID
        case name
        case url
        case localPath
        case downloadedTime
        case duration
        case coverPath
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .dbID: ColumnConstraintBinding(isPrimary: true),
                .name: ColumnConstraintBinding(isUnique: true),
            ]
        }
    }
    
    init?(url: URL) {
        if isValid(url: url) {
            self.name = url.lastPathComponent.components(separatedBy: ".").first!
            self.url = url
            self.localPath = WPVideosDirectoryPath + "/" + self.name + ".mp4"
        } else {
            return nil
        }
    }
}

// MARK: - private

private func isValid(url: URL) -> Bool {
    let ext = url.pathExtension
    if ext == "m3u8" ||
        ext == "mp4" {
        return true
    } else {
        return false
    }
}
