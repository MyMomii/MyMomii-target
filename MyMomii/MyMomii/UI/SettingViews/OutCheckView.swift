//
//  OutCheckView.swift
//  AhnNyeong
//
//  Created by OhSuhyun on 2023.11.02.
//

import SwiftUI

struct OutCheckView: View {
    @Binding var selectedUserType: ContentView.LoginType
    @State var isCheckBtnPressed = false
    let isLogOut: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("CheckLogOut")
            Text(isLogOut ? "로그아웃 되었습니다.\n언제든 다시 돌아오세요!" : "계정이 삭제되었습니다.\n안녕히 가세요!")
                .semiBold20Coral500()
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            Spacer()
            Capsule()
                .frame(height: 60)
                .foregroundColor(.coral500)
                .shadow(color: .black500.opacity(0.15), radius: 4, x: 0, y: 4)
                .overlay {
                    Text("확인")
                        .bold18White50()
                }
                .padding(.bottom, 49)
                .onTapGesture {
                    selectedUserType = .notyet
                    isCheckBtnPressed = true
                }
        }
        .navigationDestination(isPresented: $isCheckBtnPressed) {
            LoginTypeView(selectedUserType: $selectedUserType).navigationBarBackButtonHidden(true)
        }
        .padding(.horizontal, 16)
        .background(Color.white300)
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    OutCheckView(isLogOut: true)
//}
