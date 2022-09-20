//
//  AppDelegate+RemoteNotification.swift
//  AstraLib_Example
//
//  Created by cuong on 3/17/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import AstraLib


extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        #if DEBUG
        print("APNs device token: \(token)")
        #endif
        
        RemoteNotificationRegister.shared.deviceTokenHanlder?(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        #if DEBUG
        print("APNs registration failed: \(error)")
        #endif
        
        RemoteNotificationRegister.shared.failToRegisterHanlder?(error)
    }
    
}
