//
//  SKProduct+Extension.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/3/22.
//

import StoreKit

extension SKProduct {
    
    var hasFreeTrial: Bool {
        
        if #available(iOS 11.2, *) {
            return (self.introductoryPrice?.subscriptionPeriod != nil)
        } else {
            return false
        }
    }
}
