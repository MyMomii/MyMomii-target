//
//  SettingGuideView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SettingGuideView: View {
    @State var showAdminGuide = false
    @State var showTargetGuide = false
    let adminGuideTitle = "사회복지사 앱 사용 가이드"
    let targetGuideTitle = "이용자 앱 사용 가이드"
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingViewTitle(settingViewTitle: "사용 가이드")
            Group {
                ModalButton(showModal: $showAdminGuide, buttonTitle: adminGuideTitle)
                .sheet(isPresented: self.$showAdminGuide) {
                    EmptyView()
                }
                ModalButton(showModal: $showTargetGuide, buttonTitle: targetGuideTitle)
                .sheet(isPresented: self.$showTargetGuide) {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 0, trailing: 16))
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleImage, backButtonTitle: "gearshape.fill"))
        .background(Color.white300)
    }
}

#Preview {
    SettingGuideView()
}
