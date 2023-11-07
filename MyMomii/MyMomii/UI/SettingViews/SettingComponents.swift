//
//  SettingComponents.swift
//  AhnNyeong
//
//  Created by OhSuhyun on 2023.11.02.
//

import SwiftUI

struct SettingComponents: View {
    @Binding var toggleSample: Bool
    @Binding var datePickerSample: Date
    var body: some View {
        VStack {
            SettingViewTitle(settingViewTitle: "SettingViewTitle")
                .background(Color.white300)
            ListTitle(listTitle: "List Title", listCaption: "List Title's Caption")
                .background(Color.white300)
            TermList(termTitle: "TermList")
                .background(Color.white300)
            SettingList(listTitle: "Setting List", listCaption: "Setting List's Caption")
                .background(Color.white300)
            ToggleList(toggleTitle: "ToggleList", toggleIsOn: $toggleSample)
                .background(Color.white300)
            DatePickerList(datePickerTitle: "DatePickerList", selection: $datePickerSample)
                .background(Color.white300)
        }
    }
}

// MARK: - List View
// 설정 화면 타이틀
struct SettingViewTitle: View {
    let settingViewTitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(settingViewTitle)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black400)
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
            DividingRectangle(dividingType: .naviTitleDivider)
                .padding(.top, 20)
        }
    }
}

// 리스트 타이틀 + 서브 타이틀
struct ListTitle: View {
    let listTitle: String
    let listCaption: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(listTitle)
                .bold18Black400()
            Text(listCaption)
                .medium12Black300()
        }
    }
}

// 사용약관 리스트: 리스트 타이틀 + chevron
struct TermList: View {
    let termTitle: String
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(termTitle)
                    .semiBold16Black400()
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.coral500)
            }
            .padding(EdgeInsets(top: 22.5, leading: 16, bottom: 22.5, trailing: 16))
            DividingRectangle(dividingType: .listDivider)
        }
    }
}

// 메인 설정 리스트: ListTitle + chevron
struct SettingList: View {
    let listTitle: String
    let listCaption: String
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ListTitle(listTitle: listTitle, listCaption: listCaption)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.coral500)
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 16))
            DividingRectangle(dividingType: .listDivider)
        }
    }
}

// 토글 리스트: 토글 + 패딩
struct ToggleList: View {
    let toggleTitle: String
    @Binding var toggleIsOn: Bool
    var body: some View {
        Toggle(toggleTitle, isOn: $toggleIsOn)
            .padding(EdgeInsets(top: 6.5, leading: 16, bottom: 6.5, trailing: 16))
    }
}

// 데이트픽커 리스트: 타임픽커 + 패딩
struct DatePickerList: View {
    let datePickerTitle: String
    @Binding var selection: Date
    var body: some View {
        DatePicker(datePickerTitle, selection: $selection, displayedComponents: .hourAndMinute)
            .padding(EdgeInsets(top: 6.5, leading: 16, bottom: 6.5, trailing: 16))
    }
}

// MARK: - Component
// 모달 버튼: 선택 시 모달이 나타나는 버튼
struct ModalButton: View {
    @Binding var showModal: Bool
    let buttonTitle: String
    var body: some View {
        Button(action: {
            self.showModal = true
        }, label: {
            Rectangle()
                .frame(height: 70)
                .foregroundColor(.coral500)
                .cornerRadius(10)
                .shadow(color: .black500.opacity(0.15), radius: 4, x: 0, y: 4)
                .overlay {
                    Text(buttonTitle)
                        .semiBold18White75()
                }
        })
    }
}

// Divider() 대체: 구분선 역할의 Rectangle(내비게이션용/리스트용)
enum DividingType {
    case naviTitleDivider
    case listDivider
}

struct DividingRectangle: View {
    let dividingType: DividingType

    var body: some View {
        switch dividingType {
        case .naviTitleDivider:
            return Rectangle()
                .frame(height: 1)
                .foregroundColor(.black75)
        case .listDivider:
            return Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.black75)
        }
    }
}

// MARK: - Navigation Back Button
// 내비게이션 백버튼: chevron + 백버튼 타이틀(text/image)
enum BackBtnTitleType {
    case titleText
    case titleImage
}

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    let backBtnTitleType: BackBtnTitleType
    let backButtonTitle: String
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .semibold))
                .padding(.trailing, 4)
            switch backBtnTitleType {
            case .titleText:
                Text(backButtonTitle)
                    .font(.system(size: 17, weight: .regular))
            case .titleImage:
                Image(systemName: backButtonTitle)
                    .font(.system(size: 17, weight: .semibold)) // need some check!
            }
        }
        .foregroundColor(.coral500)
        .onTapGesture {
            dismiss()
        }
    }
}

#Preview {
    SettingComponents(toggleSample: .constant(true), datePickerSample: .constant(Date.now))
}
