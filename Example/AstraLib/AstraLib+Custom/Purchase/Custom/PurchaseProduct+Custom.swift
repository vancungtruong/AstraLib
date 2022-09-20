//
//  PurchaseProduct.swift
//  IAP-Subscription
//
//  Created by Cung Truong on 4/20/18.
//  Copyright © 2018 Astraler. All rights reserved.
//

import AstraLib

public enum PurchaseProduct: String, CaseIterable {
    
    static let sharedSecret = "75fb9601618443ea8d3f4ebfef2da655"
    
    case monthly = "com.cuongnguyen.demo.monthly"
    
    case yearly = "com.cuongnguyen.demo.yearly"
    
    case lifetime = "com.cuongnguyen.demo.lifetime"
}

extension PurchaseProduct {
    
    var type: CTProductType {
        switch self {
        case .monthly, .yearly:
            return .subscription
        case .lifetime:
            return .purchase
        }
    }
    
    static var currentPremiums: [PurchaseProduct] {
        return [.monthly, .yearly, .lifetime]
    }
    
    static var serverVerifyProducts: [PurchaseProduct] {
        return []
    }
    
    static var usingPromotionIAP: Bool = false
    
    static var verifyReceiptHandler: PurchaseVerifyReceiptHandler = { productID, isShowIndicator, completion in
        IAPHelper.shared.verifyReceiptIAP(completion: completion)
    }
    
    // MARK: -
    
    var title: String {
        switch self {
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        case .lifetime:
            return "Lifetime"
        }
    }
    
    var priceDefault: Double {
        switch self {
        case .monthly:
            return 9.99
        case .yearly:
            return 29.99
        case .lifetime:
            return 49.99
        }
    }
}




// MARK: -

extension PurchaseProduct {
    
    
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
        if let product = PurchaseKit.shared.getProductInfo(for: self.rawValue) {
            if let priceString = product.localizedPrice {
                price = priceString.replacingOccurrences(of: ",", with: "")
            }
        }
        return price
    }
}


