//
//  PurchaseKit+Config.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/3/22.
//

import AstraLib

extension PurchaseKit {
    
    static func config() {
        
        let configuration = PurchaseConfig(
            sharedSecret: PurchaseProduct.sharedSecret,
            purchaseIDs: PurchaseProduct.purchaseIDs,
            subscriptionIDs: PurchaseProduct.subscriptionIDs,
            serverVerifyProductIDs: PurchaseProduct.serverVerifyProductIDs,
            verifyReceiptHandler: PurchaseProduct.verifyReceiptHandler,
            usingPromotionIAP: PurchaseProduct.usingPromotionIAP
        )
        shared.config(configuration)
    }
}
