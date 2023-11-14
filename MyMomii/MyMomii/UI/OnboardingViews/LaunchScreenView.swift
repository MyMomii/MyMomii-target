//
//  LaunchScreenView.swift
//  MyMomii
//
//  Created by qwd on 11/11/23.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.3
    
    var body: some View {
        if isActive {
            TargetMainView()
        } else {
            VStack(alignment: .center, spacing: 20) {
                Image("AppTitle")
                    .resizable()
                    .frame(width: 126, height: 55)
                Image("SMOnboarding")
                    .resizable()
                    .frame(width: 130, height: 214)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
                Text("마이모미와 함께 \n소중한 월경 주기를 관리해보아요")
                    .semiBold16White50()
                    .multilineTextAlignment(.center)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 1.2
                    self.opacity = 1.0
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.coral200)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }

    }
}

#Preview {
    LaunchScreenView()
}
