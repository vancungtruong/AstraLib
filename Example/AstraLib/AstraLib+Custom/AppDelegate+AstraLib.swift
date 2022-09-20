//
//  AppDelegate+AstraLib.swift
//  AstraDemo
//
//  Created by Cung Truong on 20/03/2022.
//

import AstraLib

extension AppDelegate {
    
    func setupAstraLib(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        PurchaseKit.config()
        AdjustTracking.config(appToken: AdjustToken.appToken)
        FacebookTracking.config(application: application, launchOptions: launchOptions)
        FirebaseTracking.config()
        setupRemoteNotification()
    }
    
    private func setupRemoteNotification() {
        
        let notificationDelegate = DefaultNotificationHanlder()
        notificationDelegate.notificationHandler = { userInfo in
            
        }
        RemoteNotificationRegister.shared.configure(delegate: notificationDelegate)
        RemoteNotificationRegister.shared.deviceTokenHanlder = { deviceToken in
            // save deviceToken & call api
        }
        RemoteNotificationRegister.shared.failToRegisterHanlder = { error in
            // handle error deviceToken
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FacebookTracking.application(app, open: url, options: options)
    }
    
}
