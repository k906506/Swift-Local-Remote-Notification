//
//  AppDelegate.swift
//  Local-Remote-Notification
//
//  Created by 고도현 on 2023/03/31.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // ...
        return true
    }
}

// Foreground Notification을 위한 Delegate 채택
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.list, .banner, .sound, .badge]
    }
}
