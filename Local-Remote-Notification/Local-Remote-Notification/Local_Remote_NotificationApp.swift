//
//  Local_Remote_NotificationApp.swift
//  Local-Remote-Notification
//
//  Created by 고도현 on 2023/03/31.
//

import SwiftUI

public enum NavigationRouter: String {
    case normal = "Normal"
    case notification = "Notification"
}

@main
struct Local_Remote_NotificationApp: App {
    @UIApplicationDelegateAdaptor var delegate : AppDelegate
    
    @State private var navigationRouter: NavigationRouter = .normal
    
    // MARK: AppDelegate에서 진행해도 되는데, App 단에서 하는게 SwiftUI스러워서 일단 여기서 진행
    init() {
        configureNotification()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(navigationRouter: $navigationRouter)
                // 전달 받은 URL scheme에 따라 다른 뷰로 이동하도록 routerType 전달
                .onOpenURL(perform: { url in
                    if url.absoluteString == "Local-Remote-Notification://active" {
                        navigationRouter = .notification
                    }
                })
        }
    }
    
    private func configureNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Foreground Notification을 위한 delegate 채택
        notificationCenter.delegate = delegate.self
        
        // 1. 유저에게 권한을 요청 (이전에 권한 요청에 대한 응답을 하지 않았더라도 호출)
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
                print(error.localizedDescription)
            }
            
            // Enable or disable features based on the authorization.
        }
    }
}
