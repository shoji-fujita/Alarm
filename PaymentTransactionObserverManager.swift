//
//  PaymentTransactionObserverManager.swift
//  Aram
//
//  Created by kikin on 2016/03/07.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import Foundation
import StoreKit

// 継承禁止
final class PaymentTransactionObserverManager: NSObject, SKPaymentTransactionObserver {
    
    // initの呼び出し禁止
    private override init() {
        super.init()
    }
    
    // シングルトンとして作成
    static let sharedInstance = PaymentTransactionObserverManager()
    
    // レシート情報から、プロダクトid毎に購入済かを判定する
    func itemInfoPayment() {
        
    }
    
    // MARK: - SKPaymentTransactionObserver Required Methods
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print(__FUNCTION__)
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchasing:
                // 購入中のとき
                print(".Purchasing")
            case .Purchased:
                // 購入が完了したとき
                print(".Purchased")
                self.completeTransaction(transaction)
            case .Failed:
                // 購入が失敗したとき
                print(".Failed")
            case .Restored:
                // リストアしたとき
                print(".Restored")
                self.completeRestore(transaction)
            case .Deferred:
                // 親の許可が必要なとき
                print(".Deferred")
            }
        }
    }
    
    // MARK: - SKPaymentTransactionObserver Optional Methods
    // トランザクションがfinishTransaction経由でキューから削除されたとき
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print(__FUNCTION__)
    }
    
    // ユーザーの購入履歴からキューに戻されたトランザクションを追加中にエラーが発生したとき
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        print(__FUNCTION__)
    }
    
    // ユーザーの購入履歴から全てのトランザクションが正常に戻され、キューに追加されたとき
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print(__FUNCTION__)
    }

    // MARK: - Transaction Methods
    // 購入が完了したとき
    func completeTransaction(transaction: SKPaymentTransaction) {
        print(__FUNCTION__)
        
        // 購入が完了したことを通知する
        NSNotificationCenter.defaultCenter().postNotificationName(CommonConst.kPaymentCompletedNotification, object: transaction)
        
        // ペイメントキューに終了を伝えてトランザクションを削除する
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    // リストアが完了したとき
    func completeRestore(transaction: SKPaymentTransaction) {
        print(__FUNCTION__)
        
        // リストアしたことを通知する
        NSNotificationCenter.defaultCenter().postNotificationName(CommonConst.kRestoreCompletedNotification, object: transaction)
        
        // ペイメントキューに終了を伝えてトランザクションを削除する
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    func failedTransaction(transaction: SKPaymentTransaction) {
        print(__FUNCTION__)
        
        switch transaction.error!.code {
        case SKErrorPaymentCancelled:
            print("SKErrorPaymentCancelled")
        case SKErrorUnknown:
            print("SKErrorUnknown")
        case SKErrorClientInvalid:
            print("SKErrorClientInvalid")
        case SKErrorPaymentInvalid:
            print("SKErrorPaymentInvalid")
        case SKErrorPaymentNotAllowed:
            print("SKErrorPaymentNotAllowed")
        default:
            print("エラー内容が不明です")
        }
        
        // エラーを通知する
        NSNotificationCenter.defaultCenter().postNotificationName(CommonConst.kPaymentErrorNotification, object: transaction)
        
        // ペイメントキューに終了を伝えてトランザクションを削除する
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    func startRestore() {
        print(__FUNCTION__)
        
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
}

