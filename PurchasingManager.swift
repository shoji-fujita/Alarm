//
//  PurchasingManager.swift
//  Aram
//
//  Created by kikin on 2016/03/03.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

// アプリ内課金を制御するクラス
// 継承禁止
final class PurchasingManager {
    
    // 広告解除
    var IsAdReleased : Bool = false
    
    // initの呼び出し禁止
    private init() {
        
    }
    
    // シングルトンとして作成
    static let sharedInstance = PurchasingManager()
}
