//
//  OnboardingView.swift
//  MyMomii
//
//  Created by qwd on 11/11/23.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
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
        }
        .background(Color.coral300)
    }
}

#Preview {
    OnboardingView()
}
