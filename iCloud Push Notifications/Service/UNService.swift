//
//  UNService.swift
//  iCloud Push Notifications
//
//  Created by Anya on 03.08.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    private override init() {}
    
    static var shared = UNService()
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options = UNAuthorizationOptions([.alert, .sound, .badge])
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "No error when requesting authorization")
            guard granted else {return}
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
    
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Did receive notifications")
        CKService.shared.handleNotification(with: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        CKService.shared.handleNotification(with: notification.request.content.userInfo)
        print("Body: ", notification.request.content.body)
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
