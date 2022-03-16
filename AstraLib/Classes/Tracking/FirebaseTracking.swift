//
//  FirebaseTracking.swift
//  MyCar
//
//  Created by An Thai on 12/31/21.
//  Copyright © 2021 Astraler. All rights reserved.
//

import FirebaseCore
import FirebaseAnalytics

public typealias FirebaseEventParameters = [String : Any]

public class FirebaseTracking {
    
    public static func config() {
        FirebaseApp.configure()
    }
    
    public static func trackEvent(_ name: String, parameters: FirebaseEventParameters) {
        
        Analytics.logEvent(name, parameters: parameters)
    }
    
}
