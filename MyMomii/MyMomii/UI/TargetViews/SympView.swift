//
//  SympView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SympView: View {
    @StateObject private var viewModel = SympViewModel()
    @State var moveToCalView = false
    @State var mensSympSelected = 0
    @State var mensAmtSelected = 0
    @State var emoLvSelected = 0
    let mensSympTitle = ["안 아파요", "아파요", "많이 아파요"]
    let mensAmtTitle = ["적어요", "보통이에요", "많아요"]
    let emoLvTitle = ["적어요", "보통이에요", "많아요"]
    let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월 d일 HH:mm:ss"
        return formatter
    }()
    let dateOfMensFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    var body: some View {
            VStack(spacing: 20) {
                if let user = viewModel.user {
                    TodayWithDayOfWeek()
                        .padding(.top, 5)
                    symptomViewByDevice
                    HStack {
                        Button(action: {
                            // MARK: dateOfMens의 값은 메인화면에서 접근했을 경우 오늘 날짜로 지정, 달력에서 이동했을 경우 달력에서 선택한 값으로 설정
                            viewModel.addMensInfo(mensSymp: mensSympTitle[mensSympSelected], mensAmt: mensAmtTitle[mensAmtSelected], emoLv: emoLvTitle[emoLvSelected], dateOfMens: dateOfMensFormat.string(from: Date()))
                            moveToCalView = true
                        }, label: {
                            RoundedRectangle(cornerRadius: 61)
                                .foregroundColor(.coral500)
                                .overlay(
                                    Text("저장해요")
                                        .bold24White50()
                                )
                                .frame(height: 65)
                                .shadow(color: .black500.opacity(0.15), radius: 4, x: 0, y: 4)
                        })
                    }
                }
                Spacer()
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .padding(.horizontal, 16)
            .background(Color.white300)
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $moveToCalView) {
                TargetCalView()
            }
    }

    @ViewBuilder private var symptomViewByDevice: some View {
        if DeviceSize.width < DeviceSize.iPhone14 {
            ScrollView {
                VStack(spacing: 20) {
                    MensSympDetailView(mensSympSelected: $mensSympSelected, imgTitle: mensSympTitle)
                    MensAmtDetailView(mensAmtSelected: $mensAmtSelected, imgTitle: mensAmtTitle)
                    MoodDetailView(emoLvSelected: $emoLvSelected, imgTitle: emoLvTitle)
                }
                .padding(.bottom, 5)
            }
        } else {
            MensSympDetailView(mensSympSelected: $mensSympSelected, imgTitle: mensSympTitle)
            MensAmtDetailView(mensAmtSelected: $mensAmtSelected, imgTitle: mensAmtTitle)
            MoodDetailView(emoLvSelected: $emoLvSelected, imgTitle: emoLvTitle)
        }
    }
}

struct MensSympDetailView: View {
    @Binding var mensSympSelected: Int
    let imgTitle: [String]
    var body: some View {
        VStack {
            Text("배가 아파요")
                .bold24Black400()
            HStack {
                ForEach(0..<3) { index in
                    VStack {
                        Button(action: {
                            mensSympSelected = index
                        }, label: {
                            if mensSympSelected == index {
                                ZStack {
                                    Image("Symp\(index+1)")
                                    Image("CheckStroke")
                                }
                            } else {
                                Image("Symp\(index+1)")
                            }
                        })
                        .frame(width: 90, height: 90)
                        if mensSympSelected == index {
                            Text(imgTitle[index])
                                .semiBold16Coral500()
                        } else {
                            Text(imgTitle[index])
                                .semiBold16Black400()
                        }
                    }
                    if index != 2 {
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(InputBackgroundView())
    }
}

struct MensAmtDetailView: View {
    @Binding var mensAmtSelected: Int
    let imgTitle: [String]
    var body: some View {
        VStack {
            Text("생리양")
                .bold24Black400()
            HStack {
                ForEach(0..<3) { index in
                    VStack {
                        Button(action: {
                            mensAmtSelected = index
                        }, label: {
                            if mensAmtSelected == index {
                                ZStack {
                                    Image("MensAmt\(index+1)")
                                    Image("CheckStroke")
                                }
                            } else {
                                Image("MensAmt\(index+1)")
                            }
                        })
                        .frame(width: 90, height: 90)
                        if mensAmtSelected == index {
                            Text(imgTitle[index])
                                .semiBold16Coral500()
                        } else {
                            Text(imgTitle[index])
                                .semiBold16Black400()
                        }
                    }
                    if index != 2 {
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(InputBackgroundView())
    }
}

struct MoodDetailView: View {
    @Binding var emoLvSelected: Int
    let imgTitle: [String]
    var body: some View {
        VStack {
            Text("나의 기분")
                .bold24Black400()
            HStack {
                ForEach(0..<3) { index in
                    VStack {
                        Button(action: {
                            emoLvSelected = index
                        }, label: {
                            if emoLvSelected == index {
                                ZStack {
                                    Image("Mood\(index+1)")
                                    Image("CheckStroke")
                                }
                            } else {
                                Image("Mood\(index+1)")
                            }
                        })
                        .frame(width: 90, height: 90)
                        if emoLvSelected == index {
                            Text(imgTitle[index])
                                .semiBold16Coral500()
                        } else {
                            Text(imgTitle[index])
                                .semiBold16Black400()
                        }
                    }
                    if index != 2 {
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(InputBackgroundView())
    }
}

struct InputBackgroundView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white50)
            .shadow(color: .black500.opacity(0.10), radius: 3.5, x: 0, y: 0)
    }
}

struct TodayWithDayOfWeek: View {
    let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter
    }()
    var body: some View {
        Text("\(Image(systemName: "calendar")) \(dateformat.string(from: Date()))")
            .bold22Coral400()
    }
}

#Preview {
    SympView()
}
