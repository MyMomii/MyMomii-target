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
    var mensSymp: String
    var mensAmt: String
    var emoLv: String
    var dateOfMens: String
    var regDt: Date
}
