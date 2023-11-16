//
//  AdminMngView.swift
//  MyMomii
//
//  Created by qwd on 11/16/23.
//

import SwiftUI

struct AdminMngView: View {
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.coral300)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
    }
    @State private var selectedSide: ConnectController = .connected
    @State private var isContextMenuVisible = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("개별 상세 정보를 열람, 수정할 수 있습니다.")
//                        .medium14Black500()
                        .padding(.trailing, 115)
                    VStack {
                        Picker("Choose a Side", selection: $selectedSide) {
                            ForEach(ConnectController.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        ChosenHereView(selectedSide: selectedSide)
                    }
                }
            }
            .background(Color.white300)
            .navigationTitle("이용자 리스트")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // bell action 제레미 코드 받기
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(Color.coral500)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // context menu 액션 구현
                    }) {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(Color.coral500)
                    }
                }
            }
        }
    }
}

// MARK: - SegmentedControl Code
enum ConnectController: String, CaseIterable {
    case connected = "연결됨"
    case waiting = "연결 대기중"
}
struct ChosenHereView: View {
    var selectedSide: ConnectController
    var body: some View {
        switch selectedSide {
        case .connected:
            ConnectedView()
        case .waiting:
            WaitingView()
        }
    }
}
struct ConnectedView: View {
    //targetName 데이터에 있는 값을 가져와서 그 개수만큼 보여줄 수 있도록 함.
    @State private var connectTarget: [String] = ["Target 1", "Target 2", "Target 3", "Target 4", "Target5"]
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(connectTarget, id: \.self) {items in
                    TargetFrameForConnectedView()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
struct WaitingView: View {
    //targetName 데이터에 있는 값을 가져와서 그 개수만큼 보여줄 수 있도록 함.
    @State private var waitTarget: [String] = ["Target 1"]
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(waitTarget, id: \.self) {items in
                    TargetFrameForWaitingView()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - TargetFrame Layout
struct TargetFrameForConnectedView: View {
//    차후에 사용할 상수
//    var targetName: String
//    var targetAge: String
    var body: some View {
        Button {
            //누르면 specificview로 넘어가게
        } label: {
            Image("TargetFrame")
                .overlay {
                    VStack {
                       Rectangle()
                            .frame(width: 150, height: 29)
                            .cornerRadius(40)
                            .foregroundColor(.coral100)
                            .overlay {
                                Text("김생리A")
//                                Text(\(targetName))
                                    .semiBold18Black500()
                            }
                        Text("만 33세")
//                            .regular16Black500()
//                        Text("만 \(TargetAge)세")
                    }
                }
        }
    }
}
struct TargetFrameForWaitingView: View {
//    차후에 사용할 상수
//    var targetName: String
//    var TargetAge: String
    var body: some View {
        Button {
            //누르면 specificview로 넘어가게
        } label: {
            Image("TargetFrame")
                .overlay {
                    VStack {
                       Rectangle()
                            .frame(width: 150, height: 29)
                            .cornerRadius(40)
                            .foregroundColor(.purple50)
                            .opacity(0.7)
                            .overlay {
                                Text("박생리")
                                    .semiBold18Black200()
                            }
                        Text("이용자 확인 대기 중..")
                            .regular16Black200()
                    }
                }
        }
    }
}

#Preview {
    AdminMngView()
}
