//
//  SympViewModel.swift
//  MyMomii
//
//  Created by jaelyung kim on 11/14/23.
//

import Foundation
import SwiftUI

@MainActor
final class SympViewModel: ObservableObject {

    @Published private(set) var user: DBUser? = nil

    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }

    func addMensInfo(id: String, mensSymp: String, mensAmt: String, emoLv: String, dateOfMens: String) {
        guard let user else { return }
        let mensInfo = MensInfo(id: id, mensSymp: mensSymp, mensAmt: mensAmt, emoLv: emoLv, dateOfMens: dateOfMens, regDt: Date())
        Task {
            try await UserManager.shared.addMensInfo(userId: user.userId, mensInfo: mensInfo)
        }
    }
}
