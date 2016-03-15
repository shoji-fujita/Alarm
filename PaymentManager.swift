//
//  PaymentManager.swift
//  Aram
//
//  Created by kikin on 2016/03/04.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

// 継承禁止
final class PaymentManager {
    
    // initの呼び出し禁止
    private init() {
    
    }
    
    // シングルトンとして作成
    static let sharedInstance = PaymentManager()

}
