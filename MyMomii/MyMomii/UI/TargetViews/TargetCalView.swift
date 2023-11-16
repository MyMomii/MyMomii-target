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
    @State private var eventsArray: [String] = []
    @State private var eventsArrayDone: [String] = []
    @State private var calendarTitle: String = ""
    @State private var changePage: Int = 0
    @State private var dDay: Int = 0
    @State private var dDayTitle: String = "생리 정보를 입력해주세요"
    @State private var isInputSelected: Bool = false

    @State private var isSettingSelected: Bool = false
    @State private var mensInfos: [MensInfo] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(dDayTitle)")
                .bold32Coral400()
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 32, trailing: 8))
            CalendarRect(selectedDate: $selectedDate, eventsArray: $eventsArray, eventsArrayDone: $eventsArrayDone, calendarTitle: $calendarTitle, changePage: $changePage, dDay: $dDay, dDayTitle: $dDayTitle, isInputSelected: $isInputSelected)
                .frame(height: 600)
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.white300)
        // Loading View
        .overlay {
            LoadingView()
        }
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
            SettingMainView(eventsArray: $eventsArray)
        }
        .task {
            try? await viewModel.getAllMensInfos()
            mensInfoToEventsArrayDone()
        }
    }

    func mensInfoToEventsArrayDone() {
        let mensInfos = viewModel.mensInfos
        var str: [String] = []
        for mensInfo in mensInfos {
            self.mensInfos.append(mensInfo)
            str.append(mensInfo.dateOfMens)
        }
        // TODO: 데이터량이 많을 때 작업 속도가 느려진다면 firestore orderby 작업 필요
        eventsArrayDone = str.sorted()
    }
}

// MARK: - 캘린더 박스
struct CalendarRect: View {
    @AppStorage("eventsArrayFirst") var eventsArrayFirst: String!
    @AppStorage("eventsArrayDoneLast") var eventsArrayDoneLast: String!
    @Binding var selectedDate: Date
    @Binding var eventsArray: [String]
    @Binding var eventsArrayDone: [String]
    @Binding var calendarTitle: String
    @Binding var changePage: Int
    @Binding var dDay: Int
    @Binding var dDayTitle: String
    @Binding var isInputSelected: Bool
    @State var isOpacity: CGFloat = 0.01
    var firestoreFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }
    static let calendarSetHeight: CGFloat = 600
    static let calendarRectHeight: CGFloat = mensRectHeight+300   // < calendarSetHeight
    static let mensSetHeight: CGFloat = mensRectHeight+140 // 생리데이터+버튼+범례
    static let dataGap: CGFloat = calendarRectHeight-mensSetHeight  // = 140
    static let mensRectHeight: CGFloat = 260
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .cornerRadius(10)
                    .foregroundColor(Color.white50)
                    .shadow(color: .black500.opacity(0.15), radius: 3.5, x: 0, y: 2)
                    .frame(height: eventsArrayDone.contains(firestoreFormatter.string(from: selectedDate)) ? CalendarRect.calendarRectHeight : CalendarRect.calendarRectHeight-CalendarRect.dataGap)
                    .overlay {
                        // Header
                        VStack(spacing: 0) {
                            CalendarHeader(calendarTitle: $calendarTitle, changePage: $changePage)
                                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                            Spacer()
                        }
                    }
                Spacer()
            }
            .frame(height: CalendarRect.calendarSetHeight)
            TargetCalViewRepresentable(selectedDate: $selectedDate, eventsArray: $eventsArray, eventsArrayDone: $eventsArrayDone, calendarTitle: $calendarTitle, changePage: $changePage)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16))
                .opacity(isOpacity)
                .animation(.easeInOut(duration: 0.3), value: isOpacity)
                .offset(y: 50)
                .frame(height: CalendarRect.calendarSetHeight)
                .clipped()
                .onChange(of: eventsArray) { newValue in
                    isOpacity = 1
                    if eventsArray == [] || eventsArrayDone == [] {
                        eventsArrayFirst = "00000000"
                        eventsArrayDoneLast = "00000000"
                    } else {
                        eventsArrayFirst = eventsArray.first
                        eventsArrayDoneLast = eventsArrayDone.last
                    }
                    dDay = calculateDDay(eventsArray: eventsArray, eventsArrayDone: eventsArrayDone)
                    dDayTitle = dDayToTitle(dDay: dDay)
                }

            MensDataRect(selectedDate: $selectedDate, eventsArray: $eventsArray, eventsArrayDone: $eventsArrayDone, dDay: $dDay, dDayTitle: $dDayTitle, isInputSelected: $isInputSelected)
                .frame(height: CalendarRect.mensSetHeight)
                .padding(EdgeInsets(top: CalendarRect.calendarSetHeight-CalendarRect.mensSetHeight-16, leading: 16, bottom: 8+16, trailing: 16))
                .opacity(isOpacity)
        }
    }

    func dDayToTitle(dDay: Int) -> String {
        if dDay == 9999 {    // 디데이 값 이상
            return " "
        } else if dDay > 900 {    // 생리 시작 3일 이내
            return "생리 시작 \(-(dDay-1000)+2)일차"
        } else if dDay > 0 {    // 생리 예정일 전
            return "생리 시작 \(dDay+1)일 전"
        } else if dDay < 0 {    // 생리 예정일 지남
            return "생리 예정일 \(-1*(dDay+1))일 지남"
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
    @Binding var dDay: Int
    @Binding var dDayTitle: String
    @Binding var isInputSelected: Bool
    @State var inputButtonDisabled: Bool = false
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
                Image("CalDropTarget")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color.calToday)
                Text("생리")
                    .semiBold14Black200()
                    .padding(.leading, 8)
            }
            .frame(height: 16)
            .padding(.bottom, 16)
            Rectangle()
                .cornerRadius(10)
                .frame(height: eventsArrayDone.contains(firestoreFormatter.string(from: selectedDate)) ? CalendarRect.mensRectHeight : CalendarRect.mensRectHeight-CalendarRect.dataGap)
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
            } label: {
                Rectangle()
                    .cornerRadius(10)
                    .frame(width: 120, height: 45)
                    .foregroundColor(Color.coral500)
                    .opacity(inputButtonDisabled ? 0.4 : 1.0)
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
            .disabled(inputButtonDisabled)
            .padding(.top, 16)
            .animationsDisabled()

            Spacer()
        }
        .frame(height: CalendarRect.mensSetHeight)
        .task {
            try? await viewModel.getMensInfoForSelectedDate(selectedDate: firestoreFormatter.string(from: selectedDate))
        }
        .onChange(of: selectedDate) { newValue in
            Task {
                try? await viewModel.getMensInfoForSelectedDate(selectedDate: firestoreFormatter.string(from: selectedDate))
            }
            inputButtonDisabled = firestoreFormatter.string(from: selectedDate) > firestoreFormatter.string(from: Date())
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
