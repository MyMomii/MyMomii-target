//
//  imperMainView.swift
//  AhnNyeong
//
//  Created by jaelyung kim on 10/15/23.
//

import SwiftUI

struct ImperMainView: View {
    @StateObject var mensInfoStore: MensInfoStore = MensInfoStore()
    @State var isClicked = false
    var body: some View {
        VStack {
            List {
                ForEach(mensInfoStore.mensInfos, id: \.self) { mensInfo in
                    ListCell(mensInfo: mensInfo, mensInfoStore: mensInfoStore)
                }
            }
            .onAppear {
                mensInfoStore.listenToRealtimeDatabase()
            }
            .onDisappear {
                mensInfoStore.stopListening()
            }
            Button(action: {
                isClicked.toggle()
            }, label: {
                Circle()
            })
            if isClicked {
                ImperMensView(mensInfoStore: MensInfoStore())
            }
        }
    }
}

enum MensAmtSection: String, CaseIterable {
    case little = "적음"
    case moderate = "보통"
    case much = "많음"
}

enum MensSympSection: String, CaseIterable {
    case notPainful = "없음"
    case painful = "있음"
    case veryPainful = "아주 심함"
}

enum EmoLvSection: String, CaseIterable {
    case notBad = "보통"
    case good = "좋음"
    case bad = "나쁨"
}

struct ImperMensView: View {
    @ObservedObject var mensInfoStore: MensInfoStore
    @State var mensAmt: MensAmtSection = .little
    @State var mensSymp: MensSympSection = .notPainful
    @State var emoLv: EmoLvSection = .notBad
    var body: some View {
        VStack {
            Text("생리양")
            Picker("", selection: $mensAmt) {
                        ForEach(MensAmtSection.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
            Text("생리통정도")
            Picker("", selection: $mensSymp) {
                        ForEach(MensSympSection.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
            Text("감정정도")
            Picker("", selection: $emoLv) {
                        ForEach(EmoLvSection.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
            Button(action: {
                let formatter = ISO8601DateFormatter()
                mensInfoStore.addNewMensInfo(
                    mensInfo: MensInfo(id: UUID().uuidString, imperID: "abc123", mensAmt: mensAmt.rawValue, mensSymp: mensSymp.rawValue, emoLv: emoLv.rawValue, regDe: formatter.string(from: Date())))
            }, label: {
                Text("저장하기")
            })
        }
    }
}

struct ListCell: View {
    @State var mensInfo: MensInfo
    var mensInfoStore: MensInfoStore
    var body: some View {
        HStack {
            VStack {
                Text(mensInfo.mensAmt)
                Text(mensInfo.mensSymp)
                Text(mensInfo.emoLv)
                Text(mensInfo.regDe)
            }
            NavigationLink {
                EditView(mensInfoStore: mensInfoStore, selectedMensInfo: $mensInfo)
            } label: {
                Text("수정하기")
            }
        }
    }
}

//#Preview {
//    ImperMainView()
//}
