//
//  CTPurchaseProduct+Facebook.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/17/22.
//

import AstraLib

extension CTPurchaseProduct {
    
    func trackFacebook(additionParams: [String: Any]?) {

        if let product = CTPurchaseKit.shared.productsInfo[self.rawValue],
           let receiptString = CTPurchaseKit.receiptString {

            let currency = product.priceLocale.currencyCode ?? "USD"
            let price = product.price.doubleValue

            var eventParams: [String: Any] = [
                "item_id" : self.rawValue,
                "item_name" : self.title,
                "amount" : price,
                "currency" : currency,
                "receipt" : receiptString
            ]

            if let additions = additionParams {
                for (key, value) in additions {
                    eventParams[key] = value
                }
            }
            
            FacebookTracking.trackEvent(name: TrackingEvent.inAppPurchase.rawValue, valueToSum: price, parameters: eventParams)
        }
    }
}
