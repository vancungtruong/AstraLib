//
//  FacebookTracking.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/14/22.
//

import FBSDKCoreKit
import UIKit

public class FacebookTracking {
    
    public static func config(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
    
    public static func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        return ApplicationDelegate.shared.application(
            application,
            open: url,
            options: options
        )
    }
    
    @discardableResult public static func open(url: URL) -> Bool {
        
        return ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
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
