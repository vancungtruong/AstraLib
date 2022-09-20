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
    
    static func trackEvent(_ name: TrackingEvent.Name, parameters: TrackingParameters) {

        Analytics.logEvent(name.rawValue, parameters: parameters)
    }
    
    static func trackEvent(_ event: TrackingEvent) {
        
        Analytics.logEvent(event.name.rawValue, parameters: event.params)
        
        #if DEBUG
        print("firebase track event: \(event.name) -> ", event.params)
        #endif
    }
    
}
