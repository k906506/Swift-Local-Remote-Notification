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
            let url = URL(string: Constants.NAVIGATION_ROUTER_IN_ACTIVE)!
            await UIApplication.shared.open(url)
            
            // TODO: background도 URL Scheme으로 전달할 수 있나? -> Remote Notification에서 테스트 해봐야할 듯
            case .background:
            let url = URL(string: Constants.NAVIGATION_ROUTER_IN_BACKGROUND)!
            await UIApplication.shared.open(url)
            
        @unknown default:
            fatalError()
        }
    }
}
