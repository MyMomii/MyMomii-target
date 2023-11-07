//
//  TargetMainView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI
import Lottie

struct TargetMainView: View {
    @State var startDefaultBtnClick = false
    @State var calendarBtnClick = false
    @State var toSympView = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("안녕하세요!")
                                .semiBold32Black400()
                            Text("이김생리님")
                                .heavy32Black400()
                        }
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                    Button(action: {
                        startDefaultBtnClick = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            toSympView = true
                        }
                    }, label: {
                        Image(startDefaultBtnClick ? "TargetDropPressed" : "TargetDrop")
                            .padding(.top, 63)
                    })
                    if startDefaultBtnClick {
                        Text("생리를 시작했어요!")
                            .bold30Coral500()
                            .padding(.top, 40)
                    } else {
                        Text("생리를 시작했나요?")
                            .bold30Black400()
                            .padding(.top, 40)
                    }
                    Button(action: {
                        calendarBtnClick = true
                    }, label: {
                        Text("\(Image(systemName: "calendar")) 달력 보기")
                            .bold22Coral400()
                            .padding(.init(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white).shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.15), radius: 4, x: 0, y: 4))
                    })
                    .padding(.top, 40)
                    Spacer()
                }
                .padding(EdgeInsets(top: 30, leading: 16, bottom: 30, trailing: 16))
                .navigationDestination(isPresented: $toSympView) {
                    SympView()
                }
                .navigationDestination(isPresented: $calendarBtnClick) {
                    TargetMainView()
                }
                .background(Color.white300)
                LottieView(animation: .named("Confetti_01"))
                    .resizable()
                    .configure { lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleToFill
                    }
                    .playing()
                    .ignoresSafeArea()

            }
        }
    }
}

#Preview {
    TargetMainView()
}
