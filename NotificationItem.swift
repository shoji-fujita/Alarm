//
//  NotificationItem.swift
//  Aram
//
//  Created by kikin on 2016/02/26.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

class NotificationItem : Hashable {
    
    var uid : Int!
    var date : NSDate!
    var name : String!
    var soundPath : String!
    
    var hashValue: Int {
        return uid
    }
}

func ==(lhs: NotificationItem, rhs: NotificationItem) -> Bool {
    return lhs.uid == rhs.uid
}
