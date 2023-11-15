//
//  SettingNotiView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.

import SwiftUI

class NotificationManager {
    
    // singleton으로 만들어서 한 번에 관리
    static let instance = NotificationManager()
    
    // 알림 권한 Alert
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (success, error) in
                // 콘솔 확인용
                if let error = error {
                    print("ERROR: \(error)")
                } else {
                    print("SUCCESS")
                }
        }
    }

    // 오전 9시에 알림 보내기
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "생리 예정 알림"
        content.body = "오늘은 생리 예정일 입니다."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 40
        // MARK: - 생리 예정일 날짜 dateFormatter 필요
//        dateComponents.year =
//        dateComponents.month =
//        dateComponents.day =
        
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

struct SettingNotiView: View {
    @State var isMensToday = true
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("알림 설정")
                    .bold28Black400()
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            DividingRectangle(dividingType: .naviTitleDivider)
            VStack(alignment: .leading, spacing: 0) {
                Text("개별 알림 활성화")
                    .bold18Black400()
                    .padding(.top, 20)
                HStack(spacing: 0) {
                    Text("활성화된 알람은 ")
                    Text("오전 9시")
                        .semiBold12Coral500()
                    Text("에 일괄 전송됩니다.")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black300)
                .padding(.bottom, 20)
                VStack(spacing: 0) {
                    ToggleList(toggleTitle: "생리 예정 당일", toggleIsOn: $isMensToday)
                        .onChange(of: isMensToday) {
                            if isMensToday == true { // 토글 켜면, 노티피케이션 받을 수 있게 하고, 스케쥴링 해버림
                                NotificationManager.instance.scheduleNotification()
                            } else {
                                NotificationManager.instance.cancelNotification()
                            }
                        }
                }
                .font(.system(size: 16, weight: .medium))
                .toggleStyle(SwitchToggleStyle(tint: .coral500))
                .background {
                    Rectangle()
                        .foregroundColor(.white50)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
            Spacer()
        }
        .backGesture()
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleImage, backButtonTitle: "gearshape.fill"))
        .background(Color.white300)
    }
}

#Preview {
    SettingNotiView()
}
