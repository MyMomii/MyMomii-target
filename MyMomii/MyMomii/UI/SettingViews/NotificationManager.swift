//
//  NotificationManager.swift
//  MyMomii
//
//  Created by qwd on 11/15/23.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    // singleton으로 만들어서 한 번에 관리
    static let instance = NotificationManager()
    
    // 알림 권한 Alert
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (success, error) in
            // 콘솔 확인용
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SUCCESS")
            }
        }
    }

    // 오전 9시에 알림 보내기
    func scheduleNotification(expectedDate: String) {
        let content = UNMutableNotificationContent()
        
        content.title = "마이모미"
        content.subtitle = "생리 시작 알림"
        content.body = "오늘 생리가 시작돼요."
        content.sound = .default

        // MARK: - date로 푸시알림 받기
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        dateComponents.year = Int(String(expectedDate.prefix(4)))
        dateComponents.month = Int(String(expectedDate.dropFirst(4).prefix(2)))
        dateComponents.day = Int(String(expectedDate.dropFirst(6).prefix(2)))

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger) // trigger는 3가지 방법 가능 (time, calendar, location)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("SUCCESS")
            }
        }
    }

    // 알림 취소 & 한 번 본 알람 자동 삭제
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
