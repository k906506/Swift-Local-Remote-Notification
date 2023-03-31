//
//  AppDelegate.swift
//  Local-Remote-Notification
//
//  Created by 고도현 on 2023/03/31.
//

import Combine
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
        [.badge, .banner, .list, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let notificationTitle = response.notification.request.content.title

        switch UIApplication.shared.applicationState {
            
        case .active, .inactive:
            // URL Scheme으로 App 단으로 이벤트 전달
            let url = URL(string: "Local-Remote-Notification://active")!
            await UIApplication.shared.open(url)
            
            // TODO: background도 URL Scheme으로 전달할 수 있나?
            // case .background:
            
        @unknown default:
            fatalError()
        }
    }
}
