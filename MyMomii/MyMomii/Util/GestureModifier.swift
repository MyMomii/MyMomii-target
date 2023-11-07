//
//  GestureModifier.swift
//  AhnNyeong
//
//  Created by OhSuhyun on 2023.11.03.
//

import SwiftUI

struct GestureModifier: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension View {
    func backGesture() -> some View {
        modifier(BackGesture())
    }
}

struct BackGesture: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture().onEnded({ value in
            if value.translation.width > 1 {
                dismiss()
            }
        }))
    }
}

#Preview {
    GestureModifier()
}
