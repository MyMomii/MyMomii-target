////
////  Test.swift
////  MyMomii
////
////  Created by qwd on 11/15/23.
////
//
//import SwiftUI
//import UserNotifications
//
//struct Test: View {
//    @State private var isMensToday = true
//
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Text("알림 설정")
//                    .bold28Black400()
//                Spacer()
//            }
//            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
//            DividingRectangle(dividingType: .naviTitleDivider)
//            VStack(spacing: 0) {
//                ToggleList(toggleTitle: "생리 예정 당일", toggleIsOn: $isMensToday)
//            }
//            .font(.system(size: 16, weight: .medium))
//            .toggleStyle(SwitchToggleStyle(tint: .coral500))
//            .background {
//                Rectangle()
//                    .foregroundColor(.white50)
//                    .cornerRadius(10)
//            }
//        }
//        Spacer()
//        .padding(.horizontal, 16)
//        .onAppear {
//            requestNotificationAuthorization()
//        }
//    }
//
//    private func requestNotificationAuthorization() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
//            (success, error) in
//                // 콘솔 확인용
//                if let error = error {
//                    print("ERROR: \(error)")
//                } else {
//                    print("SUCCESS")
//                }
//        }
//    }
//
//    // 9시에 알림 보내기
//    private func scheduleNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "생리 예정 알림"
//        content.body = "오늘은 생리 예정일입니다."
//
//        var dateComponents = DateComponents()
//        dateComponents.hour = 9
//        dateComponents.minute = 0
//        dateComponents.year = 2023
//        dateComponents.month = 11
//        dateComponents.day = 15
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let request = UNNotificationRequest(identifier: "DailyNotification", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error.localizedDescription)")
//            } else {
//                print("Notification scheduled successfully")
//            }
//        }
//    }
//
//    // Cancel a scheduled notification
//    private func cancelNotification() {
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["DailyNotification"])
//    }
//}
//
//#Preview {
//    Test()
//}
