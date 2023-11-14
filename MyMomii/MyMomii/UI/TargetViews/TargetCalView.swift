//
//  TargetCalView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct TargetCalView: View {
    @State private var selectedDate: Date = .now
    @State private var calendarHeight: CGFloat = 600.0
    @State private var eventsArray: [Date] = []
    @State private var eventsArrayDone: [Date] = []
    @State private var calendarTitle: String = ""
    @State private var changePage: Int = 0
    var dDay: Int
    var dDayTitle: String {
        if dDay == 0 {
            return "오늘 생리 시작!"
        } else if dDay > 0 {
            return "생리 시작 \(dDay)일 전"
        } else {
            return "생리 \(dDay+1)일째"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(dDayTitle)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.coral400)
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 32, trailing: 8))
            CalendarRect(selectedDate: $selectedDate, calendarHeight: $calendarHeight, eventsArray: $eventsArray, eventsArrayDone: $eventsArrayDone, calendarTitle: $calendarTitle, changePage: $changePage)
                .frame(height: 600)
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.white300)
    }
}

// MARK: - 캘린더 박스
struct CalendarRect: View {
    @Binding var selectedDate: Date
    @Binding var calendarHeight: CGFloat
    @Binding var eventsArray: [Date]
    @Binding var eventsArrayDone: [Date]
    @Binding var calendarTitle: String
    @Binding var changePage: Int
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .cornerRadius(10)
                    .foregroundColor(Color.white50)
                    .shadow(color: .black500.opacity(0.15), radius: 3.5, x: 0, y: 2)
                    .frame(height: eventsArrayDone.contains(selectedDate) ? 580 : 400)
                    .overlay {
                        // Header
                        VStack(spacing: 0) {
                            CalendarHeader(calendarTitle: $calendarTitle, changePage: $changePage)
                                .padding(EdgeInsets(top: 24, leading: 16, bottom: 16, trailing: 16))
                            Spacer()
                        }
                    }
                Spacer()
            }
            .frame(height: 600)
            TargetCalViewRepresentable(selectedDate: $selectedDate, calendarHeight: $calendarHeight, eventsArray: $eventsArray, eventsArrayDone: $eventsArrayDone, calendarTitle: $calendarTitle, changePage: $changePage)
                .frame(height: 600)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
                .offset(y: 70)
            MensDataRect(selectedDate: $selectedDate, eventsArrayDone: $eventsArrayDone)
                .padding(EdgeInsets(top: 200, leading: 16, bottom: 16, trailing: 16))
        }
    }
}

// MARK: - 캘린더 타이틀 및 이전/다음 이동 버튼
struct CalendarHeader: View {
    @Binding var calendarTitle: String
    @Binding var changePage: Int
    var body: some View {
        HStack(spacing: 0) {
            // 이전 버튼
            Button {
                changePage -= 1
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.coral200)
            }
            Spacer()
            Text("\(calendarTitle)")
                .bold22Black500()
            Spacer()
            // 다음 버튼
            Button {
                changePage += 1
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.coral200)
            }
        }
    }
}

// MARK: - 생리 데이터 박스
struct MensDataRect: View {
    @Binding var selectedDate: Date
    @Binding var eventsArrayDone: [Date]

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Rectangle()
                .cornerRadius(10)
                .frame(height: eventsArrayDone.contains(selectedDate) ? 280 : 100)
                .foregroundColor(.calToday)
                .shadow(color: .black500.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay {
                    VStack(spacing: 0) {
                        if eventsArrayDone.contains(selectedDate) {
                            VStack(spacing: 0) {    // sample
                                MensData(mensImage: "Symp1", mensText: "배가 안 아파요")
                                MensData(mensImage: "MensAmt2", mensText: "생리양이 보통이에요")
                                    .padding(.top, 8)
                                MensData(mensImage: "Mood3", mensText: "기분이 나빠요")
                                    .padding(.top, 8)
                            }
                            .padding(.horizontal, -8)
                        } else {
                            HStack(spacing: 0) {
                                Image("SympRecordNone")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                Text("입력된 기록이 없어요")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.coral300)
                                    .padding(.leading, 10)
                            }
                        }
                    }
                }

            Button {
                print(selectedDate) // sample
                if eventsArrayDone.contains(selectedDate) {
                    if let index = eventsArrayDone.firstIndex(of: selectedDate) {
                        eventsArrayDone.remove(at: index)
                    }
                } else {
                    eventsArrayDone.append(selectedDate)
                }
            } label: {
                Rectangle()
                    .cornerRadius(10)
                    .frame(width: 120, height: 45)
                    .foregroundColor(Color.coral500)
                    .overlay {
                        HStack(spacing: 0) {
                            Image(systemName: "square.and.pencil")
                            Spacer()
                            Text(eventsArrayDone.contains(selectedDate) ? "고치기" : "입력")
                        }
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white50)
                        .padding(.horizontal, 16)
                    }
            }
            .padding(.top, 16)
            Spacer()
        }
        .frame(height: 350)
    }
}

// MARK: - 생리 데이터 리스트
struct MensData: View {
    let mensImage: String
    let mensText: String
    var body: some View {
        HStack(spacing: 0) {
            Image("SmallCheckStroke")
                .overlay {
                    Image(mensImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            Text(mensText)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black500)
                .padding(.leading, 16)
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    TargetCalView(dDay: 0)
}
