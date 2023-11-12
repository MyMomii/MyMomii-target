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
                        //                    ZStack {
                        //                        Image("\(imageNames[index])")
                        //                            .resizable()
                        //                            .tag(index)
                        //                            .frame(width: 300, height: 560)
                        //                    }
                        //                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        Rectangle()
                            .frame(width: 340, height: 560)
                            .cornerRadius(20)
                            .overlay {
                                Image("\(imageNames[index])")
                                    .resizable()
                                    .tag(index)
                                    .frame(width: 350, height: 560)
                            }
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                HStack {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        Circle()
                            .fill(Color.white.opacity(selectedImageIndex == index ? 1 : 0.33))
                            .frame(width: 16, height: 8)
                            .onTapGesture {
                                selectedImageIndex = index
                            }
                    }
                }
                Button(action: {
                    goToMain = true
                }, label: {
                    Rectangle()
                        .frame(width: 358, height: 58)
                        .foregroundColor(isLastImage ? .white200: .coral100)
                        .cornerRadius(61)
                        .overlay {
                            Text("시작하기")
                                .bold18Coral500()
                        }
                })
                .padding(.vertical, 10)
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
