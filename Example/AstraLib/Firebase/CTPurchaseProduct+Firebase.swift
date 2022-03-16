//
//  FirebaseTracking.swift
//  MyCar
//
//  Created by An Thai on 12/31/21.
//  Copyright © 2021 Astraler. All rights reserved.
//

import AstraLib

enum FirebaseEvent: String {
    
    case inAppPurchase = "InAppPurchase"
    
    
    
    // MARK: - FirebaseEvent
    var name: String {
        return self.rawValue
    }
}

extension CTPurchaseProduct {
    
    // custom here
    
    func logFirebase(additionParams: [String: Any]?) {

        if let product = CTPurchaseKit.shared.productsInfo[self.rawValue],
           let receiptString = CTPurchaseKit.receiptString {

            let currency = product.priceLocale.currencyCode ?? "USD"

            var eventParams: [String: Any] = [
                "item_id" : self.rawValue,
                "item_name" : self.title,
                "currency" : currency,
                "receipt" : receiptString
            ]

            if let additions = additionParams {
                for (key, value) in additions {
                    eventParams[key] = value
                }
            }
            
            FirebaseTracking.trackEvent(FirebaseEvent.inAppPurchase.rawValue, parameters: eventParams)
        }
    }
}
