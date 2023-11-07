//
//  TextModifier.swift
//  AhnNyeong
//
//  Created by jaelyung kim on 11/1/23.
//

import SwiftUI

struct TextModifier: View {
    var body: some View {
        Text("Hello, World!")
            .heavy32Black400()
    }
}

// MARK: - Weight(Regular/Medium/SemiBold/Bold/Heavy) + Size(12 to 32) + Color (Coral/Black/White)
extension Text {
    // MARK: - Regular
    func regular12Black500() -> some View {
        modifier(Regular12Black500())
    }
    func regular17Coral500() -> some View {
        modifier(Regular17Coral500())
    }
    func regular18Black75() -> some View {
        modifier(Regular18Black75())
    }
    func regular18Black500() -> some View {
        modifier(Regular18Black500())
    }
    func regular26Coral500() -> some View {
        modifier(Regular26Coral500())
    }
    // MARK: - Medium
    func medium12Black300() -> some View {
        modifier(Medium12Black300())
    }
    func medium12Black400() -> some View {
        modifier(Medium12Black400())
    }
    func medium16White50() -> some View {
        modifier(Medium16White50())
    }
    func medium16Black300() -> some View {
        modifier(Medium16Black300())
    }
    func medium16Black500() -> some View {
        modifier(Medium16Black500())
    }
    func medium22Black500() -> some View {
        modifier(Medium22Black500())
    }
    // MARK: - SemiBold
    func semiBold12Black200() -> some View {
        modifier(SemiBold12Black200())
    }
    func semiBold12Coral500() -> some View {
        modifier(SemiBold12Coral500())
    }
    func semiBold12White50() -> some View {
        modifier(SemiBold12White50())
    }
    func semiBold15Black400() -> some View {
        modifier(SemiBold15Black400())
    }
    func semiBold15Coral500() -> some View {
        modifier(SemiBold15Coral500())
    }
    func semiBold15Black100() -> some View {
        modifier(SemiBold15Black100())
    }
    func semiBold16Black75() -> some View {
        modifier(SemiBold16Black75())
    }
    func semiBold16Black400() -> some View {
        modifier(SemiBold16Black400())
    }
    func semiBold16Coral500() -> some View {
        modifier(SemiBold16Coral500())
    }
    func semiBold17Coral500() -> some View {
        modifier(SemiBold17Coral500())
    }
    func semiBold18Black500() -> some View {
        modifier(SemiBold18Black500())
    }
    func semiBold18Coral100() -> some View {
        modifier(SemiBold18Coral100())
    }
    func semiBold18Coral500() -> some View {
        modifier(SemiBold18Coral500())
    }
    func semiBold18White50() -> some View {
        modifier(SemiBold18White50())
    }
    func semiBold18White75() -> some View {
        modifier(SemiBold18White75())
    }
    func semiBold20Coral500() -> some View {
        modifier(SemiBold20Coral500())
    }
    func semiBold20White50() -> some View {
        modifier(SemiBold20White50())
    }
    func semiBold24Coral500() -> some View {
        modifier(SemiBold24Coral500())
    }
    func semiBold24Black400() -> some View {
        modifier(SemiBold24Black400())
    }
    func semiBold32Black400() -> some View {
        modifier(SemiBold32Black400())
    }
    // MARK: - Bold
    func bold14Black300() -> some View {
        modifier(Bold14Black300())
    }
    func bold14Black500() -> some View {
        modifier(Bold14Black500())
    }
    func bold14Coral500() -> some View {
        modifier(Bold14Coral500())
    }
    func bold14CalWeekday() -> some View {
        modifier(Bold14CalWeekday())
    }
    func bold16White50() -> some View {
        modifier(Bold16White50())
    }
    func bold18White50() -> some View {
        modifier(Bold18White50())
    }
    func bold18Black400() -> some View {
        modifier(Bold18Black400())
    }
    func bold20Coral500() -> some View {
        modifier(Bold20Coral500())
    }
    func bold22Black500() -> some View {
        modifier(Bold22Black500())
    }
    func bold22Coral400() -> some View {
        modifier(Bold22Coral400())
    }
    func bold24White50() -> some View {
        modifier(Bold24White50())
    }
    func bold24Black300() -> some View {
        modifier(Bold24Black300())
    }
    func bold24Black400() -> some View {
        modifier(Bold24Black400())
    }
    func bold24Black500() -> some View {
        modifier(Bold24Black500())
    }
    func bold28Black400() -> some View {
        modifier(Bold28Black400())
    }
    func bold28Black500() -> some View {
        modifier(Bold28Black500())
    }
    func bold30Black400() -> some View {
        modifier(Bold30Black400())
    }
    func bold30Coral500() -> some View {
        modifier(Bold30Coral500())
    }
    // MARK: - Heavy
    func heavy32Black400() -> some View {
        modifier(Heavy32Black400())
    }
}

struct Regular12Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.black500)
    }
}

struct Regular17Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.coral500)
    }
}

struct Regular18Black75: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.black75)
    }
}

struct Regular18Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.black500)
    }
}

struct Regular26Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 26, weight: .regular))
            .foregroundColor(.coral500)
    }
}

struct Medium12Black300: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.black300)
    }
}

struct Medium12Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.black400)
    }
}

struct Medium16White50: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white50)
    }
}

struct Medium16Black300: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.black300)
    }
}

struct Medium16Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.black500)
    }
}

struct Medium22Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .medium))
            .foregroundColor(.black500)
    }
}

struct SemiBold12Black200: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.black200)
    }
}

struct SemiBold12Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.coral500)
    }
}

struct SemiBold12White50: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white50)
    }
}

struct SemiBold15Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.black400)
    }
}

struct SemiBold15Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.coral500)
    }
}

struct SemiBold15Black100: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.black100)
    }
}

struct SemiBold16Black75: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.black75)
    }
}

struct SemiBold16Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.black400)
    }
}

struct SemiBold16Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.coral500)
    }
}

struct SemiBold17Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.coral500)
    }
}

struct SemiBold18Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.black500)
    }
}

struct SemiBold18Coral100: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.coral100)
    }
}

struct SemiBold18Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.coral500)
    }
}

struct SemiBold18White50: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white50)
    }
}

struct SemiBold18White75: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white75)
    }
}

struct SemiBold20Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.coral500)
    }
}

struct SemiBold20White50: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.white50)
    }
}

struct SemiBold24Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(.coral500)
    }
}

struct SemiBold24Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(.black400)
    }
}

struct SemiBold32Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .semibold))
            .foregroundColor(.black400)
    }
}

struct Bold14Black300: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.black300)
    }
}

struct Bold14Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.black500)
    }
}

struct Bold14Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.coral500)
    }
}

struct Bold14CalWeekday: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.calWeekday)
    }
}

struct Bold16White50: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white50)
    }
}

struct Bold18White50: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white50)
    }
}

struct Bold18Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.black400)
    }
}

struct Bold20Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.coral500)
    }
}

struct Bold22Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.black500)
    }
}

struct Bold22Coral400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.coral400)
    }
}

struct Bold24White50: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white50)
    }
}

struct Bold24Black300: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.black300)
    }
}

struct Bold24Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.black400)
    }
}

struct Bold24Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.black500)
    }
}

struct Bold28Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.black400)
    }
}

struct Bold28Black500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.black500)
    }
}

struct Bold30Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.black400)
    }
}

struct Bold30Coral500: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.coral500)
    }
}

struct Heavy32Black400: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .heavy))
            .foregroundColor(.black400)
    }
}

#Preview {
    TextModifier()
}
