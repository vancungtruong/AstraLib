//
//  FirebaseTracking+Custom.swift
//  InAppPurchaseKit
//
//  Created by Cung Truong on 09/03/2022.
//

import AstraLib

enum FirebaseCustomEvent: String {
    
    // edit here
    case custom = "Custom"
    
    
    
    // MARK: - FirebaseEvent
    var name: String {
        return self.rawValue
    }
}

extension FirebaseTracking {
    
    // edit here

//    static func logCustomEvent() {
//
//        let params: FirebaseEventParameters = [
//            "key" : value
//        ]
//        FirebaseTracking.trackEvent(FirebaseCustomEvent.custom, parameters: params)
//    }

}
