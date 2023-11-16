//
//  OnboardingCarouselView.swift
//  MyMomii
//
//  Created by qwd on 11/13/23.
//

import FirebaseAuth
import SwiftUI
import Lottie

struct OnboardingCarouselView: View {
    var body: some View {
        CarouselView(imageNames: ["OnBoard_01","OnBoard_02","OnBoard_03" ])
//        CarouselView(lottieFileNames: ["Confetti_01", "Confetti_02", "Confetti_01"])
    }
}

struct CarouselView: View {
    var imageNames: [String]
    @State private var selectedImageIndex: Int = 0
    var isLastImage: Bool { 
        return selectedImageIndex == imageNames.count - 1
    }
    @State var goToMain = false
    @EnvironmentObject private var authModel: AuthViewModel
    @AppStorage("isOnBoarding") var isOnBoarding: Bool!
    @StateObject private var viewModel = AuthenticationViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        ZStack(alignment: .topLeading) {
                            if DeviceSize.width < DeviceSize.iPhone14 {
                                VStack {
                                    Image(imageNames[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 280, height: 418)
//                                        .border(Color.black)
//                                    LottieView(animation: .named(lottieFileNames[index]))
//                                        .resizable()
//                                        .configure { lottieAnimationView in
//                                            lottieAnimationView.loopMode = .loop
//                                            lottieAnimationView.contentMode = .scaleAspectFit
//                                            lottieAnimationView.animationSpeed = 1.0
//                                        }
//                                        .playing()
//                                        .frame(width: 280, height: 365)
//                                        .border(Color.black)
                                    if index == 0 {
                                        Text("생리를 시작했다면,")
                                            .regular23White300()
                                        Text("생리 정보를 입력하세요")
                                            .bold23White300()
                                    } else if index == 1 {
                                        Text("내 생리 증상을 선택하여")
                                            .regular23White300()
                                        Text("간편히 입력하세요")
                                            .bold23White300()
                                    } else {
                                        HStack(spacing: 0) {
                                            Text("달력에서")
                                                .regular23White300()
                                            Text(" 생리 예상 주기와")
                                                .bold23White300()
                                        }
                                        Text("과거 정보를 확인하세요")
                                            .bold23White300()
                                    }
                                }
                            } else {
                                VStack {
                                    Image(imageNames[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 300, height: 493)
//                                    LottieView(animation: .named(lottieFileNames[index]))
//                                        .resizable()
//                                        .configure { lottieAnimationView in
//                                            lottieAnimationView.loopMode = .loop
//                                            lottieAnimationView.contentMode = .scaleAspectFit
//                                            lottieAnimationView.animationSpeed = 1.0
//                                        }
//                                        .playing()
//                                        .frame(width: 300, height: 493)
//                                        .border(Color.black)
                                    if index == 0 {
                                        Text("생리를 시작했다면,")
                                            .regular23White300()
                                        Text("생리 정보를 입력하세요")
                                            .bold23White300()
                                    } else if index == 1 {
                                        Text("내 생리 증상을 선택하여")
                                            .regular23White300()
                                        Text("간편히 입력하세요")
                                            .bold23White300()
                                    } else {
                                        HStack(spacing: 0) {
                                            Text("달력에서")
                                                .regular23White300()
                                            Text(" 생리 예상 주기와")
                                                .bold23White300()
                                        }
                                        Text("과거 정보를 확인하세요")
                                            .bold23White300()
                                    }
                                }
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                Button(action: {
                    goToMain = true
                    isOnBoarding = false
                    Task {
                        do {
                            try await viewModel.signInAnonymous()
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    if DeviceSize.width < DeviceSize.iPhone14 {
                        Rectangle()
                            .frame(width: 288, height: 58)
                            .foregroundColor(isLastImage ? .white200 : .coral100)
                            .cornerRadius(61)
                            .overlay {
                                Text("시작하기")
                                    .bold18Coral500()
                            }
                    } else {
                        Rectangle()
                            .frame(width: 358, height: 58)
                            .foregroundColor(isLastImage ? .white200 : .coral100)
                            .cornerRadius(61)
                            .overlay {
                                Text("시작하기")
                                    .bold18Coral500()
                            }
                    }
                })
                .padding(.bottom, 20)
                .disabled(!isLastImage)
                .navigationDestination(isPresented: $goToMain) {
                    TargetMainView()
                }
            }
            .background(Color.coral200)
        }
    }
}

#Preview {
    OnboardingCarouselView()
}
