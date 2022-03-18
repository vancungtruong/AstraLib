//
//  DefaultNotificationHanlder.swift
//  PushNotificationLib
//
//  Created by Cung Truong on 23/02/2022.
//

import UserNotifications

public extension NSNotification.Name {
    static let didReceiveDefaultNotification = NSNotification.Name("DidReceiveDefaultNotification")
}

public class DefaultNotificationHanlder: NSObject {
    
    public var presentOptions: UNNotificationPresentationOptions = []
    
    public var notificationHandler: (([AnyHashable : Any]) -> Void)?
    
    public override init() {
        super.init()
        if #available(iOS 14.0, *) {
            presentOptions = [.banner, .sound]
        } else {
            presentOptions = [.alert, .sound]
        }
    }
    
    public init(options: UNNotificationPresentationOptions) {
        self.presentOptions = options
    }
    
}

// MARK: - UNUserNotificationCenterDelegate

extension DefaultNotificationHanlder: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        #if DEBUG
        print("userInfo -> ", userInfo)
        #endif
        
        NotificationCenter.default.post(name: .didReceiveDefaultNotification, object: nil, userInfo: userInfo)
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        #if DEBUG
        print("userInfo -> ", userInfo)
        #endif
        
        notificationHandler?(userInfo)
        NotificationCenter.default.post(name: .didReceiveDefaultNotification, object: nil, userInfo: userInfo)
        
        completionHandler()
    }
}
