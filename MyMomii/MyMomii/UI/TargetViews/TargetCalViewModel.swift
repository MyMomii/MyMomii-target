//
//  TargetCalViewModel.swift
//  MyMomii
//
//  Created by jaelyung kim on 11/15/23.
//

import SwiftUI

@MainActor
final class TargetCalViewModel: ObservableObject {

    @Published private(set) var mensInfos: [MensInfo] = []

    func getAllMensInfos() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.mensInfos = try await UserManager.shared.getAllMensInfo(userId: authDataResult.uid)
    }
}
