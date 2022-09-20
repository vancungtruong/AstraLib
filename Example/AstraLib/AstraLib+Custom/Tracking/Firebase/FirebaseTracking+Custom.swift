//
//  FirebaseTracking+Custom.swift
//  InAppPurchaseKit
//
//  Created by Cung Truong on 09/03/2022.
//

import AstraLib

extension FirebaseTracking {

    static func trackCustomEvent() {

        let params: TrackingParameters = [
            "key" : "value"
        ]

        FirebaseTracking.trackEvent(.custom, parameters: params)
    }

    static func trackEnumEvent() {

        FirebaseTracking.trackEvent(.onboardingView(.Onboarding_1))
    }
    
}
