//
//  SettingMainView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SettingMainView: View {
    @Binding var selectedUserType: ContentView.LoginType
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    @State private var naviToOutCheckView = false
    let userName: String    // not completed
    let mngNm: String = "이선생"   // sample
    let instNm: String = "복지센터" // sample
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                Text(selectedUserType == .mng ? "\(userName) 사회복지사님" : "\(userName) 님")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black500)
                    .padding(.top, 20)
                HStack(spacing: 0) {
                    Image(systemName: selectedUserType == .mng ? "checkmark.seal.fill" : "person.2.fill")
                    Text(selectedUserType == .mng ? " 기관(\(instNm)) 인증됨" : " \(instNm) / \(mngNm) 사회복지사님")
                }
                .font(.system(size: 12, weight: .light))
                .foregroundColor(Color.white50)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(.coral300)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 16)
            DividingRectangle(dividingType: .naviTitleDivider)
                .padding(.top, 20)
                VStack(alignment: .center, spacing: 0) {
                    NavigationLink(destination: SettingNotiView()) {
                        SettingList(listTitle: "알림 설정", listCaption: "알림 시간 설정 및 알람별 활성화 설정")
                    }
                    NavigationLink(destination: EmptyView()) {  // not completed
                        SettingList(listTitle: "글자 크기 설정", listCaption: "앱 내 글자 크기 설정")
                    }
                    NavigationLink(destination: EmptyView()) {  // not completed
                        SettingList(listTitle: "이름 수정", listCaption: "가입된 이름 수정")
                    }
                    NavigationLink(destination: SettingGuideView()) {
                        SettingList(listTitle: "사용 가이드", listCaption: "앱 사용 가이드")
                    }
                    NavigationLink(destination: SettingTermView()) {
                        SettingList(listTitle: "서비스 약관", listCaption: "개인정보처리방침 및 서비스 이용약관")
                    }
                }
                .padding(.leading, 16)
            HStack(alignment: .center) {
                Spacer()
                Text("로그아웃")
                    .foregroundColor(.coral500)
                    .onTapGesture {
                        showLogoutAlert = true
                    }
                    .alert(isPresented: $showLogoutAlert) {
                        Alert(
                            title: Text("로그아웃"),
                            message: Text("로그인 후 언제든 다시 접속할 수 있습니다. \n계정을 지우려면 ‘계정 삭제’를 눌러주세요."),
                            primaryButton: .destructive(Text("확인"), action: {   // not completed
                                // 여기에서 로그아웃 작업을 수행하십시오.
                                self.naviToOutCheckView = true
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                Spacer()
                Text("계정삭제")
                    .foregroundColor(.black75)
                    .onTapGesture {
                        showDeleteAlert = true
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("계정을 삭제합니다"),
                                message: Text("계정을 삭제하면 이용자와 연결이 끊어지고 \n더 이상 정보에 접근할 수 없게 됩니다."),
                                primaryButton: .destructive(Text("삭제"), action: {   // not completed
                                // 여기에서 계정 삭제 작업을 수행하십시오.
                                    self.naviToOutCheckView = true
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                Spacer()
                Text("문의하기")
                    .foregroundColor(.black75)
                Spacer()
            }
            .underline()
            .listRowSeparator(.hidden)
            .padding(.top, 30)
            Spacer()
        }
        .navigationDestination(isPresented: $naviToOutCheckView) {
            OutCheckView(selectedUserType: $selectedUserType, isLogOut: true)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleText, backButtonTitle: "뒤로"))
        .background(Color.white300)
    }
}

//#Preview {
//    SettingMainView()
//}
