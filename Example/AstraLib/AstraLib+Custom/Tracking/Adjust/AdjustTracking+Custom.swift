//
//  TrackingKit+Custom.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/4/22.
//

import AstraLib

struct AdjustToken {
    
    static let appToken = "app_token_here"
    
    
    enum Premium: String {
        
        case monthly = "monthly_token_here"
        
        case yearly = "yearly_token_here"
        
        case lifetime = "lifetime_token_here"
    }
}

extension AdjustTracking {
    
//    static func trackCustomEvent() {
//
//
//        let params =  AdjustEventParameters()
//        params.callbackParameters = [
//            "param" : "value"
//        ]
//        AdjustTracking.trackEvent(token: "Token_Here", parameters: params)
//    }
}
