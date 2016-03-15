//
//  AlarmManager.swift
//  Aram
//
//  Created by kikin on 2016/02/17.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation
import MediaPlayer

// 継承禁止
final class AlarmItemManager {
    
    var alarmItemArray: Array<AlarmItem> = []
    var alarmItemTemp: AlarmItem!
    
    // initの呼び出し禁止
    private init() {
        let filePath =  AlarmItemManager.getFilePathWithFileName("alarmItemArray")
        
        if NSFileManager().fileExistsAtPath(filePath) {
           self.alarmItemArray = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as! Array<AlarmItem>
        } else {
           self.setTestDate()
        }
    }
    
    // データ管理用のファイルパスを取得する
    class func getFilePathWithFileName(fileName: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask, true)
        let documentsPath = paths[0]
        let filePath = documentsPath + "/" + fileName
        
        return filePath
    }
    
    // シングルトンとして作成
    static let sharedInstance = AlarmItemManager()
    
    // データを保存する
    class func save(alarmItemArray: Array<AlarmItem>) {
        
        let filePath = self.getFilePathWithFileName("alarmItemArray")
        let result = NSKeyedArchiver.archiveRootObject(alarmItemArray, toFile: filePath)
        if result {
            print("データの保存に成功しました")
        }
    }
    
    // テスト用
    func setTestDate() {
        let alarmItem_1 = AlarmItem(uid: 1)
        
        alarmItem_1.time = TimeItem(hour: 11, minute: 11)
        alarmItem_1.name = "アラーム_01"
        alarmItem_1.repeatItem.bools = [false,false,false,false,false,false,false]
        alarmItem_1.alarmOn = false
        
        let alarmItem_2 = AlarmItem(uid: 2)
        
        alarmItem_2.time = TimeItem(hour: 12, minute: 20)
        alarmItem_2.name = "アラーム_02"
        alarmItem_2.repeatItem.bools = [true,false,false,false,false,false,true]
        alarmItem_2.alarmOn = false
        
        alarmItemArray = [alarmItem_1, alarmItem_2]
    }
    
    // 一覧を取得する
    func getAlarmItemArray() -> Array<AlarmItem>? {
        return self.alarmItemArray
    }
    
    // alarmItemを新規作成する
    func newAlarmItem() -> AlarmItem {
        let newUid = self.getNewUid()
        let newAlarmItem = AlarmItem(uid: newUid)
        
        return newAlarmItem
    }
    
    // alarmItemがalarmItemArrayの何番目に存在するかを求めて取得する
    func getIndexOfAlarmItemArrayWithAlarmItem(alarmItem: AlarmItem) -> Int! {
        for index in 0..<self.alarmItemArray.count {
            let item = self.alarmItemArray[index]
            if item.uid == alarmItem.uid {
                return index
            }
        }
        return nil
    }
    
    // alarmItem.uidがalarmItemArrayの何番目に存在するかを求めて取得する
    func getIndexOfAlarmItemArrayWithAlarmItemUid(uid: Int) -> Int! {
        for index in 0..<self.alarmItemArray.count {
            let item = self.alarmItemArray[index]
            if item.uid == uid {
                return index
            }
        }
        return nil
    }
    
    // alarmItemArrayからalarmItemを削除する
    func deleteAlarmItemForAlarmItemArray(alarmItem: AlarmItem) {
        let index = self.getIndexOfAlarmItemArrayWithAlarmItem(alarmItem)
        self.alarmItemArray.removeAtIndex(index)
    }
    
    // 新しいalarmItemに割り当てるuidを作成して取得する
    private func getNewUid() -> Int {
        var maxUid : Int = 0
        for index in 0..<self.alarmItemArray.count {
            let item = self.alarmItemArray[index]
            if item.uid > maxUid {
                maxUid = item.uid
            }
        }
        let newUid = maxUid + 1
        return newUid
    }
    
    // alarmItemの中身を文字型の配列に変換する
    class func alarmItemToStringArray(alarmItem: AlarmItem) -> Array<String> {
        return [self.repeatToString(alarmItem.repeatItem, notHolidayOn:alarmItem.notHolidayOn),alarmItem.name, alarmItem.soundItem.name]
    }
    
    // repeatの文字列を取得する
    class func repeatToString(repeatItem: RepeatItem, notHolidayOn:Bool) -> String {
        
        // 文字列に変換する
        var repeatString = ""
        let bools = repeatItem.bools
        
        if bools == [false,false,false,false,false,false,false] {
            repeatString = "なし"
        } else if bools == [true,true,true,true,true,true,true] {
            repeatString = "毎日"
        } else if bools == [false,true,true,true,true,true,false] {
            repeatString = "平日"
        } else if bools == [true,false,false,false,false,false,true] {
            repeatString = "土 日"
        } else {
            var repeatArray: Array<String> = []
            
            for index in 0..<bools.count {
                if bools[index] == true {
                    repeatArray.append(repeatItem.shortStrings[index])
                }
            }
            repeatString = repeatArray.joinWithSeparator(" ")
        }
        
        if notHolidayOn == true {
            repeatString = repeatString + "(祝日を除く)"
        }
    
        return repeatString
    }
    
    // alarmItemから有効なweekdayの配列を取得する
    class func getWeekdaysFromAlarmItem(alarmItem: AlarmItem) -> Array<Int> {
        
        // 有効なweekdayを格納する配列を宣言する
        var weekdays : Array<Int> = []
        
        let weekBools = alarmItem.repeatItem.bools
        for weekIndex in 0..<weekBools.count {
            if weekBools[weekIndex] == true {
                weekdays.append(weekIndex)
            }
        }
        return weekdays
    }
}

