//
//  SettingMainView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SettingMainView: View {
    let userName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("\(userName)님")
                    .bold28Black400()
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            DividingRectangle(dividingType: .naviTitleDivider)
            Group {
                NavigationLink(destination: SettingNotiView()) {
                    SettingList(listTitle: "알림 설정", listCaption: "알림 시간 설정 및 알람별 활성화 설정")
                }
                NavigationLink(destination: EmptyView()) {
                    SettingList(listTitle: "이름 수정", listCaption: "가입된 이름 수정")
                }
                NavigationLink(destination: SettingGuideView()) {
                    SettingList(listTitle: "사용 가이드", listCaption: "앱 사용 가이드")
                }
            }
            .padding(.leading, 16)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleImage, backButtonTitle: "calendar"))
        .background(Color.white300)
    }
}

#Preview {
    SettingMainView(userName: "이김생리")
}
