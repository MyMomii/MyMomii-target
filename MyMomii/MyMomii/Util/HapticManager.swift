//
//  HapticManager.swift
//  MyMomii
//
//  Created by jaelyung kim on 11/21/23.
//

import SwiftUI

class HapticManager {

    static let instance = HapticManager()

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct HapticExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // 원하는 세기 맞춰서 쓰세요 ~
            Button("heavy") { HapticManager.instance.impact(style: .heavy) }
            Button("light") { HapticManager.instance.impact(style: .light) }
            Button("medium") { HapticManager.instance.impact(style: .medium) }
            Button("rigid") { HapticManager.instance.impact(style: .rigid) }
            Button("soft") { HapticManager.instance.impact(style: .soft) }
        }
    }
}

#Preview {
    HapticExample()
}
