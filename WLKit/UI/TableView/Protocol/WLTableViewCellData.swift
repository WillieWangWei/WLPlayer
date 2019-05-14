//
//  WLTableViewCellData.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/19.
//  Copyright © 2019 Willie. All rights reserved.
//

struct WLTableViewCellData {
    
    var entity: Any
    var className: String
    var addtion: [String: Any]?
    var rowHeight: CGFloat = 0
    var isTemp: Bool = false
    
    init(entity: Any, className: String, addtion: [String: Any]? = nil) {
        self.entity = entity
        self.className = className
        self.addtion = addtion
    }
    
    static func dataArrayWith(entities: [Any], className: String, addtion: [String: Any]? = nil)
        -> [WLTableViewCellData] {
        return entities.map { WLTableViewCellData(entity: $0, className: className, addtion: addtion) }
    }
}
