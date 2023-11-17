//
//  SettingNotiView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.

import SwiftUI

struct SettingNotiView: View {
    @State var isMensToday = true
//    @State var expect: String = "20231116"
    @Binding var eventsArray: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("알림을 받아요")
                    .bold28Black400()
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            DividingRectangle(dividingType: .naviTitleDivider)
            VStack(alignment: .leading, spacing: 0) {
                Text("알림을 키고 끌 수 있어요.")
                    .bold18Black400()
                    .padding(.top, 20)
                HStack(spacing: 0) {
                    Text("알림을 켜면 ")
                    Text("아침 9시")
                        .semiBold12Coral500()
                    Text("에 나에게 알려줘요.")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black300)
                .padding(.bottom, 20)
                VStack(spacing: 0) {
                    ToggleList(toggleTitle: "생리 시작 알림", toggleIsOn: $isMensToday)
                    
                    // MARK: - 뷰 연결되면 .onChange로 바꿀 예정 (eventsArray 받아올 예정 : 상단에 binding 확인 & text에 onTapGesture 삭제)
                        .onChange(of: eventsArray) { newValue in
                            if eventsArray.count > 0 { // 이벤트 어레이에 값이 들어오면, 스케쥴링 해버림 (그때 날짜는 제일 첫번째)
                                NotificationManager.instance.scheduleNotification(expectedDate: eventsArray[0])
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
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleImage, backButtonTitle: "gearshape.fill"))
        .background(Color.white300)
        .backGesture()
    }
}

#Preview {
    SettingNotiView(isMensToday: true, eventsArray: .constant([]))
}
