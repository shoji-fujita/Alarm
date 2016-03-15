//
//  SoundItem.swift
//  Aram
//
//  Created by kikin on 2016/02/24.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

class SoundItem : NSObject, NSCoding {
    
    var name : String = "sound01"
    var path : String = "sound01.caf"
    
    override var hashValue: Int {
        return self.path.hashValue
    }
    
    override init() {
        super.init()
    }
    
    // エンコードする
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.path, forKey: "path")
    }
    
    // デコードする
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.path = aDecoder.decodeObjectForKey("path") as! String
    }
}

func ==(lhs: SoundItem, rhs: SoundItem) -> Bool {
    return lhs.path == rhs.path
}
