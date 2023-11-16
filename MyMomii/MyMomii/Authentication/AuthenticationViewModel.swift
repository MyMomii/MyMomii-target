//
//  AuthenticationViewModel.swift
//  MyMomii
//
//  Created by jaelyung kim on 11/14/23.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
}
