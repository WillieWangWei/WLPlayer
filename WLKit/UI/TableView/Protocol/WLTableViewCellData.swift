//
//  WLTableViewCellData.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/4/19.
//  Copyright © 2019 Willie. All rights reserved.
//

struct WLTableViewCellData {
    
    // data
    var entity: Any
    var className: String
    var editingStyle: UITableViewCell.EditingStyle = .none
    var addtion: [String: Any]?
    
    // for layout
    var rowHeight: CGFloat = 0
    var isTemp: Bool = false
    
    init(entity: Any, className: String, editingStyle: UITableViewCell.EditingStyle? = .none, addtion: [String: Any]? = nil) {
        self.entity = entity
        self.className = className
        self.editingStyle = editingStyle ?? .none
        self.addtion = addtion
    }
    
    static func dataArrayWith(entities: [Any],
                              className: String,
                              editingStyle: UITableViewCell.EditingStyle? = .none,
                              addtion: [String: Any]? = nil) -> [WLTableViewCellData] {
        return entities.map { WLTableViewCellData(entity: $0,
                                                  className: className,
                                                  editingStyle: editingStyle,
                                                  addtion: addtion) }
    }
}
