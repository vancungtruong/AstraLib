//
//  FirebaseTracking+Base.swift
//  AstraDemo
//
//  Created by cuong on 3/18/22.
//

import AstraLib

import FirebaseCore
import FirebaseAnalytics


extension FirebaseTracking {
    
    static func config() {
        FirebaseApp.configure()
    }
    
    static func trackEvent(_ name: String, parameters: TrackingParameters) {

        Analytics.logEvent(name, parameters: parameters)
    }
    
}
