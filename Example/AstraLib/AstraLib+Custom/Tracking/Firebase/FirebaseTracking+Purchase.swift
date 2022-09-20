//
//  FirebaseTracking.swift
//  MyCar
//
//  Created by An Thai on 12/31/21.
//  Copyright © 2021 Astraler. All rights reserved.
//

import AstraLib


extension PurchaseProduct {
    
    func trackFirebase(additionParams: [String: Any]?) {

        if let product = PurchaseKit.shared.productsInfo[self.rawValue] {

            let currency = product.priceLocale.currencyCode ?? "USD"

            var eventParams: [String: Any] = [
                "item_id" : self.rawValue,
                "item_name" : self.title,
                "currency" : currency
            ]

            if let additions = additionParams {
                for (key, value) in additions {
                    eventParams[key] = value
                }
            }
            
            FirebaseTracking.trackEvent(.inAppPurchase, parameters: eventParams)
        }
    }
}
