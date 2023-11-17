//
//  SettingMainView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SettingMainView: View {
    @Binding var eventsArray: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("설정")
                    .bold28Black400()
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            DividingRectangle(dividingType: .naviTitleDivider)
            Group {
                NavigationLink(destination: SettingNotiView(isMensToday: true, eventsArray: $eventsArray)) {
                    SettingList(listTitle: "알림을 받아요. ", listCaption: "마이모미에게 생리 시작 알림을 받을 수 있어요.")
                }
                NavigationLink(destination: SettingGuideView()) {
                    SettingList(listTitle: "어떻게 쓰나요?", listCaption: "마이모미 사용 방법을 알 수 있어요.")
                }
            }
            .padding(.leading, 16)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleImage, backButtonTitle: ""))
        .background(Color.white300)
        .backGesture()
    }
}

#Preview {
    SettingMainView(eventsArray: .constant([]))
}
