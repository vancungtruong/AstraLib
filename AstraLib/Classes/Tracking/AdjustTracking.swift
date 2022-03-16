//
//  TrackingKit.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/4/22.
//

import Adjust

public struct AdjustRevenueParameter {
    
    public let amount: Double
    public let currency: String
    
    public init(amount: Double, currency: String) {
        self.amount = amount
        self.currency = currency
    }
}

public struct AdjustReceiptParameter {
    public let data: Data
    public let transactionID: String
    
    public init(data: Data, transactionID: String) {
        self.data = data
        self.transactionID = transactionID
    }
}

public class AdjustEventParameters: NSObject {
    
    public var revenue: AdjustRevenueParameter?
    
    public var receipt: AdjustReceiptParameter?
    
    public var callbackID: String?
    
    public var transactionID: String?
    
    public var partnerParameters: [String: String]?
    
    public var callbackParameters: [String: String]?
}

public class AdjustTracking {
    
    public static func config(appToken: String) {
        
        #if DEBUG
        let environment = ADJEnvironmentSandbox
        let logLevel = ADJLogLevelVerbose
        #else
        let environment = ADJEnvironmentProduction
        let logLevel = ADJLogLevelError
        #endif
        
        if let adjustConfig = ADJConfig(appToken: appToken, environment: environment) {
            adjustConfig.logLevel = logLevel
            Adjust.appDidLaunch(adjustConfig)
        }
    }
    
    public static func trackEvent(token: String, parameters: AdjustEventParameters?) {
        
        guard let event = ADJEvent(eventToken: token) else {
            print("An error occurred while creating ADJEvent")
            return
        }
        
        if let revenue = parameters?.revenue {
            event.setRevenue(revenue.amount, currency: revenue.currency)
        }
        
        if let receipt = parameters?.receipt {
            event.setReceipt(receipt.data, transactionId: receipt.transactionID)
        }
        
        if let callbackID = parameters?.callbackID {
            event.setCallbackId(callbackID)
        }
        
        if let transactionID = parameters?.transactionID {
            event.setTransactionId(transactionID)
        }
    
        if let callbacks = parameters?.callbackParameters {
            for (key, value) in callbacks {
                event.addCallbackParameter(key, value: value)
            }
        }
        
        if let partners = parameters?.partnerParameters {
            for (key, value) in partners {
                event.addPartnerParameter(key, value: value)
            }
        }
        
        Adjust.trackEvent(event)
    }
    
    public static func trackSubscription(price: NSDecimalNumber, currency: String, transactionId: String, receipt: Data, transactionDate: Date?, regionCode: String?) {
        
        guard let subscription = ADJSubscription(
            price: price,
            currency: currency,
            transactionId: transactionId,
                andReceipt: receipt)
        else {
            return
        }
         
        if let date = transactionDate {
            subscription.setTransactionDate(date)
        }
        
        if let regionCode = regionCode {
            subscription.setSalesRegion(regionCode)
        }

        Adjust.trackSubscription(subscription)
    }
    
}
