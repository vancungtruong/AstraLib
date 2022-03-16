//
//  CTPurchaseKit+Config.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/3/22.
//

import AstraLib

extension CTPurchaseKit {
    
    static func config() {
        
        let configuration = CTPurchaseConfig(
            sharedSecret: CTPurchaseProduct.sharedSecret,
            purchaseIDs: CTPurchaseProduct.purchaseIDs,
            subscriptionIDs: CTPurchaseProduct.subscriptionIDs,
            serverVerifyProductIDs: CTPurchaseProduct.serverVerifyProductIDs,
            verifyReceiptHandler: CTPurchaseProduct.verifyReceiptHandler,
            usingPromotionIAP: CTPurchaseProduct.usingPromotionIAP
        )
        shared.config(configuration)
    }
}
