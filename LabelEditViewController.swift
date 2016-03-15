//
//  LabelEditViewController.swift
//  Aram
//
//  Created by kikin on 2016/02/18.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import UIKit

class LabelEditViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var labelTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.labelTableView.dataSource = self
        self.labelTableView.delegate = self
        
       // labelTextField.text = AlarmItemManager.sharedInstance.alarmItemTemp.name
    }
    
    // tableViewのセル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // tableViewのセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let labelTextField = cell.viewWithTag(1) as! UITextField
        labelTextField.text = AlarmItemManager.sharedInstance.alarmItemTemp.name
        labelTextField.delegate = self
        labelTextField.becomeFirstResponder()
        
        return cell
    }
    
    // TextFieldで編集し終わったとき
    func textFieldDidEndEditing(textField: UITextField) {
        AlarmItemManager.sharedInstance.alarmItemTemp.name = textField.text!
    }

    // Returnが押されたとき
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.navigationController?.popViewControllerAnimated(true)
        
        return true
    }

}