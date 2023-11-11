//
//  OnboardingView.swift
//  MyMomii
//
//  Created by qwd on 11/11/23.
//

import SwiftUI

struct OnboardingView: View {
    @State var tag: Int? = nil
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center, spacing: 20) {
                    Image("AppTitle")
                        .resizable()
                        .frame(width: 126, height: 55)
                    Image("SMOnboarding")
                        .resizable()
                        .frame(width: 130, height: 213.69817)
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
                    Text("마이모미와 함께 \n소중한 월경 주기를 관리해보아요")
                        .semiBold16White50()
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Button(action: {
                    //누르면 LoginView로 넘어감
                    self.tag = 1
                }, label: {
                    Rectangle()
                        .frame(width: 361, height: 58)
                        .cornerRadius(61)
                        .foregroundColor(.white300)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 4)
                        .overlay {
                            Text("시작하기")
                                .bold18Coral500()
                                .multilineTextAlignment(.center)
                        }
                })
                .padding(.bottom, 70)
            }
            .background(Color.coral300)
//            .ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView()
}
