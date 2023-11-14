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
    var id: Date
    var mensSymp: String
    var mensAmt: String
    var emoLv: String
    var dateOfMens: Date
    var regDt: Date
}
