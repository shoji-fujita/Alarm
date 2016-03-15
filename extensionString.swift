//
//  extensionString.swift
//  Aram
//
//  Created by kikin on 2016/02/17.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

extension String {

    // 文字列をDate型に変換する
    // formatは"yyyy-MM-dd"や"HH:mm"などを指定する
    func stringToDateWithFormat(format:String) -> NSDate! {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
   //     formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        let date = formatter.dateFromString(self)
        
        return date
    }
}
