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
    @State var isLottieViewDone = false
    @State var selectedDate = Date()
    @AppStorage("isOnBoarding") var isOnBoarding: Bool = true
    @AppStorage("eventsArrayFirst") var eventsArrayFirst: String = "00000000"
    @AppStorage("eventsArrayDoneLast") var eventsArrayDoneLast: String = "00000000"
    @State var dDayTitle: String = "생리 정보를 입력해주세요"
    @State var dDay: Int = 9999

    var body: some View {
        if isOnBoarding {
            OnboardingCarouselView()
                .onAppear()
        } else {
            NavigationStack {
                ZStack {
                    VStack(spacing: 0) {
                        HStack {
                            Text("\(dDayTitle)")
                                .bold32Coral400()
                                .padding(EdgeInsets(top: 16, leading: 8, bottom: 32, trailing: 8))
                                .onAppear {
                                    if eventsArrayFirst != "00000000" || eventsArrayDoneLast != "00000000" {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                            let eventsArray: [String] = [eventsArrayFirst]
                                            let eventsArrayDone: [String] = [eventsArrayDoneLast]
                                            dDay = calculateDDay(eventsArray: eventsArray, eventsArrayDone: eventsArrayDone) + 1
                                            dDayTitle = dDayToTitle(dDay: dDay)
                                        }
                                    }
                                }
                            Spacer()
                        }
                        Spacer()
                        Button(action: {
                            startDefaultBtnClick = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                toSympView = true
                            }
                        }, label: {
                            Image(startDefaultBtnClick ? "TargetDropPressed" : "TargetDrop")
                        })
                        Spacer()
                        if startDefaultBtnClick {
                            Text("생리를 시작했어요!")
                                .bold30Coral500()
                                .padding(.top, 40)
                        } else {
                            Text("생리를 시작했나요?")
                                .bold30Black400()
                                .padding(.top, 40)
                        }
                        Spacer()
                        Button(action: {
                            calendarBtnClick = true
                        }, label: {
                            Text("\(Image(systemName: "calendar")) 달력 보기")
                                .bold22Coral400()
                                .padding(.init(top: 10, leading: 15, bottom: 10, trailing: 15))
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white).shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.15), radius: 4, x: 0, y: 4))
                        })
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 30, leading: 16, bottom: 30, trailing: 16))
                    .navigationDestination(isPresented: $toSympView) {
                        SympView(selectedDate: $selectedDate)
                    }
                    .navigationDestination(isPresented: $calendarBtnClick) {
                        TargetCalView()
                    }
                    .background(Color.white300)
                    .onDisappear {
                        startDefaultBtnClick = false
                    }
                    .zIndex(isLottieViewDone ? 9 : 0)
                    LottieView(animation: .named("Confetti_01"))
                        .resizable()
                        .configure { lottieAnimationView in
                            lottieAnimationView.contentMode = .scaleAspectFill
                            lottieAnimationView.animationSpeed = 1.5
                        }
                        .playing()
                        .animationDidFinish { _ in
                            self.isLottieViewDone = true
                        }
                        .ignoresSafeArea()
                }
            }
            .onAppear {
                NotificationManager.instance.requestNotificationAuthorization()
            }
            .navigationBarBackButtonHidden()

        }
    }

    func dDayToTitle(dDay: Int) -> String {
        if dDay == 9999 {    // 디데이 값 이상
            return " "
        } else if dDay > 900 {    // 생리 시작 3일 이내
            return "생리 시작 \(-(dDay-1000)+1)일차"
        } else if dDay > 0 {    // 생리 예정일 전
            return "생리 시작 \(dDay)일 전"
        } else if dDay < 0 {    // 생리 예정일 지남
            return "생리 예정일 \(-1*dDay)일 지남"
        } else {  // 생리 예정일 당일 또는 생리 정보 입력 당일
            return "오늘 생리 시작!"
        }
    }

    func calculateDDay(eventsArray: [String], eventsArrayDone: [String]) -> Int {
        if eventsArray==[] || eventsArrayDone==[] {
            return 9999
        }

        let afterToToday = eventsArray.first?.toDate()
        let gapAfterToToday = Calendar.current.dateComponents([.day], from: Date(), to: afterToToday!).day
        let beforeToToday = eventsArrayDone.last?.toDate()
        let gapBeforeToToday = Calendar.current.dateComponents([.day], from: Date(), to: beforeToToday!).day

        var dDayCode = 0
        if gapBeforeToToday! > -2 && gapBeforeToToday! < 0 {   // 생리 시작 3일 이내
            dDayCode = gapBeforeToToday!+1000
        } else if gapAfterToToday! > 0 {    // 생리 예정일 전
            dDayCode = gapAfterToToday!
        } else if gapAfterToToday! < 0 { // 생리 예정일 지남
            dDayCode = gapAfterToToday!
        } else if gapAfterToToday == 0 {  // 생리 예정일 당일
            dDayCode = gapAfterToToday!
        } else if gapBeforeToToday == 0 {  // 생리 정보 입력 당일
            dDayCode = gapBeforeToToday!
        } else {    // dDay 이상 있음
            dDayCode = 9999
        }

        return dDayCode
    }
}

#Preview {
    TargetMainView()
}
