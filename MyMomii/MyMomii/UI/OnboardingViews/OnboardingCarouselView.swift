//
//  OnboardingCarouselView.swift
//  MyMomii
//
//  Created by qwd on 11/13/23.
//

import SwiftUI

struct OnboardingCarouselView: View {
    var body: some View {
        CarouselView(imageNames: ["mount1", "mount2", "mount3"])
    }
}

struct CarouselView: View {
    var imageNames: [String]
    @State private var selectedImageIndex: Int = 0
    var isLastImage: Bool {
        return selectedImageIndex == imageNames.count - 1
    }
    @State var goToMain = false
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        ZStack(alignment: .topLeading) {
                            if DeviceSize.width < DeviceSize.iPhone14 {
                                Image("\(imageNames[index])")
                                    .resizable()
                                    .tag(index)
                                    .frame(width: 280, height: 365)
                            } else {
                                Image("\(imageNames[index])")
                                    .resizable()
                                    .tag(index)
                                    .frame(width: 340, height: 560)
                            }
                        }
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                Button(action: {
                    goToMain = true
                }, label: {
                    if DeviceSize.width < DeviceSize.iPhone14 {
                        Rectangle()
                            .frame(width: 288, height: 58)
                            .foregroundColor(isLastImage ? .white200: .coral100)
                            .cornerRadius(61)
                            .overlay {
                                Text("시작하기")
                                    .bold18Coral500()
                            }
                    } else {
                        Rectangle()
                            .frame(width: 358, height: 58)
                            .foregroundColor(isLastImage ? .white200: .coral100)
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
