//
//  HolidayManager.swift
//  Aram
//
//  Created by kikin on 2016/02/16.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

// 継承禁止
final class HolidayItemManager {
   
    var holidayInfo: Set<HolidayItem> = []
    
    // initの呼び出し禁止
    private init() {
        let fileText = self.readTextFromFileName("日付別祝日")
        holidayInfo = self.getHolidayInfo(fileText)!
    }
    
    // シングルトンとして作成
    static let sharedInstance = HolidayItemManager()
    
    // ファイル名から中のテキストを取得する
    private func readTextFromFileName(fileName: String) -> String {
        
        var fileText = ""
        
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "") {
            if let data = NSData(contentsOfFile: path) {
                
                fileText = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
            }
        }
        return fileText
    }
    
    // テキストからHolidayItemの集合を取得する
    private func getHolidayInfo(fileText:String) -> Set<HolidayItem>? {
        
        var lineArray:Array = fileText.componentsSeparatedByString("\n")
        
        // タイトル行は削除する
        lineArray.removeFirst()
        
        var holidayItems = Set<HolidayItem>()
        for lineText in lineArray {
            
            let lineElements = lineText.componentsSeparatedByString(",")
            if lineElements.count == 1 {
                break
            }
            
            let holidayItem = HolidayItem()
            
            let dateItem = DateItem()
            dateItem.year = lineElements[0].stringToDateWithFormat("yyyy-MM-dd").year
            dateItem.month = lineElements[0].stringToDateWithFormat("yyyy-MM-dd").month
            dateItem.day = lineElements[0].stringToDateWithFormat("yyyy-MM-dd").day
            
            holidayItem.dateItem = dateItem
            holidayItem.name = lineElements[1]
            
            holidayItems.insert(holidayItem)
        }
        
        return holidayItems
    }
}
