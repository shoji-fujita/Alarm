//
//  AlertItem.swift
//  Aram
//
//  Created by kikin on 2016/02/16.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

class AlarmItem : NSObject, NSCoding {
    
    private(set) var uid : Int!
    var time : TimeItem = TimeItem()
    var name : String = "アラーム"
    var repeatItem : RepeatItem = RepeatItem()
    var notHolidayOn: Bool = false
    var alarmOn : Bool = true
    var soundItem : SoundItem = SoundItem()
    var snoozeOn : Bool = true
    
    override var hashValue: Int {
        return self.uid
    }

    init(uid: Int) {
        self.uid = uid
    }
    
    // エンコードする
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.uid, forKey: "uid")
        aCoder.encodeObject(self.time, forKey: "time")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.repeatItem, forKey: "repeatItem")
        aCoder.encodeBool(self.notHolidayOn, forKey: "notHolidayOn")
        aCoder.encodeBool(self.alarmOn, forKey: "alarmOn")
        aCoder.encodeObject(self.soundItem, forKey: "soundItem")
    }
    
    // デコードする
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        self.uid = aDecoder.decodeIntegerForKey("uid")
        self.time = aDecoder.decodeObjectForKey("time") as! TimeItem
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.repeatItem = aDecoder.decodeObjectForKey("repeatItem") as! RepeatItem
        self.notHolidayOn = aDecoder.decodeBoolForKey("notHolidayOn")
        self.alarmOn = aDecoder.decodeBoolForKey("alarmOn")
        self.soundItem = aDecoder.decodeObjectForKey("soundItem") as! SoundItem
    }
}

func ==(lhs: AlarmItem, rhs: AlarmItem) -> Bool {
    return lhs.uid == rhs.uid
}
