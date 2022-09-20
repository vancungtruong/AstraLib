//
//  PurchaseProduct+Adjust.swift
//  Kikki
//
//  Created by cuong on 12/5/19.
//  Copyright © 2019 astraler. All rights reserved.
//

import AstraLib

extension PurchaseProduct {
    
    var adjustToken: String {
        switch self {
        case .monthly:
            return AdjustToken.Premium.monthly.rawValue
        case .yearly:
            return AdjustToken.Premium.yearly.rawValue
        case .lifetime:
            return AdjustToken.Premium.lifetime.rawValue
        }
    }
    
    func trackAdjust(additionParams: [String: String]?) {
        
        let params = AdjustEventParameters()
        
        if let product = PurchaseKit.shared.productsInfo[self.rawValue] {
            let price = product.price.doubleValue
            let currency = product.priceLocale.currencyCode ?? "USD"
            params.revenue = AdjustRevenueParameter(amount: price, currency: currency)
        }
        
        if let purchase = PurchaseKit.shared.findVerifyPurchase(for: self.rawValue),
           let transactionID = purchase.transaction.transactionIdentifier {
            
            params.transactionID = transactionID
        }
        
        params.callbackParameters = additionParams
        
        AdjustTracking.trackEvent(token: self.adjustToken, parameters: params)
    }
    
    func trackAdjustSubscription() {
        
        guard let product = PurchaseKit.shared.productsInfo[self.rawValue],
              let receipt = PurchaseKit.receiptData,
              let purchase = PurchaseKit.shared.findVerifyPurchase(for: product.productIdentifier),
              let transactionId = purchase.transaction.transactionIdentifier
        else {
            return
        }
        
        AdjustTracking.trackSubscription(
            price: product.price,
            currency: product.priceLocale.currencyCode ?? "USD",
            transactionId: transactionId,
            receipt: receipt,
            transactionDate: purchase.transaction.transactionDate,
            regionCode: product.priceLocale.regionCode
        )
    }
    
    
}
