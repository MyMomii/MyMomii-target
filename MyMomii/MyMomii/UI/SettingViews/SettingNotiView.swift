//
//  SettingNotiView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SettingNotiView: View {
    @State var isMensToday = false
    
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

