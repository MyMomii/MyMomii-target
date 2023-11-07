//
//  SettingNotiView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SettingNotiView: View {
    @State var isMensToday = false
    @State var isMensNotInit = false
    @State var isMensBeforeWeek = false
    @State var isOvulation = false
    @State var startTime = Date()
    @State var endTime = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingViewTitle(settingViewTitle: "알림 설정")
            
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
                    DividingRectangle(dividingType: .listDivider).padding(.leading, 16)
                    ToggleList(toggleTitle: "주기 미입력 알람", toggleIsOn: $isMensNotInit)
                    DividingRectangle(dividingType: .listDivider).padding(.leading, 16)
                    ToggleList(toggleTitle: "생리 7일 전", toggleIsOn: $isMensBeforeWeek)
                    DividingRectangle(dividingType: .listDivider).padding(.leading, 16)
                    ToggleList(toggleTitle: "배란일", toggleIsOn: $isOvulation)
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
            
            DividingRectangle(dividingType: .naviTitleDivider)
                .padding(.vertical, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                ListTitle(listTitle: "생리 현황 알림 시간 지정", listCaption: "생리 현황 알림을 받을 시간대를 설정할 수 있습니다. ")
                    .padding(.bottom, 20)
                VStack(spacing: 0) {
                    DatePickerList(datePickerTitle: "시작 시간", selection: $startTime)
                    DividingRectangle(dividingType: .listDivider).padding(.leading, 16)
                    DatePickerList(datePickerTitle: "종료 시간", selection: $endTime)
                }
                .font(.system(size: 16, weight: .medium))
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
