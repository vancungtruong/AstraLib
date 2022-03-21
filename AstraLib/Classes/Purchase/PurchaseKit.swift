//
//  StoreKitManager.swift
//  IAP-Subscription
//
//  Created by Cung Truong on 4/19/18.
//  Copyright © 2018 Astraler. All rights reserved.
//

import SwiftyStoreKit
import StoreKit

public typealias PurchaseCompletion = (_ isSuccess: Bool?) -> Void
public typealias PurchaseVerifyCompletion = (_ isSuccess: Bool?, _ expiryDate: Date?) -> Void

#if DEBUG
    private let kDelayTime: TimeInterval = 60 * 5
#else
    private let kDelayTime: TimeInterval = 60 * 60 * 24
#endif

public enum CTProductType {
    
    case purchase
    case subscription
    case consumable
}


public class PurchaseKit {

    
    public static let shared: PurchaseKit = PurchaseKit()
    
    
    public var productsInfo: [String: SKProduct] = [:]
    public var needVerifyPurchases: [PurchaseProtocol] = []
    
    public var config: PurchaseConfig = PurchaseConfig.empty
    
    private var indicatorView: UIActivityIndicatorView = {
        
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.hidesWhenStopped = true
        indicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicatorView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        indicatorView.alpha = 0.0
        
        return indicatorView
    }()
    
    
    private var localDateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return result
    }()
    
    // MARK: - StoreKit
    
    public func getProductInfo(for productID: String) -> SKProduct? {
        return productsInfo[productID]
    }
    
    public func existVerifyPurchase(for productID: String) -> Bool {
        if needVerifyPurchases.firstIndex(where: { $0.productId == productID }) != nil {
            return true
        }
        return false
    }
    
    public func findVerifyPurchase(for productID: String) -> PurchaseProtocol? {
        return needVerifyPurchases.last(where: { $0.productId == productID })
    }
    
    public func finishTransactions(for productID: String) {
        
        let purchases = needVerifyPurchases.filter({ $0.productId == productID })
        purchases.forEach({ SwiftyStoreKit.finishTransaction($0.transaction) })
        needVerifyPurchases = needVerifyPurchases.filter({ $0.productId != productID })
    }
    
    public func finishAllTransactions() {
        
        needVerifyPurchases.forEach({ SwiftyStoreKit.finishTransaction($0.transaction) })
        needVerifyPurchases = []
    }
    
    public func registerAppStorePaymentHandler() {
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
             return true
        }
    }
    
    
    public func retrieveProductsInfo(productIDs: [String], showIndicator: Bool = false, completion: PurchaseCompletion?) {
        
        if showIndicator {
            showActivityIndicator()
        }
        
        let productIDs: Set<String> = Set(productIDs)
        SwiftyStoreKit.retrieveProductsInfo(productIDs) { [unowned self] result in
            
            if showIndicator {
                self.hideActivityIndicator()
            }
            
            if let error = result.error {
                
                self.log(error)
                self.showAlert(message: error.localizedDescription)
                completion?(false)
                
            } else if result.invalidProductIDs.count > 0 {
                
                self.log(result.invalidProductIDs)
                self.showAlert(message: "Invalid ProductID: \(result.invalidProductIDs.first!)")
                completion?(false)
                
            } else {
                
                result.retrievedProducts.forEach({ (product) in
                    self.productsInfo[product.productIdentifier] = product
                })
                
                self.log(self.productsInfo)
                
                completion?(true)
            }
        }
    }
    
    public func purchaseProduct(_ product: SKProduct, completion: PurchaseCompletion?) {
        
        let atomically = config.serverVerifyProductIDs.contains(product.productIdentifier) ? false : true
            
        showActivityIndicator()
        SwiftyStoreKit.purchaseProduct(product, atomically: atomically) { result in
            
            self.hideActivityIndicator()
            self.handlePurchaseResult( result, atomically: atomically, completion: completion)
        }
    }
    
    public func purchaseProduct(_ productID: String, completion: PurchaseCompletion?) {
        
        let atomically = config.serverVerifyProductIDs.contains(productID) ? false : true
        
        showActivityIndicator()
        SwiftyStoreKit.purchaseProduct(productID, atomically: atomically) { result in
            
            self.hideActivityIndicator()
            self.handlePurchaseResult(result, atomically: atomically, completion: completion)
        }
    }
    
    
    public func restorePurchases(atomically: Bool = true, completion: PurchaseCompletion?) {
        
        showActivityIndicator()
        SwiftyStoreKit.restorePurchases(atomically: atomically) { results in
            
            self.hideActivityIndicator()
            
            if results.restoreFailedPurchases.count > 0 {
                
                self.log("Restore Failed: \(results.restoreFailedPurchases)")
                self.showAlert(message: "Restore Failed")
                completion?(false)
                
            } else if results.restoredPurchases.count > 0 {
                
                self.handleRestoreSuccess(results: results, completion: completion)
                
            } else {
                self.log("Nothing to Restore")
                self.showAlert(title: nil, message: "Nothing to Restore")
                completion?(nil)
            }
        }
    }
    
    // MARK: -
    
    private func handlePurchaseResult(_ result: PurchaseResult, atomically: Bool, completion: PurchaseCompletion?) {
        
        switch result {
            
        case .success(let purchase):
            
            self.log("[Purchase Success] -> \(purchase.productId)")
            
            if config.purchaseIDs.contains(purchase.productId) || config.subscriptionIDs.contains(purchase.productId) {
                purchase.productId.setPurchased(true)
            }
            
            if config.serverVerifyProductIDs.contains(purchase.productId) {
                needVerifyPurchases.append(purchase)
            } else {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
            
            completion?(true)
            
        case .error(let error):
            self.handlePurchaseError(error)
            completion?(false)
        }
    }
    
    
    private func handlePurchaseError(_ error: SKError) {
        
        self.log(error)
        
        if error.code != .paymentCancelled {
            self.showAlert(message: error.localizedDescription)
        }
    }
    
    
    private func handleRestoreSuccess(results: RestoreResults, completion: PurchaseCompletion?) {
        
        for purchase in results.restoredPurchases {
            
            if config.purchaseIDs.contains(purchase.productId) || config.subscriptionIDs.contains(purchase.productId) {
                UserDefaults.standard.setValue(true, forKey: purchase.productId)
            }
        }
        
        UserDefaults.standard.synchronize()
        
        self.log("Restore Completed")
        self.showAlert(title: nil, message: "Restore Completed")
        completion?(true)
    }
    
    // MARK: - Other
    
    
    public func showAlert(title: String? = "Error", message: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        topViewController()?.present(alertVC, animated: true, completion: nil)
    }
    
    
    public func showActivityIndicator() {
        
        guard let window = UIApplication.shared.keyWindowScene else { return }
            
        indicatorView.frame = window.bounds
        window.addSubview(indicatorView)
        
        indicatorView.startAnimating()
        
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.alpha = 1.0
        }
    }
    
    
    public func hideActivityIndicator() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.indicatorView.alpha = 0.0
        }, completion: { isSuccess in
            
            if isSuccess {
                self.indicatorView.stopAnimating()
                self.indicatorView.removeFromSuperview()
            }
        })
    }
    
    
    public func topViewController(controller: UIViewController? = UIApplication.shared.keyWindowScene?.rootViewController) -> UIViewController? {
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if let naviController = controller as? UINavigationController {
            return topViewController(controller: naviController.visibleViewController)
        }
        if let tabbarController = controller as? UITabBarController {
            return topViewController(controller: tabbarController.selectedViewController)
        }
        
        return controller
    }
    
    
    func log(_ items: Any...) {
        #if DEBUG
        print("[PurchaseKit] - ", items)
        #endif
    }
    
    
    // MARK: - Verify
    
    public func verifyReceipt(type: CTProductType, productID: String, completion: PurchaseVerifyCompletion?) {
        
        #if DEBUG
            let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: config.sharedSecret)
        #else
            let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: config.sharedSecret)
        #endif
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            
            switch result {
                
            case .success(let receipt):
                self.log("Fetch Receipt Success")
                switch type {
                case .purchase:
                    self.verifyPurchase(productID: productID, in: receipt, completion: completion)
                case .subscription:
                    self.verifySubscription(productID: productID, in: receipt, completion: completion)
                default:
                    break
                }
                
            case .error(let error):
                self.handleFetchReceiptError(error, productID: productID, completion: completion)
            }
        }
    }
    
    
    public func verifyPurchase(productID: String, in receipt: ReceiptInfo, completion: PurchaseVerifyCompletion?) {
        
        let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
        
        switch purchaseResult {
            
        case .purchased(_):
            self.log("Product is purchased: " + productID)
            
            productID.setPurchased(true)
            completion?(true, nil)
            
        case .notPurchased:
            self.log("The user has never purchased product: " + productID)
            productID.setPurchased(false)
            completion?(false, nil)
        }
    }
    
    
    public func verifySubscription(productID: String, in receipt: ReceiptInfo, completion: PurchaseVerifyCompletion?) {
        
        let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productID, inReceipt: receipt)
        
        switch purchaseResult {
            
        case .purchased(let expiryDate, _):

            self.log(productID + ": expiryDate -> \(localDateFormatter.string(from: expiryDate))")
            productID.setExpiryTime(expiryDate.timeIntervalSince1970)
            productID.setPurchased(true)
            completion?(true, expiryDate)
            
        case .expired(let expiryDate, _):
            
            self.log(productID + ": expiredDate -> \(localDateFormatter.string(from: expiryDate))")
            
            if expiryDate.timeIntervalSince1970 + kDelayTime < Date().timeIntervalSince1970 {
                
                productID.removeExpiryTime()
                productID.setPurchased(false)
                completion?(false, expiryDate)
            }
            
        case .notPurchased:
            
            self.log("The user has never purchased product: " + productID)
            productID.removeExpiryTime()
            productID.setPurchased(false)
            completion?(false, nil)
        }
    }
    
    
    private func handleFetchReceiptError(_ error: ReceiptError, productID: String, completion: PurchaseVerifyCompletion?) {
        
        self.log("Verify receipt Failed: \(error)")
            
            if let expiryTime = productID.expiryTime {
                
                if Date().timeIntervalSince1970 - kDelayTime > expiryTime {
                    
                    let expiredDate = Date(timeIntervalSince1970: expiryTime)
                    self.log("local: \(productID) is expired since -> ", localDateFormatter.string(from: expiredDate))
                    productID.removeExpiryTime()
                    productID.setPurchased(false)
                    completion?(false, expiredDate)
                    return
                }
            }
        
        completion?(nil, nil)
    }
    
    public func showMessageExpiredDate(productID: String, expiredDate: Date?) {
        
        showAlert(title: "In-App Purchase", message: "Your subscription for the premium version has expired.")
    }
}


public protocol PurchaseProtocol {
    
    var productId: String {get}
    var quantity: Int {get}
    var transaction: PaymentTransaction {get}
    var originalTransaction: PaymentTransaction? {get}
    var needsFinishTransaction: Bool {get}
    var paymentProduct: SKProduct? {get}
}

extension Purchase: PurchaseProtocol {
    public var paymentProduct: SKProduct? {
        return nil
    }
}
extension PurchaseDetails: PurchaseProtocol {
    public var paymentProduct: SKProduct? {
        return self.product
    }
}


// MARK: - Custom

extension PurchaseKit {
    
    public func config(_ configuration: PurchaseConfig) {
        
        self.config = configuration
        
        addObserverTransactions()
        
        if configuration.usingPromotionIAP {
            PurchaseKit.shared.registerAppStorePaymentHandler()
        }
        
        DispatchQueue.main.async {
            self.verifyPurchaseIfNeed()
        }
    }
    
    private func addObserverTransactions() {
        
        SwiftyStoreKit.completeTransactions(atomically: false) { [unowned self] purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    
                    if purchase.needsFinishTransaction {
                        #if DEBUG
                        print("needsFinishTransaction ---------> ", purchase.productId)
                        #endif
                        if config.serverVerifyProductIDs.contains(purchase.productId) {
                            PurchaseKit.shared.needVerifyPurchases.append(purchase)
                        } else {
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                            
                            if config.purchaseIDs.contains(purchase.productId) ||
                                config.subscriptionIDs.contains(purchase.productId) {
                                purchase.productId.setPurchased(true)
                            }
                        }
                    }
                    
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
            
            if !self.needVerifyPurchases.isEmpty {
                config.verifyReceiptHandler?(nil, false, { [unowned self] in
                    self.finishAllTransactions()
                })
            }
        }
    }
    
    public func verifyPurchaseIfNeed() {
        
        if config.purchaseIDs.first(where: { $0.isPurchased }) != nil {
            return
        }
        
        if let subscriptionID = config.subscriptionIDs.first(where: { $0.isPurchased }) {
            
            PurchaseKit.shared.verifyReceipt(type: .subscription, productID: subscriptionID, completion: { [unowned self] isPurchased, expiryDate in
                
                if isPurchased == false {
                    self.showMessageExpiredDate(productID: subscriptionID, expiredDate: expiryDate)
                }
                
                NotificationCenter.default.post(name: .InAppPurchase, object: subscriptionID)
            })
        }

    }
    
    public static var receiptData: Data? {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else { return  nil}
        let receipt = try? Data(contentsOf: receiptUrl)
        return receipt
    }
    
    public static var receiptString: String? {
        
        let receiptString = receiptData?.base64EncodedString(options: [])
        
        #if DEBUG
        print("receiptString -> ", receiptString ?? "")
        #endif
        
        return receiptString
    }
    
    public func postInAppPurchasedNotification(object: Any?) {
        NotificationCenter.default.post(name: .InAppPurchase, object: object)
    }
}


public extension UIApplication {
    
    var keyWindowScene: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
}


// MARK: - ProductID extension

private extension String {
    
    func setPurchased(_ isPurchased: Bool) {
        UserDefaults.standard.set(isPurchased, forKey: self)
        UserDefaults.standard.synchronize()
    }
    
    var isPurchased: Bool {
        return UserDefaults.standard.bool(forKey: self)
    }
    
    func setExpiryTime(_ time: TimeInterval) {
        UserDefaults.standard.set(time, forKey: expiryTimeKey)
        UserDefaults.standard.synchronize()
    }
    
    var expiryTime: TimeInterval? {
        return UserDefaults.standard.value(forKey: expiryTimeKey) as? TimeInterval
    }
    
    func removeExpiryTime() {
        
        UserDefaults.standard.removeObject(forKey: expiryTimeKey)
        UserDefaults.standard.synchronize()
    }
    
    var expiryTimeKey: String {
        return self + ".expiryTime"
    }
}
