//
//  UserManager.swift
//  MyMomii
//
//  Created by jaelyung kim on 11/13/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let dateCreated: Date?
    let preferences: [String]?
    let favoriteMovie: Movie?
    let mensInfo: MensInfo?

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.dateCreated = Date()
        self.preferences = nil
        self.favoriteMovie = nil
        self.mensInfo = nil
    }

    init(
        userId: String,
        isAnonymous: Bool? = nil,
        dateCreated: Date? = nil,
        preferences: [String]? = nil,
        favoriteMovie: Movie? = nil,
        mensInfo: MensInfo? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.dateCreated = dateCreated
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
        self.mensInfo = mensInfo
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case dateCreated = "date_created"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
        case mensInfo = "mens_info"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
        self.mensInfo = try container.decodeIfPresent(MensInfo.self, forKey: .mensInfo)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
        try container.encodeIfPresent(self.mensInfo, forKey: .mensInfo)
    }

}

final class UserManager {

    static let shared = UserManager()
    private init() { }

    private let userCollection = Firestore.firestore().collection("users")

    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }

    private func userMensInfoCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("mens_info")
    }

    private func userMensInfoDocument(userId: String) -> DocumentReference {
        userMensInfoCollection(userId: userId).document()
    }

    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }

    func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }

    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayUnion([preference])
        ]

        try await userDocument(userId: userId).updateData(data)
    }

    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayRemove([preference])
        ]

        try await userDocument(userId: userId).updateData(data)
    }

    func addFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else {
            throw URLError(.badURL)
        }

        let dict: [String: Any] = [
            DBUser.CodingKeys.favoriteMovie.rawValue: data
        ]

        try await userDocument(userId: userId).updateData(dict)
    }

    func removeFavoriteMovie(userId: String) async throws {
        let data: [String: Any?] = [
            DBUser.CodingKeys.favoriteMovie.rawValue: nil
        ]

        try await userDocument(userId: userId).updateData(data as [AnyHashable: Any])
    }

    func addMensInfo(userId: String, mensInfo: MensInfo) async throws {
        guard let data = try? encoder.encode(mensInfo) else {
            throw URLError(.badURL)
        }

        let dict: [String: Any] = [
            DBUser.CodingKeys.mensInfo.rawValue: data
        ]

        try await userMensInfoDocument(userId: userId).setData(dict, merge: false)
    }

    func removeMensInfo(userId: String) async throws {
        let data: [String: Any?] = [
            DBUser.CodingKeys.mensInfo.rawValue: nil
        ]

        try await userMensInfoDocument(userId: userId).updateData(data as [AnyHashable: Any])
    }
}
