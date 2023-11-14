//
//  AuthenticationManager.swift
//  MyMomii
//
//  Created by jaelyung kim on 11/14/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let isAnonymous: Bool

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.isAnonymous = user.isAnonymous
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }

    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }

        return AuthDataResultModel(user: user)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await user.delete()
    }
}

// MARK: SIGN IN EMAIL
extension AuthenticationManager {

    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

// MARK: SIGN IN ANONYMOUS
extension AuthenticationManager {
    
    @discardableResult
    func signInAnonymous() async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user)
    }
}
