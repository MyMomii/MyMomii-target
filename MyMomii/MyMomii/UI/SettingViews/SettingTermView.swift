//
//  SettingTermView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SettingTermView: View {
    let termTitle1 = "(필수) 이용약관 및 정보 수집/이용"
    let termTitle2 = "(필수) 민감정보 수집/이용"
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingViewTitle(settingViewTitle: "서비스 약관")
            Group {
                NavigationLink(destination: DetailTermView(viewTitle: termTitle1, termImg: "scribble")) {  // not completed
                    TermList(termTitle: termTitle1)
                }
                DividingRectangle(dividingType: .listDivider)
                NavigationLink(destination: DetailTermView(viewTitle: termTitle2, termImg: "scribble.variable")) {  // not completed
                    TermList(termTitle: termTitle2)
                }
            }
            .padding(.leading, 16)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleImage, backButtonTitle: "gearshape.fill"))
        .background(Color.white300)
    }
}

#Preview {
    SettingTermView()
}
