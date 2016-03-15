//
//  SoundItemManager.swift
//  Aram
//
//  Created by kikin on 2016/02/18.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation
import AudioToolbox

// 継承禁止
final class SoundItemManager {
    
    var soundInfo: Dictionary<String,Array<String>> = ["name":["sound01","sound02","sound03"],
                                            "path":["sound01.caf","sound02.caf","sound03.caf"]]
    
    // initの呼び出し禁止
    private init() {

    }
    
    // シングルトンとして作成
    static let sharedInstance = SoundItemManager()
    
    // 用意した音を鳴らす
    func playSound() {
        
        // SoundIDを格納する変数を作成
        var soundIdRing:SystemSoundID = 0
        
        // プロジェクトフォルダから音声ファイル(.mp3)を参照する
        let soundUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("SE1", ofType: "mp3")!)
        
        // 参照した音声ファイルからIDを作成
        AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
        
        // 作成したIDから音声を再生する
        AudioServicesPlaySystemSound(soundIdRing)
    }
    
    // システムサウンドを鳴らす
    func playSystemSound() {
        
        // SoundIDを格納する変数にnew-mail.cafを設定
        let soundIdRing:SystemSoundID = 1000
        
        AudioServicesPlaySystemSound(soundIdRing)
    }
    
    // バイブを鳴らす
    func playVibration() {
        
        // SoundIDを格納する変数にバイブを設定
        let soundIdRing:SystemSoundID = SystemSoundID(kSystemSoundID_Vibrate)
        
        AudioServicesPlaySystemSound(soundIdRing)
    }
    
}
