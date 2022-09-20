//
//  IAPHelper.swift
//  Kikki
//
//  Created by cuong on 1/17/19.
//  Copyright © 2019 astraler. All rights reserved.
//

import UIKit
import AstraLib

class IAPHelper {
    
    static func isUserLoggedIn() -> Bool {
        return false
    }
    
    func verifyReceiptIAP(showIndicator: Bool = true, completion: () -> Void) {
        
        guard PurchaseProduct.isPurchasedPremium else { return }
        guard IAPHelper.isUserLoggedIn() else { completion(); return }
//        guard let receiptString = PurchaseKit.receiptString else { return }
        
//        let request = ProfileRequestInfo.subscription(receipt: receiptString, password: "AA", debugMode: debugMode)
//        APIManager.request(info: request, showProgress: showIndicator) { [unowned self] _ in
//
//            self.logPurchaseTransaction(user: nil)
//            self.getUserInfo()
//            completion()
//        } failure:  { error, httpResponse in
//
//            guard showIndicator else { return }
//
//            let alertVC = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            alertVC.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
//                self.verifyReceiptIAP(showIndicator: showIndicator)
//            }))
//
//            UIViewController.topMostViewController?.present(alertVC, animated: true, completion: nil)
//        }
    }
}

extension IAPHelper {
    
    static let shared = IAPHelper()
    
    static var topMostViewController: UIViewController? {
        
        guard var topVC = UIApplication.shared.keyWindowScene?.rootViewController else { return nil }
        
        while topVC.presentedViewController != nil {
            topVC = topVC.presentedViewController!
        }
        
        return topVC
    }
}

private extension UIApplication {
    
    var keyWindowScene: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
}
