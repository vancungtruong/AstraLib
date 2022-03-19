//
//  FirebaseTracking.swift
//  MyCar
//
//  Created by An Thai on 12/31/21.
//  Copyright © 2021 Astraler. All rights reserved.
//

import AstraLib


extension CTPurchaseProduct {
    
    func trackFirebase(additionParams: [String: Any]?) {

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
            
            FirebaseTracking.trackEvent(TrackingEvent.inAppPurchase.rawValue, parameters: eventParams)
        }
    }
}
