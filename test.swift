//
//  test.swift
//  Aram
//
//  Created by kikin on 2016/03/04.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import UIKit
import StoreKit

class test: UIViewController, SKProductsRequestDelegate {
    
    var products = [SKProduct()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        // 購入処理が完了した時の通知を受け取るように登録
        notificationCenter.addObserver(self, selector: "paymentCompletedNotification:", name: CommonConst.kPaymentCompletedNotification, object: nil)
        
        // 購入処理が失敗した時の通知を受け取るように登録
        notificationCenter.addObserver(self, selector: "paymentErrorNotification:", name: CommonConst.kPaymentErrorNotification, object: nil)
    }
    
    // 購入するとき
    func buy() {
        if SKPaymentQueue.canMakePayments() == false {
            
            let alertController = UIAlertController(title: nil, message: "機能制限でApp内での購入が不可になっています。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertController.addAction(defaultAction)
            
            return
        }
        
        // 購入処理を開始する
        let payment = SKPayment(product: self.products[0])
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func startProductRequest() {
        let productIds = Set<String>(arrayLiteral: "com.ginga.HelloWorld")
        
        
        
        let productRequest = SKProductsRequest(productIdentifiers: productIds)
        
        
        
        productRequest.delegate = self
        productRequest.start()
    }
    
    // MARK: - SKProductsRequestDelegate
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        // invalidProductIdentifiersがあればログに出力する
        for invalidProductIdentifier in response.invalidProductIdentifiers {
            print("invalidProductIdentifier : \(invalidProductIdentifier)")
        }
        
        // プロダクト情報を後から参照できるようにメンバ変数に保存しておく
        self.products = response.products
        
        // 取得したプロダクト情報を順番にUItextVIewに表示する（今回は1つだけ）
        for products in response.products {
            print("タイトル：\(products.localizedTitle)")
            print("説明：\(products.localizedDescription)")
            print("値段：\(products.price)")
        }
    }
    
    // MARK: - SKRequestDelegate
    func requestDidFinish(request: SKRequest) {
        print(__FUNCTION__)
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print(__FUNCTION__)
    }
    
    // 購入が完了したとき
    func paymentCompletedNotification(notification: NSNotification) {
        print(__FUNCTION__)
        
        // 実際はここで機能を有効にしたり、コンテンツを表示したいする
        let transaction = notification.object as! SKPaymentTransaction

        // アラートの起動
        let alert = UIAlertView(title: "購入処理完了",
            message: "\(transaction.payment.productIdentifier) が購入されました",
            delegate: self,
            cancelButtonTitle: "OK")
        alert.show()
    }
    
    // 購入がエラーになったとき
    func paymentErrorNotification(notification: NSNotification) {
        print(__FUNCTION__)
        
        // ここでエラーを表示する
        let transaction = notification.object as! SKPaymentTransaction
        
        let alert = UIAlertView(title: "購入処理失敗",
            message: "エラーコード \(transaction.error?.code)",
            delegate: self,
            cancelButtonTitle: "OK")
        alert.show()
    }
    
}
