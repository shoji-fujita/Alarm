//
//  SoundEditViewController.swift
//  Aram
//
//  Created by kikin on 2016/02/23.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import UIKit
import MediaPlayer

class SoundEditViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate {
    
    @IBOutlet var soundTableView: UITableView!
    var player: MPMusicPlayerController!
    var musicList: Array<MPMediaItem> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.soundTableView.dataSource = self
        self.soundTableView.delegate = self
        
        player = MPMusicPlayerController.applicationMusicPlayer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 曲を停止する
        self.player.stop()
    }
    
    // tableViewのセクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // tableViewのセクション名
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "効果音"
        } else {
            return "曲"
        }
    }
    
    // tableViewのセル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var cellCount = 0
        
        if section == 0 {
            cellCount = SoundItemManager.sharedInstance.soundInfo["name"]!.count
        } else {
            cellCount = 1 + self.musicList.count
        }
        
        return cellCount
    }
    
    // tableViewのセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("SoundNameCell", forIndexPath: indexPath)
            cell.textLabel?.text = SoundItemManager.sharedInstance.soundInfo["name"]![indexPath.row]
            
            if SoundItemManager.sharedInstance.soundInfo["name"]![indexPath.row] == AlarmItemManager.sharedInstance.alarmItemTemp.soundItem.name {
                cell.accessoryType = .Checkmark
            }

        } else {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("SelectMusicCell", forIndexPath: indexPath)
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("SoundNameCell", forIndexPath: indexPath)
                cell.textLabel?.text = self.musicList[indexPath.row-1].valueForProperty(MPMediaItemPropertyTitle) as? String
            }
        }
        
        return cell
    }
    
    // tableViewのセルが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // チェックマークを全て外す
        // indexPath.section = 0 のとき
        for i in 0..<SoundItemManager.sharedInstance.soundInfo["name"]!.count {
            let indexPath: NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
            if let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
        // indexPath.section = 1 のとき
        for i in 1..<1 + self.musicList.count {
            let indexPath: NSIndexPath = NSIndexPath(forRow: i, inSection: 1)
            if let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
        
        if indexPath.section == 0 {

            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .Checkmark
            }
            
            // alarmItemに設定する
            AlarmItemManager.sharedInstance.alarmItemTemp.soundItem.name = SoundItemManager.sharedInstance.soundInfo["name"]![indexPath.row]
            AlarmItemManager.sharedInstance.alarmItemTemp.soundItem.path = SoundItemManager.sharedInstance.soundInfo["path"]![indexPath.row]
            
        } else {
            if indexPath.row == 0 {
            
                // 曲が再生中なら
                if self.player.playbackState == .Playing {
            
                    // 曲を停止する
                    self.player.stop()
                }
        
                let picker = MPMediaPickerController()
        
                picker.delegate = self
                picker.allowsPickingMultipleItems = false
        
                // mediaPickerを表示する
                presentViewController(picker, animated: true, completion: nil)

            } else {
            
                self.player.play()
            
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    if cell.accessoryType == .None {
                        cell.accessoryType = .Checkmark
                        
                    } else {
                        cell.accessoryType = .None
                    }
                }
                
            }
        }
    
        // セルの選択を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //　mediaPickerで選択されたとき
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        // 選択した曲情報を取得する
        let mediaItem = mediaItemCollection.items[0]

        // 選択した曲情報をplayerに設定する
        self.player.setQueueWithItemCollection(mediaItemCollection)
        
        // 再生する
        self.player.play()
        
        // alarmItemに設定する
        AlarmItemManager.sharedInstance.alarmItemTemp.soundItem.name = mediaItem.valueForProperty(MPMediaItemPropertyTitle) as! String
        AlarmItemManager.sharedInstance.alarmItemTemp.soundItem.path = mediaItem.valueForProperty(MPMediaItemPropertyAssetURL)!.absoluteString
        
        // musicListに追加する
        musicList.append(mediaItem)
        
        // 画面を閉じる
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // mediaPickerがキャンセルされたとき
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        
        // 画面を閉じる
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
}
