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
    @Published private(set) var mensInfosForSelectedDate: [MensInfo] = []

    func getAllMensInfos() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.mensInfos = try await UserManager.shared.getAllMensInfo(userId: authDataResult.uid)
    }

    func getMensInfoForSelectedDate(selectedDate: String) async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.mensInfosForSelectedDate = try await UserManager.shared.getMensInfoForSelectedDate(userId: authDataResult.uid, selectedDate: selectedDate)
    }
}
