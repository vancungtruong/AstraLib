//
//  RemoteNotificationRegister.swift
//  Kikki
//
//  Created by cuong on 8/14/20.
//  Copyright © 2020 astraler. All rights reserved.
//

import UIKit
import UserNotifications

public class RemoteNotificationRegister {
    
    public static let shared = RemoteNotificationRegister()
    
    public var deviceTokenHanlder: ((String) -> Void)?
    public var failToRegisterHanlder: ((Error?) -> Void)?
    
    public func configure(options: UNAuthorizationOptions = [.badge, .alert, .sound], delegate: UNUserNotificationCenterDelegate?) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: options) { (granted, error) in
            #if DEBUG
            if let error = error {
                print("user notification error -> ", error)
            } else {
                print("user notification granted -> ", granted)
            }
            #endif
        }
        center.delegate = delegate
        UIApplication.shared.registerForRemoteNotifications()
    }

}
