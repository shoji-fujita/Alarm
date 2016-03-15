//
//  DateItem.swift
//  Aram
//
//  Created by kikin on 2016/02/29.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

class DateItem : Hashable {
    
    var year : Int = 1970
    var month : Int = 1
    var day : Int = 1
    
    var hashValue: Int {
        return NSDate.create(self.year, month: self.month, day: self.day)!.hashValue
    }
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    init() {
        
    }
}

func ==(lhs: DateItem, rhs: DateItem) -> Bool {
    return NSDate.create(lhs.year, month: lhs.month, day: lhs.day)!.hashValue ==
        NSDate.create(rhs.year, month: rhs.month, day: rhs.day)!.hashValue
}
