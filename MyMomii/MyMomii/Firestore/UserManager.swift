//
//  UserManager.swift
//  MyMomii
//
//  Created by jaelyung kim on 11/13/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let dateCreated: Date?
    let mensInfo: MensInfo?

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.dateCreated = Date()
        self.mensInfo = nil
    }

    init(
        userId: String,
        isAnonymous: Bool? = nil,
        dateCreated: Date? = nil,
        mensInfo: MensInfo? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.dateCreated = dateCreated
        self.mensInfo = mensInfo
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case dateCreated = "date_created"
        case mensInfo = "mens_info"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.mensInfo = try container.decodeIfPresent(MensInfo.self, forKey: .mensInfo)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
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

    private func userMensInfoDocument(userId: String, documentId: String) -> DocumentReference {
        userMensInfoCollection(userId: userId).document(documentId)
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

    func addMensInfo(userId: String, mensInfo: MensInfo) async throws {
        var document: DocumentReference

        if mensInfo.id == "" {
            document = userMensInfoDocument(userId: userId)
        } else {
            document = userMensInfoDocument(userId: userId, documentId: mensInfo.id)
        }
        let documentId = document.documentID

        let data: [String: Any] = [
            "id": mensInfo.id == "" ? documentId : mensInfo.id,
            "mensSymp": mensInfo.mensSymp,
            "mensAmt": mensInfo.mensAmt,
            "emoLv": mensInfo.emoLv,
            "dateOfMens": mensInfo.dateOfMens,
            "regDt": mensInfo.regDt
        ]

        if mensInfo.id == "" {
            try await document.setData(data, merge: false)
        } else {
            try await document.updateData(data as [AnyHashable: Any])
        }
    }

    func removeMensInfo(userId: String) async throws {
        let data: [String: Any?] = [
            DBUser.CodingKeys.mensInfo.rawValue: nil
        ]

        try await userMensInfoDocument(userId: userId).updateData(data as [AnyHashable: Any])
    }

    func getAllMensInfo(userId: String) async throws -> [MensInfo] {
        let snapshot = try await userMensInfoCollection(userId: userId).getDocuments()
        var mensInfos: [MensInfo] = []

        for document in snapshot.documents {
            let mensInfo = try document.data(as: MensInfo.self)
            mensInfos.append(mensInfo)
        }
        return mensInfos
    }

    func getMensInfoForSelectedDate(userId: String, selectedDate: String) async throws -> [MensInfo] {
        let snapshot = try await userMensInfoCollection(userId: userId).whereField("dateOfMens", isEqualTo: selectedDate).getDocuments()
        var mensInfos: [MensInfo] = []

        for document in snapshot.documents {
            let mensInfo = try document.data(as: MensInfo.self)
            mensInfos.append(mensInfo)
        }
        return mensInfos
    }
}
