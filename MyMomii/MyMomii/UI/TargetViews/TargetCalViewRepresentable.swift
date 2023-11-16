//
//  TargetCalViewRepresentable.swift
//  MyMomii
//
//  Created by OhSuhyun on 2023.11.14.
//

import SwiftUI
import UIKit
import FSCalendar

struct TargetCalViewRepresentable: UIViewRepresentable {
    let coral500 = UIColor(red: 255/255, green: 84/255, blue: 61/255, alpha: 1) // coral500
    let coral200 = UIColor(red: 255/255, green: 176/255, blue: 166/255, alpha: 1) // coral200
    let black500 = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1) // black500
    let black200 = UIColor(red: 86/255, green: 86/255, blue: 86/255, alpha: 1) // black200
    let black75 = UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)    // black75
    let white50 = UIColor(red: 255/255, green: 255/255, blue: 254/255, alpha: 1)    // white50
    let calmint = UIColor(red: 32/255, green: 211/255, blue: 211/255, alpha: 1) // cal_weekend
    let calyellow = UIColor(red: 255/255, green: 236/255, blue: 165/255, alpha: 1)  // cal_today

    @Binding var selectedDate: Date
    @Binding var eventsArray: [String]
    @Binding var eventsArrayDone: [String]
    @Binding var calendarTitle: String
    @Binding var changePage: Int
    @State var isViewUpdated = false
    // MARK: - Code
    typealias UIViewType = FSCalendar

    func changeUsViewUpdated() {
        isViewUpdated = false
    }

    func makeUIView(context: Context) -> FSCalendar {
        let calendarView = configureCalendar()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            changeUsViewUpdated()
        }
        return calendarView
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.delegate = context.coordinator
        uiView.dataSource = context.coordinator
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isViewUpdated = true
            UIView.animate(withDuration: 0.5) {
                uiView.setScope(.week, animated: true)
            }
        }

        // 달력 이동 버튼 동작
        let page = Calendar.current.date(byAdding: .weekOfMonth, value: changePage, to: uiView.currentPage)!
        uiView.setCurrentPage(page, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            changePage = 0
        }
    }

    // 유킷 -> 스유
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: $selectedDate, eventsArray: $eventsArray, eventsArrayDone: $eventsArrayDone, calendarTitle: $calendarTitle)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        @Binding var selectedDate: Date
        @Binding var eventsArray: [String]
        @Binding var eventsArrayDone: [String]
        @Binding var calendarTitle: String

        var firestoreFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            return formatter
        }

        let coral500 = UIColor(red: 255/255, green: 84/255, blue: 61/255, alpha: 1) // coral500
        let coral200 = UIColor(red: 255/255, green: 176/255, blue: 166/255, alpha: 1) // coral200
        let black500 = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1) // black500
        let black200 = UIColor(red: 86/255, green: 86/255, blue: 86/255, alpha: 1) // black200
        let black75 = UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)    // black75
        let white50 = UIColor(red: 255/255, green: 255/255, blue: 254/255, alpha: 1)    // white50
        let calmint = UIColor(red: 32/255, green: 211/255, blue: 211/255, alpha: 1) // cal_weekend
        let calyellow = UIColor(red: 255/255, green: 236/255, blue: 165/255, alpha: 1)  // cal_today

        init(selectedDate: Binding<Date>, eventsArray: Binding<[String]>, eventsArrayDone: Binding<[String]>, calendarTitle: Binding<String>) {
            self._selectedDate = selectedDate
            self._eventsArray = eventsArray
            self._eventsArrayDone = eventsArrayDone
            self._calendarTitle = calendarTitle
        }

        func calendar(_ calendar: FSCalendar,
                      didSelect date: Date,
                      at monthPosition: FSCalendarMonthPosition) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                selectedDate = date
            }

            // 선택 일자 타이틀 색상 지정
            let day = Calendar.current.component(.weekday, from: date) - 1
            if Calendar.current.shortWeekdaySymbols[day] == "일" {
                calendar.appearance.titleSelectionColor = coral500
            } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
                calendar.appearance.titleSelectionColor = calmint
            } else {
                calendar.appearance.titleSelectionColor = black500
            }

            calendar.reloadData()
        }

        // 캘린더 오늘/선택 날짜 표시
        func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
            cell.eventIndicator.transform = CGAffineTransform(scaleX: 0, y: 0)

            calendarTitle = calendarCurrentPageDidChange(calendar: calendar)
            calculateAverageConsecutiveDays(array: eventsArrayDone.sorted())

            // 셀 배경색
            let selectedColor = CGColor(red: 255/255, green: 236/255, blue: 165/255, alpha: 1)
            let todayColor = CGColor(red: 255/255, green: 236/255, blue: 165/255, alpha: 0.5)
            if date == calendar.selectedDate {
                cell.layer.backgroundColor = selectedColor
            } else if date == calendar.today {
                cell.layer.backgroundColor = todayColor
            } else {
                cell.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
                cell.layer.borderWidth = 0.0
            }
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = CGColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
        }

        func calendar(_ calendar: FSCalendar,
                      boundingRectWillChange bounds: CGRect,
                      animated: Bool) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
            }
        }

        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
            // 셀에 넣을 image 추가
            if self.eventsArray.contains(firestoreFormatter.string(from: date)) {
                return UIImage(named: "CalDropTarget")?.withTintColor(coral500)
            } else if self.eventsArrayDone.contains(firestoreFormatter.string(from: date)) {
                return UIImage(named: "CalDropTargetFill")?.withTintColor(coral500)
            } else {
                return nil
            }
        }

        // 일자 표시 위치
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleOffsetFor date: Date) -> CGPoint {

            return CGPoint(x: -8, y: -30)   // y: -20
        }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            let day = Calendar.current.component(.weekday, from: date) - 1

            if Calendar.current.shortWeekdaySymbols[day] == "일" {
                return coral500
            } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
                return calmint
            } else {
                return black500
            }
        }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
            let day = Calendar.current.component(.weekday, from: date) - 1
            if Calendar.current.shortWeekdaySymbols[day] == "일" {
                return coral500
            } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
                return calmint
            } else {
                return  black500
            }
        }

        private func calendarCurrentPageDidChange(calendar: FSCalendar) -> String {
            let dateFormatter: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM월 W주차"
                return dateFormatter
            }()
            let currentPage = calendar.currentPage

            return dateFormatter.string(for: currentPage) ?? dateFormatter.string(for: Date())!
        }

        // MARK: - 생리주기 예측
        func calculateAverageConsecutiveDays(array: [String], defulatPeriod: Int = 28) {
            guard array.count > 0 else { return }

            var periodDaysCount = 1
            var totalPeriodDays: [Int] = []
            var totalGap: [Int] = []
            var currentGap: Int?
            var dateArray: [Date] = []
            for dateString in array {
                if let date = firestoreFormatter.date(from: dateString) {
                    dateArray.append(date)
                } else {
                    print("날짜를 변환할 수 없습니다: \(dateString)")
                }
            }
            var lastStartDay = dateArray.first ?? Date()
            let firestoreFormatter = DateFormatter()
            firestoreFormatter.dateFormat = "yyyyMMdd"

            for index in 1..<dateArray.count {
                let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: dateArray[index])!
                if Calendar.current.isDate(dateArray[index-1], equalTo: previousDate, toGranularity: .day) {
                    periodDaysCount += 1
                } else {
                    totalPeriodDays.append(periodDaysCount)
                    periodDaysCount = 1

                    if let gap = currentGap {
                        totalGap.append(gap + totalPeriodDays[totalPeriodDays.count-2] - 1)
                    }

                    currentGap = Calendar.current.dateComponents([.day], from: dateArray[index-1], to: dateArray[index]).day

                    lastStartDay = dateArray[index]
                }
            }

            totalPeriodDays.append(periodDaysCount)
            if let gap = currentGap {
                totalGap.append(gap + totalPeriodDays[totalPeriodDays.count-2] - 1)
            }

            let periodGap = Int(Double(totalPeriodDays.reduce(0, +))/Double(totalPeriodDays.count))
            let mensturationGap = totalGap.count != 0 ?   Int(Double(totalGap.reduce(0, +))/Double(totalGap.count)) : defulatPeriod
            var nextMensturations: [String] = []

            for index in 0..<periodGap {
                let nextMensturation = Calendar.current.date(byAdding: .day, value: mensturationGap+index, to: lastStartDay)!

                nextMensturations.append(firestoreFormatter.string(from: nextMensturation))
            }

            self.eventsArray = nextMensturations
        }
    }
}

extension TargetCalViewRepresentable {
    func configureCalendar() -> FSCalendar {
        let calendarView = FSCalendar()
        calendarView.select(Date())
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.scope = .month // 기본 달력 형태(월간/주간)
        calendarView.adjustsBoundingRectWhenChangingMonths = true
        calendarView.headerHeight = 0.0
        calendarView.weekdayHeight = 24.0
        calendarView.appearance.weekdayFont = .systemFont(ofSize: 14.0, weight: .bold)
        calendarView.appearance.titleFont = .systemFont(ofSize: 14.0, weight: .bold)
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.appearance.headerTitleColor = .clear
        calendarView.appearance.weekdayTextColor = black500
        calendarView.appearance.titleDefaultColor = black500
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.todayColor = .clear
        calendarView.collectionViewLayout.sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)    // cell 여백 조정
        calendarView.appearance.separators = FSCalendarSeparators(rawValue: 0)!
        calendarView.appearance.imageOffset = CGPoint(x: -6, y: -8)

        return calendarView
    }

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
}

#Preview {
    TargetCalViewRepresentable(selectedDate: .constant(Date()), eventsArray: .constant([]), eventsArrayDone: .constant([]), calendarTitle: .constant(""), changePage: .constant(0))
}
