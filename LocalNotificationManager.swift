//
//  LocalNotificationManager.swift
//  Aram
//
//  Created by kikin on 2016/02/19.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import UIKit
import EventKit

// 継承禁止
final class LocalNotificationManager {
    
    // initの呼び出し禁止
    private init() {
        
    }
    
    // シングルトンとして作成
    static let sharedInstance = LocalNotificationManager()
    
    // 全通知を消す
    class func cancelAllLocalNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    // 全通知を登録する
    class func scheduleLocalNotificationFromAlarmItemArray(alarmItemArray: Array<AlarmItem>) {
        
        var notificationItemListFinal: Array<NotificationItem> = []
        
        // alarmItemArray内のalarmItemをすべて通知に置き換える
        for alarmItem in alarmItemArray {
            
            // 通知オフのものは無視する
            if alarmItem.alarmOn == false {
                continue
            }
            let notificationItemList = self.getNotificationListFromAlarmItem(alarmItem)
            notificationItemListFinal = notificationItemListFinal + notificationItemList
        }
        
        // dateの大きい順に並び替え
        // 日付が遠いものから登録する
        notificationItemListFinal.sortInPlace({(lhs, rhs) in return lhs.date.hash > rhs.date.hash})
        
        for item in notificationItemListFinal {
            print("\(item.name) : \(item.date.description)")
        }
        
        // 一つずつ通知を登録していく
        for notificationItem in notificationItemListFinal {
            self.scheduleLocalNotificationFromDate(notificationItem.date, message: notificationItem.name, soundPath: notificationItem.soundPath, uid: notificationItem.uid)
        }

    }
    
    // 指定した日に通知する
    private class func scheduleLocalNotificationFromDate(date:NSDate, message:String, soundPath:String, uid:Int) {
        
        // カレンダーを西暦で取得する
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let comps: NSDateComponents = calendar!.components([NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second,NSCalendarUnit.Weekday], fromDate: date)
        comps.calendar = calendar
        comps.year = date.year
        comps.month = date.month
        comps.day = date.day
        comps.hour = date.hour
        comps.minute = date.minute
        comps.second = date.second
            
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.fireDate = comps.date
        notification.soundName = soundPath
        notification.repeatInterval = NSCalendarUnit.Day
        notification.userInfo = ["uid":uid]
            
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // 基準週からの経過日数を4週間分取得する
    class func dayAfterListFromBaseWeek(baseWeekday: Int, weekdays: Array<Int>, baseTimeItem: TimeItem, timeItem: TimeItem) -> Array<Int> {
        
        // 現在からの経過日数を格納する配列を宣言する
        var dayAfterList: Array<Int> = []
        
        // 繰り返しありのとき
        if weekdays.count != 0 {
            for weekday in weekdays {
                
                // 4週間分だけ取得する
                for i in 0...3 {
                    if baseWeekday == weekday {
                        
                        if baseTimeItem < timeItem {
                            // 今日を含む
                            dayAfterList.append((weekday - baseWeekday) + i*7)
                        } else {
                            // 今日を含まない
                            dayAfterList.append(((weekday + 7) - baseWeekday) + i*7)
                        }
                        
                    } else if baseWeekday < weekday {
                        dayAfterList.append((weekday - baseWeekday) + i*7)
                    } else {
                        dayAfterList.append(((weekday + 7) - baseWeekday) + i*7)
                    }
                }
            }
        
        // 繰り返しなしのとき
        } else {
            print("baseTimeItem - " + baseTimeItem.hour.description)
            print("timeItem - " + timeItem.hour.description)
            
            if baseTimeItem < timeItem {
                // 今日を含む（0日後にアラームセット）
                dayAfterList.append(0)
            } else {
                // 今日を含まない（1日後にアラームセット）
                dayAfterList.append(1)
            }
        }
        
        dayAfterList = dayAfterList.sort()
        
        return dayAfterList
    }
    
    // dayAfterListから通知リストを作成する
    class func dayAfterListToDateList(dayAfterList: Array<Int>, alarmItem: AlarmItem) -> Array<NotificationItem> {
        var notificationList: Array<NotificationItem> = []
        
        jump : for index in 0..<dayAfterList.count {
            let now = NSDate()
            
            let dayAfterWithCurrentDay = now.dateByAddingTimeInterval(60 * 60 * 24 * Double(dayAfterList[index]))
            let date = NSDate.create(dayAfterWithCurrentDay.year, month: dayAfterWithCurrentDay.month, day: dayAfterWithCurrentDay.day, hour: alarmItem.time.hour, minute: alarmItem.time.minute, second: 0)
            
            // 祝日を除く場合はここで処理する
            if alarmItem.notHolidayOn {
                let holidayInfo = HolidayItemManager.sharedInstance.holidayInfo
                for holidayItem in holidayInfo {
                    
                    if holidayItem.dateItem == DateItem(year: date!.year, month: date!.month, day: date!.day) {
                        continue jump
                    }
                }
            }
            
            let notificationItem = NotificationItem()
            notificationItem.uid = alarmItem.uid + index/100
            notificationItem.name = alarmItem.name
            notificationItem.soundPath = alarmItem.soundItem.path
            notificationItem.date = date
            
            notificationList.append(notificationItem)
        }
        
        return notificationList
    }
    
    // alarmItemから通知リストを作成する
    class func getNotificationListFromAlarmItem(alarmItem: AlarmItem) -> Array<NotificationItem> {
        
        // 現在時刻を取得
        let now = NSDate()
        let nowCalendar = NSCalendar.currentCalendar()
        let nowComponents = nowCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday, NSCalendarUnit.Hour, NSCalendarUnit.Minute],
            fromDate: now)
        print("nowComponents.weekday - \(nowComponents.weekday-1)")
        
        let weekdays = AlarmItemManager.getWeekdaysFromAlarmItem(alarmItem)
        print("weekdays - \(weekdays)")
        
        // 何日後かのリスト
        let dayAfterList = self.dayAfterListFromBaseWeek(nowComponents.weekday-1, weekdays: weekdays, baseTimeItem: TimeItem(hour: nowComponents.hour, minute: nowComponents.minute), timeItem: alarmItem.time)
        print("dayAfterList - \(dayAfterList)")
        
        // 通知のリスト
        let notificationList = self.dayAfterListToDateList(dayAfterList, alarmItem: alarmItem)
        print("notificationList - \(notificationList)")
        
        return notificationList
    }

    /*
    // alarmItemを通知に登録する
    func registerLocalNotification(alarmItem: AlarmItem) {
        
        let hour = alarmItem.time.hour
        let minute = alarmItem.time.minute
        let second = 0
        let weekday = 2
        let message = alarmItem.name
        let soundPath = alarmItem.soundItem.path
        let uid = alarmItem.uid
        
        self.playSoundWithHour(hour, minute: minute, second: second, weekday: weekday, message: message, soundPath: soundPath, uid: uid)
    }
    
    // alarmItemの通知を解除する
    func rescissionLocalNotification(alarmItem: AlarmItem) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            // 通知に登録されているキーで検索
            if notification.userInfo!["uid"]!.integerValue == alarmItem.uid {
                // キーが一致したら、対象の通知を削除
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }

    // 指定した曜日の時間に音を鳴らす
    func playSoundWithHour(hour:Int, minute:Int, second:Int, weekday:Int, message:String, soundPath:String, uid:Int) {
        let now = NSDate()
        
        // バージョンが8.0以上なら
        if #available(iOS 8.0, *) {
            
            // カレンダーを西暦で取得する
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
            
            let comps: NSDateComponents = calendar!.components([NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second,NSCalendarUnit.Weekday], fromDate: now)
            comps.calendar = calendar
            comps.hour = hour
            comps.minute = minute
            comps.second = second
            comps.weekday = weekday
            
            let notification = UILocalNotification()
            notification.alertBody = message
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.fireDate = comps.date
            notification.soundName = soundPath
            notification.repeatInterval = NSCalendarUnit.Day
            notification.userInfo = ["uid":uid]
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }

    // n分後に音を鳴らす
    func playSoundAfterWithMinute(minute: Double, message:String) {
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: minute * 60);
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = message
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification);
    }

    // dateListの中身を通知用Listに置き換える
    func dateListToNotificationList(dateList: Array<NSDate>, alarmItem: AlarmItem) -> Array<NotificationItem> {
        var notificationList: Array<NotificationItem> = []
        
        for index in 0..<dateList.count {
            let notificationItem = NotificationItem()
            
            notificationItem.uid = alarmItem.uid + index
            notificationItem.name = alarmItem.name
            notificationItem.soundPath = alarmItem.soundItem.path
            notificationItem.date = dateList[index]
            
            notificationList.append(notificationItem)
        }
        return notificationList
    }
    */
}

