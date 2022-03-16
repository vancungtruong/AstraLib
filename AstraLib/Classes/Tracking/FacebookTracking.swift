//
//  FacebookTracking.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/14/22.
//

import FBSDKCoreKit

public class FacebookTracking {
    
    public static func trackEvent(name: String, valueToSum: Double?, parameters: [String : Any]?) {
        
        let event = AppEvents.Name(name)
        
        if let parameters = parameters {
            
            var params: [AppEvents.ParameterName : Any] = [:]
            for (key, value) in parameters {
                params[AppEvents.ParameterName(rawValue: key)] = value
            }
            
            if let valueToSum = valueToSum {
                AppEvents.shared.logEvent(event, valueToSum: valueToSum, parameters: params)
            } else {
                AppEvents.shared.logEvent(event, parameters: params)
            }
        } else {
            
            if let valueToSum = valueToSum {
                AppEvents.shared.logEvent(event, valueToSum: valueToSum)
            } else {
                AppEvents.shared.logEvent(event)
            }
        }
        
    }
    
    public static func trackPurchase(amount: Double, currency: String, parameters: [String : Any]?) {
        
        if let parameters = parameters {
            AppEvents.shared.logPurchase(amount: amount, currency: currency, parameters: parameters)
        } else {
            AppEvents.shared.logPurchase(amount: amount, currency: currency)
        }
    }
}
