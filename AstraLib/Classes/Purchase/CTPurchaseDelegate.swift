//
//  CTPurchaseDelegate.swift
//  IAP-Subscription
//
//  Created by Cung Truong on 4/23/18.
//  Copyright © 2018 Astraler. All rights reserved.
//

import Foundation


public protocol CTPurchaseDelegate: NSObjectProtocol {
    
    func handleInAppPurchaseNotification(_ notify: Notification)
}


extension CTPurchaseDelegate {
    
    public func addObserverInAppPurchaseNotification() {
        
        NotificationCenter.default.addObserver(forName: .InAppPurchase, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            
            self?.handleInAppPurchaseNotification(notification)
        }
    }
    
    public func removeObserverInAppPurchaseNotification() {
        NotificationCenter.default.removeObserver(self, name: .InAppPurchase, object: nil)
    }
}

public extension Notification.Name {
    
    static let InAppPurchase = Notification.Name("InAppPurchaseNotification")
}
