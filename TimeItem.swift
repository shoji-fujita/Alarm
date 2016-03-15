//
//  TimeItem.swift
//  Aram
//
//  Created by kikin on 2016/02/26.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

class TimeItem : NSObject, NSCoding {
    
    private(set) var uid : Int!
    var hour: Int = 0
    var minute: Int = 0
    
    override var hashValue: Int {
        return (hour.description + minute.description).hash
    }
    
    init(hour:Int, minute:Int) {
        self.hour = hour
        self.minute = minute
    }
    
    override init() {
        let now = NSDate()
        let nowCalendar = NSCalendar.currentCalendar()
        let nowComponents = nowCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday, NSCalendarUnit.Hour, NSCalendarUnit.Minute],
            fromDate: now)
        
        self.hour = nowComponents.hour
        self.minute = nowComponents.minute
    }
    
    // エンコードする
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.hour, forKey: "hour")
        aCoder.encodeInteger(self.minute, forKey: "minute")
    }
    
    // デコードする
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        self.hour = aDecoder.decodeIntegerForKey("hour")
        self.minute = aDecoder.decodeIntegerForKey("minute")
    }
    
    func toDate() -> NSDate {
    
        let now = NSDate()
        let nowCalendar = NSCalendar.currentCalendar()
        let nowComponents = nowCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday, NSCalendarUnit.Hour, NSCalendarUnit.Minute],
            fromDate: now)
        
        let date = NSDate.create(nowComponents.year, month: nowComponents.month, day: nowComponents.day, hour: self.hour, minute: self.minute, second: 0)
        return date!
    }
    
    func toString() -> String {

        var hourString = hour.description
        var minuteString = minute.description
        
        // 1桁のときは先頭0埋め
        if hourString.characters.count == 1 {
            hourString = "0" + hourString
        }
        if minuteString.characters.count == 1 {
            minuteString = "0" + minuteString
        }

        let timeString = hourString + ":" + minuteString
        
        return timeString
    }
}

func ==(lhs: TimeItem, rhs: TimeItem) -> Bool {
    return lhs.hour == rhs.hour && lhs.minute == rhs.minute
}

func <(lhs: TimeItem, rhs: TimeItem) -> Bool {
    var bool = false
    
    if lhs.hour < rhs.hour {
        bool = true
    } else if (lhs.hour == rhs.hour && lhs.minute < rhs.minute) {
        bool = true
    } else {
        bool = false
    }
    
    return bool
}

func >(lhs: TimeItem, rhs: TimeItem) -> Bool {
    var bool = false
    
    if lhs.hour > rhs.hour {
        bool = true
    } else if (lhs.hour == rhs.hour && lhs.minute > rhs.minute) {
        bool = true
    } else {
        bool = false
    }
    
    return bool
}
