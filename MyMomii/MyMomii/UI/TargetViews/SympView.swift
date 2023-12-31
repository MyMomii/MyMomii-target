//
//  SympView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct SympView: View {
    @StateObject private var viewModel = SympViewModel()
    @StateObject private var targetCalViewModel = TargetCalViewModel()
    @State var moveToCalView = false
    @State var mensSympSelected = 0
    @State var mensAmtSelected = 0
    @State var emoLvSelected = 0
    @Binding var selectedDate: Date
    @State var selectedFromCalView = false
    let mensSympTitle = ["안 아파요", "아파요", "많이 아파요"]
    let mensAmtTitle = ["적어요", "보통이에요", "많아요"]
    let emoLvTitle = ["좋아요", "보통이에요", "나빠요"]
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
            symptomViewByDevice
            HStack {
                Button(action: {
                    viewModel.addMensInfo(
                        id: targetCalViewModel.mensInfosForSelectedDate != [] ? targetCalViewModel.mensInfosForSelectedDate[0].id : "",
                        mensSymp: "배가 \(mensSympTitle[mensSympSelected])",
                        mensAmt: "생리양이 \(mensAmtTitle[mensAmtSelected])",
                        emoLv: "기분이 \(emoLvTitle[emoLvSelected])",
                        dateOfMens: dateOfMensFormat.string(from: selectedDate))
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
            Spacer()
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .task {
            try? await targetCalViewModel.getMensInfoForSelectedDate(selectedDate: dateOfMensFormat.string(from: selectedDate))
            if targetCalViewModel.mensInfosForSelectedDate != [] {
                mensSympSelected = selectedMensSymp(mensInfo: targetCalViewModel.mensInfosForSelectedDate[0])
                mensAmtSelected = selectedMensAmt(mensInfo: targetCalViewModel.mensInfosForSelectedDate[0])
                emoLvSelected = selectedEmoLv(mensInfo: targetCalViewModel.mensInfosForSelectedDate[0])
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white300)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $moveToCalView) {
            TargetCalView()
        }
        .navigationBarItems(leading: BackButton(backBtnTitleType: .titleImage, backButtonTitle: ""))
        .overlay {
            LoadingView()
        }
        .backGesture()
    }

    func selectedMensSymp(mensInfo: MensInfo) -> Int {
        let mensSympTitle = ["배가 안 아파요", "배가 아파요", "배가 많이 아파요"]
        switch mensInfo.mensSymp {
        case mensSympTitle[0]:
            return 0
        case mensSympTitle[1]:
            return 1
        case mensSympTitle[2]:
            return 2
        default:
            return 0
        }
    }

    func selectedMensAmt(mensInfo: MensInfo) -> Int {
        let mensAmtTitle = ["생리양이 적어요", "생리양이 보통이에요", "생리양이 많아요"]
        switch mensInfo.mensAmt {
        case mensAmtTitle[0]:
            return 0
        case mensAmtTitle[1]:
            return 1
        case mensAmtTitle[2]:
            return 2
        default:
            return 0
        }
    }

    func selectedEmoLv(mensInfo: MensInfo) -> Int {
        let emoLvTitle = ["기분이 좋아요", "기분이 보통이에요", "기분이 나빠요"]
        switch mensInfo.emoLv {
        case emoLvTitle[0]:
            return 0
        case emoLvTitle[1]:
            return 1
        case emoLvTitle[2]:
            return 2
        default:
            return 0
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
                            HapticManager.instance.impact(style: .rigid)
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
                            HapticManager.instance.impact(style: .rigid)
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
                            HapticManager.instance.impact(style: .rigid)
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

//#Preview {
//    SympView(selectedDate: .constant(.now))
//}
