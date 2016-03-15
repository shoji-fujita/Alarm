//
//  AddorEditAlertViewController.swift
//  Aram
//
//  Created by kikin on 2016/02/17.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import UIKit

enum EditMode {
    case Add
    case Edit
}

class AlarmItemEditViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var editMode:EditMode!
    var cellLabelArray = ["繰り返し","ラベル","サウンド","スヌーズ"]
    
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var optionListTableView: UITableView!
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        optionListTableView.dataSource = self
        optionListTableView.delegate = self
    }
    
    // スヌーズのスイッチが切り替わったとき
    @IBAction func valueChangeSnoozeSwitch(sender: UISwitch) {
        print(sender.on)
    }
    
    // 画面が表示される直前
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        switch self.editMode! {
        
        // アラートを追加する画面のとき
        case .Add:
            
            // タイトルを設定する
            self.title = "アラームを追加"
            
        // アラートを編集する画面のとき
        case .Edit:
            
            // タイトルを設定する
            self.title = "アラームを編集"
        }
        
        // DatePickerに値を設定する
        self.alarmDatePicker.date = AlarmItemManager.sharedInstance.alarmItemTemp.time.toDate()
        
        // tableViewを更新する
        self.optionListTableView.reloadData()
    }

    // alarmDatePickerの値が変わったとき
    @IBAction func valueChangeDatePicker(sender: UIDatePicker) {
        
        // alarmDatePickerの値からhourとminuteを取得する
        let calendar = NSCalendar.currentCalendar()
        let comps: NSDateComponents = calendar.components([NSCalendarUnit.Hour,NSCalendarUnit.Minute], fromDate: sender.date)
        
        // alarmItemTempの内容を更新する
        AlarmItemManager.sharedInstance.alarmItemTemp.time = TimeItem(hour: comps.hour, minute: comps.minute)
    }
    
    // 保存ボタンを押したとき
    @IBAction func pushSaveButton(sender: UIBarButtonItem) {
    
        // alarmItemを管理する配列を更新する
        switch self.editMode! {
        case .Add:
            
            // alarmItemArrayを更新する
            AlarmItemManager.sharedInstance.alarmItemArray.append(AlarmItemManager.sharedInstance.alarmItemTemp)
            
        case .Edit:
            let index = AlarmItemManager.sharedInstance.getIndexOfAlarmItemArrayWithAlarmItem(AlarmItemManager.sharedInstance.alarmItemTemp)
            print("index - " + index.description)
            print("uid - " + AlarmItemManager.sharedInstance.alarmItemTemp.uid.description)
            // alarmItemArrayを更新する
            AlarmItemManager.sharedInstance.alarmItemArray[index] = AlarmItemManager.sharedInstance.alarmItemTemp
        }
        
        // 通知を全削除する
        LocalNotificationManager.cancelAllLocalNotifications()
        
        // 通知を全登録する
        LocalNotificationManager.scheduleLocalNotificationFromAlarmItemArray(AlarmItemManager.sharedInstance.alarmItemArray)
        
        // データを保存する
        AlarmItemManager.save(AlarmItemManager.sharedInstance.alarmItemArray)
        
        // 画面を閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // キャンセルボタンを押したとき
    @IBAction func pushCancelButton(sender: UIButton) {
        
        // 画面を閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // tableViewのセクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var sectionCount = 0
        
        switch self.editMode! {
        case .Add:
            sectionCount = 1
        case .Edit:
            sectionCount = 2
        }
        
        return sectionCount
    }
    
    // tableViewのセル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var cellCount = 0
        
        switch section {
        case 0:
            cellCount = self.cellLabelArray.count
        case 1:
            cellCount = 1
        default:
            break
        }
            
        return cellCount
    }
    
    // tableViewのセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row != 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("OptionCell", forIndexPath: indexPath)
                cell.textLabel?.text = self.cellLabelArray[indexPath.row]
                cell.detailTextLabel?.text = AlarmItemManager.alarmItemToStringArray(AlarmItemManager.sharedInstance.alarmItemTemp)[indexPath.row]
                return cell
            } else {
                // スヌーズ用のセル
                let cell = tableView.dequeueReusableCellWithIdentifier("SnoozeCell", forIndexPath: indexPath)
                
                let snoozeLabel = cell.viewWithTag(1) as! UILabel
                snoozeLabel.text = self.cellLabelArray[indexPath.row]
                
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DeleteAlarmCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    // tableViewのセルを押したとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // オプションを編集するセルを押したとき
        if indexPath.section == 0 {
            if indexPath.row != 3 {
                // 遷移先のStoryboard IDを記述
                let storyboardIdArray = ["RepeatEditViewController","LabelEditViewController","SoundEditViewController"]
            
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardIdArray[indexPath.row])
                self.navigationController?.pushViewController(controller!, animated: true)
            
                // 選択されたセルの色を戻す
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                // 何もしない
            }
            
        // アラームを削除するセルを押したとき
        } else if indexPath.section == 1 {
            
            // alarmItemを管理する配列からalarmItemを削除する
            AlarmItemManager.sharedInstance.deleteAlarmItemForAlarmItemArray(AlarmItemManager.sharedInstance.alarmItemTemp)
            
            // 画面を閉じる
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

