//
//  SettingGuideView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SettingGuideView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingViewTitle(settingViewTitle: "사용 가이드")
            ScrollView {
                if DeviceSize.width < DeviceSize.iPhone14 {
                    Image("iPhoneSEGuidingView")
                        .resizable()
                        .scaledToFill()
                } else {
                    Image("iPhone14GuidingView")
                        .resizable()
                        .scaledToFill()
                }
            }
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
