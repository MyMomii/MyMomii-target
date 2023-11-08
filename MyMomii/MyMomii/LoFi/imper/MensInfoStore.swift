//
//  MensInfoStore.swift
//  AhnNyeong
//
//  Created by jaelyung kim on 10/16/23.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class MensInfoStore: ObservableObject {
    @Published var mensInfos: [MensInfo] = []
    let ref: DatabaseReference? = Database.database().reference()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    func listenToRealtimeDatabase() {
        guard let databasePath = ref?.child("mensInfos").queryOrdered(byChild: "regDe") else {
            return
        }
        databasePath
            .observe(.childAdded) { [weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let mensInfoData = try JSONSerialization.data(withJSONObject: json)
                    let mensInfo = try self.decoder.decode(MensInfo.self, from: mensInfoData)
                    self.mensInfos.append(mensInfo)
                } catch {
                    print("an error occurred", error)
                }
            }
        databasePath
            .observe(.childChanged) {[weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let mensInfoData = try JSONSerialization.data(withJSONObject: json)
                    let mensInfo = try self.decoder.decode(MensInfo.self, from: mensInfoData)
                    var index = 0
                    for mensInfoItem in self.mensInfos {
                        if mensInfo.id == mensInfoItem.id {
                            break
                        } else {
                            index += 1
                        }
                    }
                    self.mensInfos[index] = mensInfo
                } catch {
                    print("an error occurred", error)
                }
            }
        databasePath
            .observe(.childRemoved) {[weak self] snapshot in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let mensInfoData = try JSONSerialization.data(withJSONObject: json)
                    let mensInfo = try self.decoder.decode(MensInfo.self, from: mensInfoData)
                    for (index, mensInfoItem) in self.mensInfos.enumerated() where mensInfo.id == mensInfoItem.id {
                        self.mensInfos.remove(at: index)
                    }
                } catch {
                    print("an error occurred", error)
                }
            }
    }
    func stopListening() {
        ref?.removeAllObservers()
    }
    func addNewMensInfo(mensInfo: MensInfo) {
        self.ref?.child("mensInfos").child("\(mensInfo.id)").setValue([
            "id": mensInfo.id,
            "imperID": mensInfo.imperID,
            "mensAmt": mensInfo.mensAmt,
            "mensSymp": mensInfo.mensSymp,
            "emoLv": mensInfo.emoLv,
            "regDe": mensInfo.regDe
        ])
    }
    func deleteMensInfo(key: String) {
        ref?.child("mensInfos/\(key)").removeValue()
    }
    func editMensInfo(mensInfo: MensInfo) {
        let updates: [String: Any] = [
            "id": mensInfo.id,
            "imperID": mensInfo.imperID,
            "mensAmt": mensInfo.mensAmt,
            "mensSymp": mensInfo.mensSymp,
            "emoLv": mensInfo.emoLv,
            "regDe": mensInfo.regDe
        ]
        let childUpdates = ["mensInfos/\(mensInfo.id)": updates]
        for (index, mensInfoItem) in mensInfos.enumerated() where mensInfoItem.id == mensInfo.id {
            mensInfos[index] = mensInfo
        }
        self.ref?.updateChildValues(childUpdates)
    }
}
