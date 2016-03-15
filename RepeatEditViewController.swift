//
//  RepeatEditViewController.swift
//  Aram
//
//  Created by kikin on 2016/02/18.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import UIKit

class RepeatEditViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    // switchの値が変わったとき
    @IBAction func valueChangeHolidaySwitch(sender: UISwitch) {
        
        let cell = sender.superview?.superview as! UITableViewCell
        
        // 操作中のswitchのindexPathを取得する
        if let indexPath = self.tableView.indexPathForCell(cell) {
            if indexPath == NSIndexPath(forRow: 0, inSection: 1) {
                AlarmItemManager.sharedInstance.alarmItemTemp.notHolidayOn = sender.on
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // tableViewのセクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // tableViewのセクション名
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "曜日"
        } else {
            return "その他"
        }
    }
    
    // tableViewのセル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var cellCount = 0
        
        switch section {
        case 0:
            cellCount = AlarmItemManager.sharedInstance.alarmItemTemp.repeatItem.longStrings.count
        default:
            cellCount = 1
        }
        
        return cellCount
    }
    
    // tableViewのセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("WeekCell", forIndexPath: indexPath)
            cell.textLabel?.text = AlarmItemManager.sharedInstance.alarmItemTemp.repeatItem.longStrings[indexPath.row]
            
            if AlarmItemManager.sharedInstance.alarmItemTemp.repeatItem.bools[indexPath.row] == true {
                cell.accessoryType = .Checkmark
            }
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("HolidayCell", forIndexPath: indexPath)
            let holidaySwitch = cell.viewWithTag(1) as! UISwitch
            holidaySwitch.on = AlarmItemManager.sharedInstance.alarmItemTemp.notHolidayOn
        }

        return cell;
    }
    
    // tableViewのセルを選択したとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
      
        switch indexPath.section {
        case 0:
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
                // チェックマークがなければ
                if cell.accessoryType == .None {
                    // チェックマークをつける
                    cell.accessoryType = .Checkmark
                
                    AlarmItemManager.sharedInstance.alarmItemTemp.repeatItem.bools[indexPath.row] = true

                } else {
                    // チェックマークをはずす
                    cell.accessoryType = .None
                
                    AlarmItemManager.sharedInstance.alarmItemTemp.repeatItem.bools[indexPath.row] = false
                }
            }
        default:
            break
        }
    }
}
