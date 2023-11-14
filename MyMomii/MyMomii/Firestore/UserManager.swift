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

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.dateCreated = Date()
        self.preferences = nil
        self.favoriteMovie = nil
    }

    init(
        userId: String,
        isAnonymous: Bool? = nil,
        dateCreated: Date? = nil,
        preferences: [String]? = nil,
        favoriteMovie: Movie? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.dateCreated = dateCreated
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case dateCreated = "date_created"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
    }

}

final class UserManager {

    static let shared = UserManager()
    private init() { }

    private let userCollection = Firestore.firestore().collection("users")

    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
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

//    func createNewUser(userId: String) async throws {
//        var userData: [String: Any] = [
//            "user_id": userId,
//            "is_anonymous": true,
//            "date_created": Timestamp()
//        ]
//
//        try await userDocument(userId: userId).setData(userData, merge: false)
//    }

//    func getUser(userId: String) async throws -> DBUser {
//        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
//    }

    func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }

//    func getUser(userId: String) async throws -> DBUser {
//        let snapshot = try await userDocument(userId: userId).getDocument()
//
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//
//        let isAnonymous = data["is_anonymous"] as? Bool
//        let dateCreated = data["date_created"] as? Date
//
//        return DBUser(userId: userId, isAnonymous: isAnonymous, dateCreated: dateCreated)
//    }

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
}
