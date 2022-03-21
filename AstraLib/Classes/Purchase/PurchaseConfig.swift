//
//  PurchaseConfig.swift
//  InAppPurchaseKit
//
//  Created by Cung Truong on 03/03/2022.
//

import Foundation

public typealias PurchaseVerifyReceiptHandler = (_ productID: String?, _ isShowIndicator: Bool, _ completion: () -> Void) -> Void

public struct PurchaseConfig {
    
    public let sharedSecret: String?
    
    public let purchaseIDs: [String]
    
    public let subscriptionIDs: [String]
    
    public let serverVerifyProductIDs: [String]    // server verify receipt of subscriptions or consumables
    
    public let verifyReceiptHandler: PurchaseVerifyReceiptHandler?
    
    public let usingPromotionIAP: Bool
    
    public static let empty = PurchaseConfig(
        sharedSecret: nil,
        purchaseIDs: [],
        subscriptionIDs: [],
        serverVerifyProductIDs: [],
        verifyReceiptHandler: nil,
        usingPromotionIAP: false
    )
    
    public init(
        sharedSecret: String?,
        purchaseIDs: [String],
        subscriptionIDs: [String],
        serverVerifyProductIDs: [String],
        verifyReceiptHandler: PurchaseVerifyReceiptHandler?,
        usingPromotionIAP: Bool) {
        
        self.sharedSecret = sharedSecret
        self.purchaseIDs = purchaseIDs
        self.subscriptionIDs = subscriptionIDs
        self.serverVerifyProductIDs = serverVerifyProductIDs
        self.verifyReceiptHandler = verifyReceiptHandler
        self.usingPromotionIAP = usingPromotionIAP
    }
}
