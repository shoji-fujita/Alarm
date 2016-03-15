//
//  SystemViewController.swift
//  Aram
//
//  Created by kikin on 2016/03/03.
//  Copyright © 2016年 fukuda. All rights reserved.
//

import UIKit
import StoreKit

class SystemViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let cellLabelArray = ["広告を非表示にする"]
    let itunesConnectTitleArray = ["広告解除"]
    var products = [SKProduct()]
    var restoreAlertView = UIAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        // 購入処理が完了した時の通知を受け取るように登録
        notificationCenter.addObserver(self, selector: "paymentCompletedNotification:", name: CommonConst.kPaymentCompletedNotification, object: nil)
        
        // 購入処理が失敗した時の通知を受け取るように登録
        notificationCenter.addObserver(self, selector: "paymentErrorNotification:", name: CommonConst.kPaymentErrorNotification, object: nil)
        
        // リストアが完了した時の通知を受け取るように登録
        notificationCenter.addObserver(self, selector: "restoreCompletedNotification:", name: CommonConst.kRestoreCompletedNotification, object: nil)
    }
    
    // 戻るボタンを押したとき
    @IBAction func pushBackButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // セクションのタイトル
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "アプリ内課金"
        } else {
            return "記入してください"
        }
    }
    
    // MARK: - UITableViewDelegate
    // セルが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.startProductRequest()
    }
    
    // セルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.cellLabelArray[indexPath.row]
        
        return cell
    }
    
    // セルの数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 購入するとき
    func buy() {
        // アプリ内課金ができないとき
        if SKPaymentQueue.canMakePayments() == false {
            
            let alertController = UIAlertController(title: nil, message: "機能制限でApp内での購入が不可になっています。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertController.addAction(defaultAction)
            
            return
        }
        
        // 購入処理を開始する
        for product in self.products {
            
            print("product.localizedTitle: \(product.localizedTitle)")
            print("vitunesConnectTitleArray[self.tableView.indexPathForSelectedRow!.row]: \(itunesConnectTitleArray[self.tableView.indexPathForSelectedRow!.row])")
            
            if product.localizedTitle != itunesConnectTitleArray[self.tableView.indexPathForSelectedRow!.row] {
                continue
            }
            
            let payment = SKPayment(product: product)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            
            break
        }
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
        
        for product in self.products {
            if product.localizedTitle != itunesConnectTitleArray[self.tableView.indexPathForSelectedRow!.row] {
                continue
            }
            
            let alert = UIAlertView(title: "アドオンを入手",
                message: "\(product.localizedTitle) を \(product.price)円 で購入しますか",
                delegate: self,
                cancelButtonTitle: "キャンセル",
                otherButtonTitles: "OK")
            alert.show()

            break
        }
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print("キャンセルを押下されました")
        case 1:
            print("OKを押下されました")
            
            // 購入する
            self.buy()
            
        default:
            break
        }
        
        // セルの選択を解除する
        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
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
    
        /*
        // 実際はここで機能を有効にしたり、コンテンツを表示したりする
        let transaction = notification.object as! SKPaymentTransaction
        
        // アラートの起動
        let alert = UIAlertView(title: "購入処理完了",
            message: "\(transaction.payment.productIdentifier) が購入されました",
            delegate: self,
            cancelButtonTitle: "OK")
        alert.show()
        */
    }
    
    // リストアが完了したとき
    func restoreCompletedNotification(notification: NSNotification) {
        print(__FUNCTION__)
        
        // アラートを消す
        self.restoreAlertView.dismissWithClickedButtonIndex(0, animated: true)
        
        let transaction = notification.object as! SKPaymentTransaction
        
        // アラートの起動
        let alert = UIAlertView(title: "リストア完了",
            message: "\(transaction.payment.productIdentifier) がリストアされました",
            delegate: nil,
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
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
    
    // MARK: - handle method
    // 購入情報の取得
    func handleProductsRequestButton(sender: UIButton) {
        print(__FUNCTION__)
        self.startProductRequest()
    }
    
    // 購入する
    func handleBuyButton(sender: UIButton) {
        print(__FUNCTION__)
        self.buy()
    }
    
    // リストアボタンを押したとき
    @IBAction func pushRestoreButton(sender: AnyObject) {
        print(__FUNCTION__)
        
        // リストア処理中はUIAlertViewを表示する
        self.restoreAlertView = UIAlertView(title: "処理中",
            message: "リストア中です",
            delegate: nil,
            cancelButtonTitle: nil)
        self.restoreAlertView.show()
        
        PaymentTransactionObserverManager.sharedInstance.startRestore()
    }

}
