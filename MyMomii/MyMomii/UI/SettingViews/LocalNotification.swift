////
////  LocalNotification.swift
////  MyMomii
////
////  Created by qwd on 11/15/23.
////
//
//import SwiftUI
//import UserNotifications
//
//class NotificationManager {
//    
//    // singleton으로 만들어서 한 번에 관리
//    static let instance = NotificationManager()
//    
//    // 앱 다운로드 받고 버튼 클릭 시 바로 권한 묻기
//    func requestQuthorization() {
//        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
//            // 콘솔 확인용
//            if let error = error {
//                print("ERROR: \(error)")
//            } else {
//                print("SUCCESS")
//            }
//        }
//    }
//    
//    // 날짜 스케쥴링 되어 있는 경우에 notification 받도록 하기
//    func scheduleNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "notification!"
//        content.subtitle = "hi there"
//        content.sound = .default
//        content.badge = 1
//        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 16
//        dateComponents.minute = 14
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) // true로 해두면, 매일 오전 9시에 알람이 온다
//        
//        let request = UNNotificationRequest(
//            identifier: UUID().uuidString,
//            content: content,
//            trigger: trigger) // 트리거는 3가지 방법 받을 수 있음( time, calendar, location)
//        UNUserNotificationCenter.current().add(request)
//    }
//    
//    // 알람 취소 & 한 번 본 알람 자동 삭제
//    func cancleNotification() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//    }
//}
// 
//struct LocalNotification: View {
//    var body: some View {
//        VStack(spacing: 30) {
//            Button("here") {
//                NotificationManager.instance.requestQuthorization()
//            }
//            Button("scheduled") {
//                NotificationManager.instance.scheduleNotification()
//            }
//            Button("cancel") {
//                NotificationManager.instance.cancleNotification()
//            }
//        }
//    }
//}
//
//#Preview {
//    LocalNotification()
//}
