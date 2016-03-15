//
//  HolidayItem.swift
//  Aram
//
//  Created by kikin on 2016/02/16.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

class HolidayItem : Hashable {
    
    var dateItem : DateItem = DateItem()
    var name : String!
    
    var hashValue: Int {
        return self.dateItem.hashValue
    }
}
    
func ==(lhs: HolidayItem, rhs: HolidayItem) -> Bool {
    return lhs.dateItem == rhs.dateItem
}
