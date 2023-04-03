//
//  AppDelegate.swift
//  Local-Remote-Notification
//
//  Created by 고도현 on 2023/03/31.
//

import Combine
import FirebaseCore
import FirebaseMessaging
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Firebase init
        FirebaseApp.configure()
        
        // FCM 테스트를 위한 delegate 채택
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // apnsToken에 deviceToken 전달
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        // FirebaseManager.shared.sendDeviceToken(deviceToken: deviceToken) // 서버에 DeviceToken 저장
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

extension AppDelegate: MessagingDelegate {
    // FCM 테스트를 위해 FCM Token를 가져오는 메서드
    // Firebase Function을 사용하기 위해선 FCMToken을 서버에 저장, FCMToken을 활용해서 FCM을 진행
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let firebaseToken = fcmToken ?? ""
        print("firebase token: \(firebaseToken)")
        
        FirebaseManager.shared.sendDeviceToken(deviceToken: firebaseToken) // 서버에 DeviceToken 저장
    }
}
