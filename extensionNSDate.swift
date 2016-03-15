//
//  extensionNSDate.swift
//  Aram
//
//  Created by kikin on 2016/02/17.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

extension NSDate {
    
    // Date型を文字列型に変換する
    // formatは"yyyy-MM-dd"や"HH:mm"などを指定する
    func dateToStringWithFormat(format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let timeString = formatter.stringFromDate(self)
        return timeString
    }
}
