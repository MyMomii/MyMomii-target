//
//  OnboardingCarouselView.swift
//  MyMomii
//
//  Created by qwd on 11/13/23.
//

import FirebaseAuth
import SwiftUI

struct OnboardingCarouselView: View {
    var body: some View {
        CarouselView(imageNames: ["OnBoard_01", "OnBoard_02", "OnBoard_03"])
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
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        ZStack(alignment: .topLeading) {
                            if DeviceSize.width < DeviceSize.iPhone14 {
                                VStack {
                                    Image("\(imageNames[index])")
                                        .resizable()
                                        .tag(index)
                                        .frame(width: 280, height: 365)
                                    if index == 0 {
                                        Text("생리를 시작했다면,")
                                            .regular23White300()
                                        Text("생리 정보를 입력하세요")
                                            .medium23White300()
                                    } else if index == 1 {
                                        Text("내 생리 증상을 선택하여")
                                            .regular23White300()
                                        Text("간편히 입력하세요")
                                            .medium23White300()
                                    } else {
                                        Text("달력에서 생리 예상 주기와")
                                            .regular23White300()
                                        Text("과거 정보를 확인하세요")
                                            .medium23White300()
                                    }
                                }
                            } else {
                                VStack {
                                    Image("\(imageNames[index])")
                                        .resizable()
                                        .scaledToFill()
                                        .tag(index)
                                        .frame(width: 300, height: 493)
                                    if index == 0 {
                                        Text("생리를 시작했다면,")
                                            .regular23White300()
                                        Text("생리 정보를 입력하세요")
                                            .medium23White300()
                                    } else if index == 1 {
                                        Text("내 생리 증상을 선택하여")
                                            .regular23White300()
                                        Text("간편히 입력하세요")
                                            .medium23White300()
                                    } else {
                                        Text("달력에서 생리 예상 주기와")
                                            .regular23White300()
                                        Text("과거 정보를 확인하세요")
                                            .medium23White300()
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
//                    authModel.signInAnonymously()
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
