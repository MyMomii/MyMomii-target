//
//  DetailTermView.swift
//  AhnNyeong
//
//  Created by OhSuhyun on 2023.11.02.
//

import SwiftUI

struct DetailTermView: View {
    let viewTitle: String
    let termImg: String
    var body: some View {
        VStack(spacing: 0) {
            DividingRectangle(dividingType: .naviTitleDivider)
            ScrollView {
                Image(systemName: termImg)  // not completed
                    .resizable()
                    .frame(height: 1500)
            }
        }
        .navigationTitle(viewTitle)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleImage, backButtonTitle: ""))
        .background(Color.white300)
    }
}

#Preview {
    DetailTermView(viewTitle: "약관 상세", termImg: "scribble")
}
