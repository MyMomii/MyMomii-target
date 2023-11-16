//
//  TargetCalView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct TargetCalView: View {
    @StateObject private var viewModel = TargetCalViewModel()
    @State private var selectedDate: Date = .now
    @State private var calendarHeight: CGFloat = 600.0
    @State private var eventsArray: [String] = []
    @State private var eventsArrayDone: [String] = []
    @State private var calendarTitle: String = ""
    @State private var changePage: Int = 0
    @State private var isInputSelected: Bool = false
    @State private var isSettingSelected = false
    @State private var dDay: Int = 0
    @State private var dDayTitle: String = "생리 정보를 입력해주세요"
    @State private var mensInfos: [MensInfo] = []
    func dDayToTitle(dDay: Int) -> String {
        if dDay == 0 {  // 생리 예정일 당일 또는 생리 정보 입력 당일
            return "오늘 생리 시작!"
        } else if dDay == 9999 {    // 디데이 값 이상
            return " "
        } else if dDay > 900 {    // 생리 시작 3일 이내
            return "생리 시작 \(-(dDay-1000)+1)일차"
        } else if dDay > 0 {    // 생리 예정일 전
            return "생리 시작 \(dDay)일 전"
        } else {    // 생리 예정일 지남
            return "생리 예정일 \(-1*dDay)일 지남"
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
        if gapAfterToToday == 0 {   // 생리 예정일 당일
            dDayCode = gapAfterToToday!
        } else if gapBeforeToToday == 0 {  // 생리 정보 입력 당일
            dDayCode = gapBeforeToToday!
        } else if gapBeforeToToday! > -3 && gapBeforeToToday! < 0 {   // 생리 시작 3일 이내
            dDayCode = gapBeforeToToday!+1000
        } else if gapAfterToToday! > 0 {    // 생리 예정일 전
            dDayCode = gapAfterToToday!
        } else if gapAfterToToday! < 0 { // 생리 예정일 지남
            dDayCode = gapAfterToToday!
        } else {    // dDay 이상 있음
            dDayCode = 9999
        }

        return dDayCode
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(dDayTitle)")
                .bold32Coral400()
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 32, trailing: 8))
            CalendarRect(selectedDate: $selectedDate, calendarHeight: $calendarHeight, eventsArray: $eventsArray, eventsArrayDone: $eventsArrayDone, calendarTitle: $calendarTitle, changePage: $changePage, isInputSelected: $isInputSelected, dDay: $dDay, dDayTitle: $dDayTitle)
                .frame(height: 600)
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.white300)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.isSettingSelected = true
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(Color.coral500)
                })
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $isInputSelected) {
            SympView(selectedDate: $selectedDate, selectedFromCalView: true)
        }
        .navigationDestination(isPresented: $isSettingSelected) {
            SettingMainView(userName: "")   // not completed <- SettingMainView에서 userName 제거 필요
        }
        .task {
            try? await viewModel.getAllMensInfos()
            mensInfoToEventsArrayDone()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                dDay = calculateDDay(eventsArray: eventsArray, eventsArrayDone: eventsArrayDone)
                dDayTitle = dDayToTitle(dDay: dDay)
            }
        }
        .onChange(of: eventsArrayDone) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                dDay = calculateDDay(eventsArray: eventsArray, eventsArrayDone: eventsArrayDone)
                dDayTitle = dDayToTitle(dDay: dDay)
            }
        }
    }

    func mensInfoToEventsArrayDone() {
        let mensInfos = viewModel.mensInfos
        var str: [String] = []
        for mensInfo in mensInfos {
            self.mensInfos.append(mensInfo)
            str.append(mensInfo.dateOfMens)
        }
        eventsArrayDone = str
    }
}

// MARK: - 캘린더 박스
struct CalendarRect: View {
    @Binding var selectedDate: Date
    @Binding var calendarHeight: CGFloat
    @Binding var eventsArray: [String]
    @Binding var eventsArrayDone: [String]
    @Binding var calendarTitle: String
    @Binding var changePage: Int
    @Binding var isInputSelected: Bool
    @Binding var dDay: Int
    @Binding var dDayTitle: String
    var firestoreFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .cornerRadius(10)
                    .foregroundColor(Color.white50)
                    .shadow(color: .black500.opacity(0.15), radius: 3.5, x: 0, y: 2)
                    .frame(height: eventsArrayDone.contains(firestoreFormatter.string(from: selectedDate)) ? 580 : 400)
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
            MensDataRect(selectedDate: $selectedDate, eventsArray: $eventsArray, eventsArrayDone: $eventsArrayDone, isInputSelected: $isInputSelected, dDay: $dDay, dDayTitle: $dDayTitle)
                .padding(EdgeInsets(top: 200-4, leading: 16, bottom: 16+4, trailing: 16))
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
                    .modifier(Bold24Coral200())
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
                    .modifier(Bold24Coral200())
            }
        }
    }
}

// MARK: - 생리 데이터 박스
struct MensDataRect: View {
    @StateObject private var viewModel = TargetCalViewModel()
    @Binding var selectedDate: Date
    @Binding var eventsArray: [String]
    @Binding var eventsArrayDone: [String]
    @Binding var isInputSelected: Bool
    @Binding var dDay: Int
    @Binding var dDayTitle: String
    var firestoreFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color.calToday)
                Text("오늘")
                    .semiBold14Black200()
                    .padding(.leading, 8)
                Spacer()
                Image("Drop")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color.calToday)
                Text("생리")
                    .semiBold14Black200()
                    .padding(.leading, 8)
            }
            .frame(height: 16)
            .padding(.bottom, 8)
            Rectangle()
                .cornerRadius(10)
                .frame(height: eventsArrayDone.contains(firestoreFormatter.string(from: selectedDate)) ? 280 : 100)
                .foregroundColor(.calToday)
                .shadow(color: .black500.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay {
                    VStack(spacing: 0) {
                        if eventsArrayDone.contains(firestoreFormatter.string(from: selectedDate)) && viewModel.mensInfosForSelectedDate != [] {
                            VStack(spacing: 0) {
                                MensData(mensSympText: viewModel.mensInfosForSelectedDate[0].mensSymp,
                                         mensAmtText: viewModel.mensInfosForSelectedDate[0].mensAmt,
                                         emoLvText: viewModel.mensInfosForSelectedDate[0].emoLv)
                            }
                            .padding(.horizontal, -8)
                        } else {
                            HStack(spacing: 0) {
                                Image("SympRecordNone")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                Text("입력된 기록이 없어요")
                                    .semiBold20Coral300()
                                    .padding(.leading, 10)
                            }
                        }
                    }
                }

            Button {
                print(selectedDate) // sample
                if eventsArrayDone.contains(firestoreFormatter.string(from: selectedDate)) {
                    if let index = eventsArrayDone.firstIndex(of: firestoreFormatter.string(from: selectedDate)) {
                        eventsArrayDone.remove(at: index)
                    }
                } else {
                    eventsArrayDone.append(firestoreFormatter.string(from: selectedDate))
                }
                isInputSelected = true
                dDay = TargetCalView().calculateDDay(eventsArray: eventsArray, eventsArrayDone: eventsArrayDone)
                dDayTitle = TargetCalView().dDayToTitle(dDay: dDay)
            } label: {
                Rectangle()
                    .cornerRadius(10)
                    .frame(width: 120, height: 45)
                    .foregroundColor(Color.coral500)
                    .overlay {
                        HStack(spacing: 0) {
                            Image(systemName: "square.and.pencil")
                            Spacer()
                            Text(eventsArrayDone.contains(firestoreFormatter.string(from: selectedDate)) ? "고치기" : "입력")
                        }
                        .modifier(SemiBold20White50())
                        .padding(.horizontal, 16)
                    }
            }
            .padding(.top, 16)
            .animationsDisabled()

            Spacer()
        }
        .frame(height: 374)
        .task {
            try? await viewModel.getMensInfoForSelectedDate(selectedDate: firestoreFormatter.string(from: selectedDate))
        }
        .onChange(of: selectedDate) {
            Task {
                try? await viewModel.getMensInfoForSelectedDate(selectedDate: firestoreFormatter.string(from: selectedDate))
            }
        }
    }
}

// MARK: - 생리 데이터 리스트
struct MensData: View {
    let mensSympText: String
    let mensAmtText: String
    let emoLvText: String
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image("SmallCheckStroke")
                    .overlay {
                        Image(stringToImage(detail: mensSympText))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                Text("\(mensSympText)")
                    .semiBold20Black500()
                    .padding(.leading, 16)
                Spacer()
            }
            HStack(spacing: 0) {
                Image("SmallCheckStroke")
                    .overlay {
                        Image(stringToImage(detail: mensAmtText))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                Text("\(mensAmtText)")
                    .semiBold20Black500()
                    .padding(.leading, 16)
                Spacer()
            }
            .padding(.top, 8)
            HStack(spacing: 0) {
                Image("SmallCheckStroke")
                    .overlay {
                        Image(stringToImage(detail: emoLvText))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                Text("\(emoLvText)")
                    .semiBold20Black500()
                    .padding(.leading, 16)
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 32)
    }

    // firestore에 저장된 증상 String에 일치하는 이미지 return
    func stringToImage(detail: String) -> String {
        let mensSympTitle = ["배가 안 아파요", "배가 아파요", "배가 많이 아파요"]
        let mensAmtTitle = ["생리양이 적어요", "생리양이 보통이에요", "생리양이 많아요"]
        let emoLvTitle = ["기분이 좋아요", "기분이 보통이에요", "기분이 나빠요"]

        switch detail {
        case mensSympTitle[0]:
            return "Symp1"
        case mensSympTitle[1]:
            return "Symp2"
        case mensSympTitle[2]:
            return "Symp3"
        case mensAmtTitle[0]:
            return "MensAmt1"
        case mensAmtTitle[1]:
            return "MensAmt2"
        case mensAmtTitle[2]:
            return "MensAmt3"
        case emoLvTitle[0]:
            return "Mood1"
        case emoLvTitle[1]:
            return "Mood2"
        case emoLvTitle[2]:
            return "Mood3"
        default:
            return ""
        }
    }
}

extension View {
    // 기본 애니메이션 효과 제거
    func animationsDisabled() -> some View {
        return self.transaction { (tx: inout Transaction) in
            tx.disablesAnimations = true
            tx.animation = nil
        }.animation(nil)
    }
}

extension String {
    // String을 Date로 변환하는 확장 함수
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.date(from: self)
    }
}

#Preview {
//    NavigationStack {
        TargetCalView()
//    }
}
