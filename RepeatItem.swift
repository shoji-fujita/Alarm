//
//  RepeatItem.swift
//  Aram
//
//  Created by kikin on 2016/02/29.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

class RepeatItem : NSObject, NSCoding {
    
    var shortStrings : Array<String> = ["日","月","火","水","木","金","土"]
    var longStrings : Array<String> = ["毎日曜日","毎月曜日","毎火曜日","毎水曜日","毎木曜日","毎金曜日","毎土曜日"]
    var bools : Array<Bool> = [false,false,false,false,false,false,false]
    
    override var hashValue: Int {
        return self.shortStrings.description.hashValue
    }
    
    // エンコードする
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.shortStrings, forKey: "shortStrings")
        aCoder.encodeObject(self.longStrings, forKey: "longStrings")
        aCoder.encodeObject(self.bools, forKey: "bools")
    }
    
    // デコードする
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        self.shortStrings = aDecoder.decodeObjectForKey("shortStrings") as! Array<String>
        self.longStrings = aDecoder.decodeObjectForKey("longStrings") as! Array<String>
        self.bools = aDecoder.decodeObjectForKey("bools") as! Array<Bool>
    }
    
    override init() {
        super.init()
    }
}

func ==(lhs: RepeatItem, rhs: RepeatItem) -> Bool {
    return lhs.shortStrings == rhs.shortStrings
}
