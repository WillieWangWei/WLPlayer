//
//  WPVideoDBManager.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/16.
//  Copyright © 2019 Willie. All rights reserved.
//

import WCDBSwift

class WPVideoDBManager: NSObject {
    
    private let tableName = "WPVideoModel"
    private var database: Database?
    
    static let shared = WPVideoDBManager()
    
    override init() {
        let path = WPDatabasesDirectoryPath + "/video.db"
        database = Database(withPath: path)
        do {
            let isExists = try database?.isTableExists(tableName)
            if isExists == true { return }
            try database?.create(table: tableName, of: WPVideoModel.self)
        } catch {
            WPHUD.error("数据库创建表失败 \(error.localizedDescription)")
        }
    }
}

// MARK: - public

extension WPVideoDBManager {
    
    func insert(model: WPVideoModel) throws {
        try database?.insert(objects: model, intoTable: tableName)
    }
    
    func isExists(name: String) throws -> Bool {
        let object: WPVideoModel? = try database?.getObject(fromTable: tableName,
                                                            where: WPVideoModel.Properties.name == name)
        if object == nil {
            return false
        } else {
            return true
        }
    }
    
    func getAllVideo() throws -> [WPVideoModel]? {
        let videos: [WPVideoModel]? = try database?.getObjects(fromTable: tableName)
        return videos
    }
    
    func closeDB() {
        database?.close()
    }
}

// MARK: - private

private extension WPVideoDBManager {
    
    
}
