//
//  TargetCalViewController.swift
//  MyMomii
//
//  Created by OhSuhyun on 2023.11.10.
//

import SwiftUI
import UIKit
import FSCalendar
import SnapKit
import Then

class SelectedDateViewModel: ObservableObject {
    @Published var selectedDataContainer: Date = Date()
}

class TargetCalViewController: UIViewController, FSCalendarDelegate {
    @State var bridgeModel = SelectedDateViewModel()
    let coral500 = UIColor(red: 255/255, green: 84/255, blue: 61/255, alpha: 1) // coral500
    let coral200 = UIColor(red: 255/255, green: 176/255, blue: 166/255, alpha: 1) // coral200
    let black500 = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1) // black500
    let black200 = UIColor(red: 86/255, green: 86/255, blue: 86/255, alpha: 1) // black200
    let black75 = UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)    // black75
    let white50 = UIColor(red: 255/255, green: 255/255, blue: 254/255, alpha: 1)    // white50
    let calmint = UIColor(red: 32/255, green: 211/255, blue: 211/255, alpha: 1) // cal_weekend
    let calyellow = UIColor(red: 255/255, green: 236/255, blue: 165/255, alpha: 1)  // cal_today

    var eventsArray = [Date]()  // 이벤트(예정) <- firebase에서 가져온 또는 예정일 배열
    var eventsArrayDone = [Date]()  // 이벤트(완료) <- firebase에서 가져온 생리 기록 존재일 배열

    // MARK: - Property
    let headerDateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY년 MM월 W주차" // check -> userType
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }

    let dayDateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY년 MM월 dd일"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }

    // MARK: - UI components
    private lazy var calendarView = FSCalendar(frame: .zero)

    private lazy var todayButton = UIButton().then {
        $0.setTitle("오늘", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .semibold)
        $0.backgroundColor = coral500
        $0.layer.cornerRadius = 13.0    // not completed -> HARD coding
        $0.addTarget(self, action: #selector(gotoToday), for: .touchUpInside)
    }

    private lazy var leftButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)    // sample
        $0.tintColor = coral200
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.addTarget(self, action: #selector(tapBefore), for: .touchUpInside)
    }

    private lazy var rightButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)   // sample
        $0.tintColor = coral200
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
    }

    private lazy var headerLabel = UILabel().then { [weak self] in
        guard let self = self else { return }
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = black500
        $0.text = self.headerDateFormatter.string(from: Date())
    }

    private lazy var testLabel = UILabel().then {
        $0.text = "today: \(dayDateFormatter.string(from: Date()))" // not completed -> FSCalendar의 오늘이 아닌 실제 기기의 오늘
    }

    private lazy var selectedDateLabel = UILabel().then {   // 선택 전 값은 nil이어서 현재 시간을 대신 출력
        $0.text = "selected: \(calendarView.selectedDate ?? Date())"
    }

    private lazy var todayColorRect = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 16).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        $0.backgroundColor = calyellow
    }

    private lazy var colorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = black200
        $0.text = "오늘"
    }

    private lazy var dropIcon = UIImageView().then {
        $0.image = UIImage(named: "CalDropTarget")    // sample
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 12).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }

    private lazy var dropLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = black200
        $0.text = "예상 생리 기간"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCalendar()
    }

    // MARK: - 생리주기 예측
    func calculateAverageConsecutiveDays(array: [Date], defulatPeriod: Int = 28) {
        guard array.count > 0 else { return }

        var periodDaysCount = 1
        var totalPeriodDays: [Int] = []
        var totalGap: [Int] = []
        var currentGap: Int?
        var lastStartDay = array.first ?? Date()

        for index in 1..<array.count {
            let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: array[index])!
            if Calendar.current.isDate(array[index-1], equalTo: previousDate, toGranularity: .day) {
                periodDaysCount += 1
            } else {
                totalPeriodDays.append(periodDaysCount)
                periodDaysCount = 1

                if let gap = currentGap {
                    totalGap.append(gap + totalPeriodDays[totalPeriodDays.count-2] - 1)
                }

                currentGap = Calendar.current.dateComponents([.day], from: array[index-1], to: array[index]).day

                lastStartDay = array[index]
            }
        }

        totalPeriodDays.append(periodDaysCount)
        if let gap = currentGap {
            totalGap.append(gap + totalPeriodDays[totalPeriodDays.count-2] - 1)
        }

        let periodGap = Int(Double(totalPeriodDays.reduce(0,+))/Double(totalPeriodDays.count))

        let mensturationGap = totalGap.count != 0 ?   Int(Double(totalGap.reduce(0,+))/Double(totalGap.count)) : defulatPeriod


        var nextMensturations: [Date] = []

        for index in 0..<periodGap {
            let nextMensturation = Calendar.current.date(byAdding: .day, value: mensturationGap+index, to: lastStartDay)!

            nextMensturations.append(nextMensturation)
        }

        self.eventsArray = nextMensturations
    }
}

// MARK: - FSCalendar
extension TargetCalViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(180)
        }
        self.view.layoutIfNeeded()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendarView.currentPage
        headerLabel.text = headerDateFormatter.string(from: currentPage)
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.bridgeModel.selectedDataContainer = date
        print(self.bridgeModel.selectedDataContainer)
        // 이벤트 추가 및 예측
        if (date <= Date()) {
            eventsArrayDone.append(date)
        }
        calculateAverageConsecutiveDays(array: eventsArrayDone.sorted())

        // 선택 일자 타이틀 색상 지정
        let day = Calendar.current.component(.weekday, from: date) - 1
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            calendarView.appearance.titleSelectionColor = coral500
        } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
            calendarView.appearance.titleSelectionColor = calmint
        } else {
            calendarView.appearance.titleSelectionColor = black500
        }

        calendarView.reloadData()
    }

    // 주말 색상 변경
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

    // 캘린더 오늘/선택 날짜 표시
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        cell.eventIndicator.transform = CGAffineTransform(scaleX: 0, y: 0)
        cell.heightAnchor.constraint(equalToConstant: 120)

        // 오늘 일자 타이틀 색상 지정  // not completed -> HARD coding
        let day = Calendar.current.component(.weekday, from: date) - 1
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            calendarView.appearance.titleTodayColor = coral500
        } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
            calendarView.appearance.titleTodayColor = calmint
        } else {
            calendarView.appearance.titleTodayColor = black500
        }

        // 셀 배경색
        let selectedColor = CGColor(red: 255/255, green: 236/255, blue: 165/255, alpha: 1)
        let todayColor = CGColor(red: 255/255, green: 236/255, blue: 165/255, alpha: 0.5)
        if date == calendarView.selectedDate {
            cell.layer.backgroundColor = selectedColor
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = CGColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
        } else if date == calendarView.today {
            cell.layer.backgroundColor = todayColor
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = CGColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
        } else {
            cell.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
            cell.layer.borderWidth = 0.0
        }
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = CGColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)

        // 셀에 넣을 image 추가
        var iconName: String {
            if self.eventsArray.contains(date) {
                return "CalDropTarget"
            } else if self.eventsArrayDone.contains(date) {
                return "CalDropTargetFill"
            } else {
                return ""
            }
        }
        // 관리자용 물방울 & 이벤트 수량 라벨 이미지
        if self.eventsArray.contains(date) || self.eventsArrayDone.contains(date) {
            let cellImageView = UIImageView().then {
                $0.image = UIImage(named: iconName)
                $0.tintColor = coral500
                $0.translatesAutoresizingMaskIntoConstraints = true
            }

            cell.contentView.addSubview(cellImageView)

            cellImageView.snp.makeConstraints {
                $0.width.equalTo(15)
                $0.height.equalTo(21)
                $0.left.equalTo(cell.snp.left).offset(8.0)
                $0.bottom.equalTo(cell.snp.bottom).offset(-8.0) // 물방울 위치 조정
            }
        } else {
            for subview in cell.contentView.subviews {
                if subview is UIImageView {
                    subview.removeFromSuperview()
                }
            }
        }
    }

    // 일자 표시 위치
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleOffsetFor date: Date) -> CGPoint {
        // 선택 일자 타이틀 색상 지정 <- not completed <- 선택 일자 주말이어도 black500으로 나옴
        let day = Calendar.current.component(.weekday, from: date) - 1
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            calendarView.appearance.titleSelectionColor = coral500
        } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
            calendarView.appearance.titleSelectionColor = calmint
        } else {
            calendarView.appearance.titleSelectionColor = black500
        }

        return CGPoint(x: -8, y: -20)
    }
}

// MARK: - Method
extension TargetCalViewController {
    private func configureCalendar() {
        configureCalendarBasic()
        configureCalendarUI()

        calendarView.placeholderType = .none

        calendarView.scrollEnabled = true
        calendarView.scrollDirection = .horizontal
    }

    // MARK: - Calendar Components UI
    private func configureUI() {
        // 캘린더 버튼 배치
        let calendarButtonStackView = UIStackView(arrangedSubviews: [leftButton, headerLabel, rightButton]).then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
        let descriptionView = UIStackView(arrangedSubviews: [todayColorRect, colorLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 4.0
        }
        let dropDescriptionView = UIStackView(arrangedSubviews: [dropIcon, dropLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 4.0
        }

        [calendarButtonStackView, calendarView, descriptionView, dropDescriptionView, selectedDateLabel].forEach { view.addSubview($0) }

        // MARK: - UI AutoLayout
        selectedDateLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.top).offset(4.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(28.0)
        }
        calendarButtonStackView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(4.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(28.0)
        }
        calendarView.snp.makeConstraints {  // not completed -> sample
            $0.top.equalTo(calendarButtonStackView.snp.bottom).offset(8.0)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(100 + calendarView.weekdayHeight)    // 달력 높이 check -> userType
            $0.bottom.equalTo(view.snp.bottom).offset(-32.0)
        }

        descriptionView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.top).offset(calendarView.rowHeight*3)
            $0.leading.equalToSuperview()
            $0.height.equalTo(16)
        }

        dropDescriptionView.snp.makeConstraints {
//            $0.top.equalTo(calendarView.snp.top).offset(116.0)
            $0.top.equalTo(calendarView.snp.top).offset(calendarView.rowHeight*3)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(16)
        }
    }

    private func configureCalendarBasic() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.select(Date())
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.scope = .week // 기본 달력 형태(월간/주간)
        calendarView.adjustsBoundingRectWhenChangingMonths = true
    }

    // MARK: - Calendar UI
    private func configureCalendarUI() {
        // header: yyyy년 mm월, weekday: 요일, title: 일자
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
    }

    // MARK: - goto Prev/Next
    func getNextMonth(date: Date) -> Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to: date)!
    }

    func getNextWeek(date: Date) -> Date {
        return  Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: date)!
    }

    func getPreviousMonth(date: Date) -> Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to: date)!
    }

    func getPreviousWeek(date: Date) -> Date {
        return  Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: date)!
    }

    // MARK: - Selector Method
    @objc func gotoToday() {
        self.calendarView.select(dayDateFormatter.date(from: dayDateFormatter.string(from: Date())), scrollToDate: true)
        calendarView.reloadData()
    }

    @objc func tapNext() {
        if self.calendarView.scope == .month {
            self.calendarView.setCurrentPage(getNextMonth(date: calendarView.currentPage), animated: true)
        } else {
            self.calendarView.setCurrentPage(getNextWeek(date: calendarView.currentPage), animated: true)
        }
    }

    @objc func tapBefore() {
        if self.calendarView.scope == .month {
            self.calendarView.setCurrentPage(getPreviousMonth(date: calendarView.currentPage), animated: true)
        } else {
            self.calendarView.setCurrentPage(getPreviousWeek(date: calendarView.currentPage), animated: true)
        }
    }
}

//#Preview {
//    TargetCalendarView(selectedDate: .constant(SelectedDateViewModel()), model: SelectedDateViewModel())
//}
