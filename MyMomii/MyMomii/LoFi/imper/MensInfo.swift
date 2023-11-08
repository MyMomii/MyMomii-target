//
//  MensInfo.swift
//  AhnNyeong
//
//  Created by jaelyung kim on 10/16/23.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

struct MensInfo: Codable, Identifiable, Hashable {
    var id: String
    var imperID: String
    var mensAmt: String
    var mensSymp: String
    var emoLv: String
    var regDe: String
}
