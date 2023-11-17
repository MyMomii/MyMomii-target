//
//  LoadingView.swift
//  MyMomii
//
//  Created by OhSuhyun on 2023.11.16.
//

import SwiftUI

// 로딩이 필요한 화면의 최상위 StackView에 overlay로 적용하세요.
struct LoadingView: View {
    @State var opacity: CGFloat = 1.0
    var body: some View {
        Rectangle()
            .fill(Color.white300)
            .overlay {
                VStack(spacing: 0) {
                    Image("SMLoading")
                        .padding(.bottom, 16)
                    Text("잠시만 기다려 주세요!")
                        .semiBold16Coral500()
                }
                .padding(.bottom, 64)

            }
            .opacity(opacity)
            .animation(.easeInOut(duration: 0.5), value: opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    opacity = 0.0
                }
            }
    }
}

#Preview {
    LoadingView()
}
