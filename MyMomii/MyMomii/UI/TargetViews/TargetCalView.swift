//
//  TargetCalView.swift
//  AhnNyeong
//
//  Created by qwd on 11/1/23.
//

import SwiftUI

struct TargetCalView: View {
    @ObservedObject var selectedDe = SelectedDateViewModel()
    @State var isData: Bool
    @State var showModal: Bool
    var dDay: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(dDay>0 ? "생리 \(dDay)일 전)" : "생리 \(dDay+1)일 째")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.coral400)
                .padding(.top, 24)  // sample
            TargetCalWhiteRect(isData: $isData, showModal: $showModal)
                .padding(.top, 32)
//            Text("\(selectedDate)")
            Text("selectedDate: \(selectedDe.selectedDataContainer)")
                .onTapGesture {
                    print(selectedDe.selectedDataContainer)
//                    print("Selected Date: \(TargetCalendarView(model: selectedDe).getSelectedDate())")
                }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.white300)
        .sheet(isPresented: self.$showModal) {
            DailyEditView()
        }
    }
}

struct TargetCalWhiteRect: View {
    @ObservedObject var selectedDe = SelectedDateViewModel()
    @Binding var isData: Bool
    @Binding var showModal: Bool
    var body: some View {
        Rectangle()
            .cornerRadius(10)
            .foregroundColor(Color.white50)
            .frame(height: isData ? 580: 400)   // 120 차이
            .shadow(color: .black500.opacity(0.15), radius: 3.5, x: 0, y: 2)
            .overlay {
                VStack(alignment: .trailing, spacing: 0) {
                    TargetCalendarView(model: selectedDe)  // HARD coding
                        .frame(height: 560)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                    VStack(alignment: .trailing, spacing: 0) {
                        TargetCalRect(isData: $isData)
                        Button {
                            self.isData.toggle()
                            self.showModal = true
                        } label: {
                            Rectangle()
                                .cornerRadius(10)
                                .frame(width: 120, height: 45)
                                .foregroundColor(Color.coral500)
                                .overlay {
                                    HStack(spacing: 0) {
                                        Image(systemName: "square.and.pencil")
                                        Spacer()
                                        Text(isData ? "고치기" : "입력")
                                    }
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white50)
                                    .padding(.horizontal, 16)
                                }
                        }
                        .padding(.top, 16)
                    }
                    .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 32))
                    .padding(.top, -380)
                }
                .padding(.top, isData ? 0 : 180)    // 120 차이
            }
    }
}

struct TargetCalRect: View {
    @Binding var isData: Bool
    var body: some View {
        Rectangle()
            .cornerRadius(10)
            .frame(height: isData ? 280 : 100)
            .foregroundColor(.calToday)
            .shadow(color: .black500.opacity(0.25), radius: 2, x: 0, y:4)
            .overlay {
                if isData {
                    VStack(spacing: 0) {    // sample
                        MensData(mensImage: "Symp2", mensText: "배가 아파요")
                        MensData(mensImage: "MensAmt3", mensText: "생리양이 많아요")
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
}

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

struct TargetCalendarView: UIViewControllerRepresentable {
    typealias UIViewControllerType = TargetCalViewController
    @State private var selectedDate = Date()
    let model: SelectedDateViewModel

    func makeUIViewController(context: Context) -> TargetCalViewController {
        let targetCalViewController = TargetCalViewController()
        targetCalViewController.bridgeModel = self.model
        return targetCalViewController
    }

    func updateUIViewController(_ uiViewController: TargetCalViewController, context: Context) {
        // Update selectedDate based on the value from TargetCalViewController
        print(self.model.selectedDataContainer) // 전달하고자 하는 내용
        uiViewController.bridgeModel = self.model
    }
}

#Preview {
    TargetCalView(isData: false, showModal: false, dDay: 0)
}
