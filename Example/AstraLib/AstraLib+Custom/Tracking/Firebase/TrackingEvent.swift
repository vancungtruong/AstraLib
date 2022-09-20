//
//  TrackingEvent.swift
//  InAppPurchaseKit
//
//  Created by cuong on 3/17/22.
//

import Foundation

enum TrackingEvent {
    
    enum Name: String {
        case inAppPurchase  = "InAppPurchase"
        case custom         = "Custom name"
        
        case onboardingView = "Onboarding_view"
        case routerRequest  = "Router_request"
    }
    
    
    
    case onboardingView(_ condition: Onboarding_condition)
    case routerRequest(_ condition: Access_condition)
    
    
    
    var name: TrackingEvent.Name {
        switch self {
        case .onboardingView(_):   return .onboardingView
        case .routerRequest(_):    return .routerRequest
        }
    }
    
    var params: [String: String] {
        switch self {
        case .onboardingView(let condition):   return condition.params
        case .routerRequest(let condition):    return condition.params
        }
    }
}


enum Onboarding_condition: String, TrackingCondition {
    
    
    case Survey_1
    case Survey_2
    case Onboarding_1
    case Onboarding_2
    case Onboarding_3
    case Location_access
    case Wifi_access
    case Scan_device
    case Scan_result
    case Home
}


enum Access_condition: String, TrackingCondition {

    case Home_topbanner
    case Wifi_edit
    case Guest_wifi
    case Bandwidth
    case Device_banner
    case Device_block
    case Control_onoff
    case Control_add_device
    case Control_limit_time
    case Control_web_content

}


// MARK: -

protocol TrackingCondition {
    
    var key: String { get }
    var rawValue: String { get }
    
}

extension TrackingCondition {
    
    var key: String {
        return String(describing: type(of: self))
    }
    
    var params: [String : String] {
        return [key: rawValue]
    }
}
