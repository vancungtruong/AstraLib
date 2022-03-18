//
//  CTPurchaseProduct.swift
//  IAP-Subscription
//
//  Created by Cung Truong on 4/20/18.
//  Copyright © 2018 Astraler. All rights reserved.
//

import AstraLib


public enum CTPurchaseProduct: String, CaseIterable {
    
    static let sharedSecret: String = ""
    
    case monthly = "com.demo.monthly"
    
}

extension CTPurchaseProduct {
    
    var type: CTProductType {
        switch self {
        case .monthly:
            return .subscription
        }
    }
    
    static var currentPremiums: [CTPurchaseProduct] {
        return [.monthly]
    }
    
    static var serverVerifyProducts: [CTPurchaseProduct] {
        return []
    }
    
    static var usingPromotionIAP: Bool = false
    
    static var verifyReceiptHandler: CTPurchaseVerifyReceiptHandler = { productID, isShowIndicator, completion in
        IAPHelper.shared.verifyReceiptIAP(completion: completion)
    }
    
    // MARK: -
    
    var title: String {
        switch self {
        case .monthly:
            return "Monthly"
        }
    }
    
    var priceDefault: Double {
        switch self {
        case .monthly:
            return 0
        }
    }
}




// MARK: -

extension CTPurchaseProduct {
    
    
    static var currentPremiumIDs: [String] {
        return currentPremiums.map { $0.rawValue }
    }
    
    static var serverVerifyProductIDs: [String] {
        return serverVerifyProducts.map { $0.rawValue }
    }
    
    var priceStringDefault: String {
        return "$" + String(priceDefault)
    }
    
    var localPriceString: String {
        
        var price = self.priceStringDefault
        if let product = CTPurchaseKit.shared.getProductInfo(for: self.rawValue) {
            if let priceString = product.localizedPrice {
                price = priceString.replacingOccurrences(of: ",", with: "")
            }
        }
        return price
    }
}


