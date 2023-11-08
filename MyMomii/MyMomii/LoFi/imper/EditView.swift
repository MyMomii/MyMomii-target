//
//  EditView.swift
//  AhnNyeong
//
//  Created by jaelyung kim on 10/18/23.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var mensInfoStore: MensInfoStore
    @Binding var selectedMensInfo: MensInfo
    var body: some View {
        VStack {
            VStack(alignment: HorizontalAlignment.leading) {
                Text("imperID")
                    .font(.headline)
                TextField("Enter imperID", text: $selectedMensInfo.imperID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            Button {
                let editMensInfo = MensInfo(
                    id: selectedMensInfo.id,
                    imperID: selectedMensInfo.imperID,
                    mensAmt: selectedMensInfo.mensAmt,
                    mensSymp: selectedMensInfo.mensSymp,
                    emoLv: selectedMensInfo.emoLv,
                    regDe: selectedMensInfo.regDe
                )
                mensInfoStore.editMensInfo(mensInfo: editMensInfo)
                self.mode.wrappedValue.dismiss()
            } label: {
                Text("확인")
            }
        }
    }
}

//#Preview {
//    EditView()
//}
