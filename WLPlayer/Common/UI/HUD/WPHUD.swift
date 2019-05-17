//
//  WPHUD.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/16.
//  Copyright © 2019 Willie. All rights reserved.
//

struct WPHUD {
    
    static func succesee(_ string: @autoclosure () -> String,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line) {
        WPLog.custom(level: .info, message: string(), file: file, function: function, line: line)
        SVProgressHUD.showSuccess(withStatus: string())
    }
    
    static func info(_ string: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        WPLog.custom(level: .debug, message: string(), file: file, function: function, line: line)
        SVProgressHUD.showInfo(withStatus: string())
    }
    
    static func error(_ string: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        WPLog.custom(level: .error, message: string(), file: file, function: function, line: line)
        SVProgressHUD.showError(withStatus: string())
    }
}
