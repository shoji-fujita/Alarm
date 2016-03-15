//
//  File.swift
//  Aram
//
//  Created by kikin on 2016/03/09.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation

// 継承禁止
final class ProductItem {

    var adBool = false
    
    // initの呼び出し禁止
    private init() {
        
        // レシートがあるなら読み込み
        
    }
    
    // シングルトンとして作成
    static let sharedInstance = ProductItem()

}