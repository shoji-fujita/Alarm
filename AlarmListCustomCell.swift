//
//  AlarmListCustomCell.swift
//  Aram
//
//  Created by kikin on 2016/02/24.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import UIKit

class AlarmListCustomCell : UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.editing == true {
            alarmSwitch.alpha = 0.0
        } else {
            alarmSwitch.alpha = 1.0
        }
    }
}
