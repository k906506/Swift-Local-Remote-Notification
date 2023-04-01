//
//  ContentView.swift
//  Local-Remote-Notification
//
//  Created by 고도현 on 2023/03/31.
//

import SwiftUI


struct ContentView: View {
    @State private var notificationIndex = 0
    
    @Binding var navigationRouter: NavigationRouter
    
    var body: some View {
        VStack {
            Spacer()
            
            // MARK: routerType에 따라 다른 뷰가 보여지도록 구현
            switch navigationRouter {
                
            case .normal:
                Button(action: {
                    requestNotification()
                }) {
                    Text("즉시 알림 요청")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.red)
                
                Button(action: {
                    requestNotification(false)
                }) {
                    Text("3초 뒤, 알림 요청")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.blue)
                
            case .active:
                Text("Active 상태에서 알림으로 들어옴")
                    .font(.title2)
                
            case .background:
                Text("Background 상태에서 알림으로 들어옴")
                    .font(.title2)
                
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func requestNotification(_ immediate: Bool = true) {
        let content = UNMutableNotificationContent()
        content.title = immediate ? "즉시 알림" : "3초 뒤 알림"
        content.body = "안녕하세요, 알림입니다."
        content.sound = .default
        content.badge = 1
        
        let request = UNNotificationRequest(
            identifier: "\(notificationIndex)", // 말 그대로 식별자, 이미 존재하는 식별자인 경우에는 Queue에 남아있는 Notification을 대체한다.
            content: content,
            trigger: immediate ? nil : UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false) // 언제 Trigger 할 지에 대한 속성으로, nil로 설정하면 즉시 Notification을 Trigger
        )
        
        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error else { return }
                print(error.localizedDescription)
            }
        
        notificationIndex += 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(navigationRouter: .constant(NavigationRouter.normal))
    }
}
