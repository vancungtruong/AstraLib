//
//  PurchaseProduct.swift
//  IAP-Subscription
//
//  Created by Cung Truong on 4/20/18.
//  Copyright © 2018 Astraler. All rights reserved.
//

import UIKit

extension PurchaseProduct {
    
    static var purchases: [PurchaseProduct] {
        return allCases.filter({ $0.type == .purchase })
    }
    
    static var subscriptions: [PurchaseProduct] {
        return allCases.filter({ $0.type == .subscription })
    }
    
    static var consumables: [PurchaseProduct] {
        return allCases.filter({ $0.type == .consumable })
    }
    
    // IDs
    
    static var purchaseIDs: [String] {
        return purchases.map({ $0.rawValue })
    }
    
    static var subscriptionIDs: [String] {
        return subscriptions.map({ $0.rawValue })
    }
    
    static var consumableIDs: [String] {
        return consumables.map({ $0.rawValue })
    }
}


extension PurchaseProduct {
    
    static var isPurchasedPremium: Bool {
        
        if purchases.first(where: { $0.isPurchased }) != nil {
            return true
        }
        
        if subscriptions.first(where: { $0.isPurchased }) != nil {
            return true
        }
        
        return false
    }
    
    // -----
    
    var isPurchased: Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }
}
