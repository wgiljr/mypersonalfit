//
//  AppTypography.swift
//  mypersonalfit
//

import SwiftUI

/// Raw type sizes (points) from the design.
enum AppFontSize {
    static let xxs: CGFloat = 10
    static let xs: CGFloat = 11
    static let sm: CGFloat = 12
    static let md: CGFloat = 13
    static let lg: CGFloat = 17
    static let xl: CGFloat = 25
    static let xxl: CGFloat = 28
}

/// Single place that decides the typeface.
/// The mock uses Inter, which isn't bundled yet. Once the font files are added,
/// change `font(size:weight:)` to return `.custom("Inter", size: size).weight(weight)`
/// and every text style updates at once.
enum AppFont {
    static func font(size: CGFloat, weight: Font.Weight) -> Font {
        .system(size: size, weight: weight)
    }
}

/// Semantic text styles. Prefer these over setting size and weight by hand:
/// `Text("Maria").textStyle(.display)`.
enum AppTextStyle {
    /// Screen title, e.g. the user's name.
    case display
    /// Hero card title.
    case heading
    /// Section titles.
    case title
    /// Default body and card titles.
    case body
    /// Buttons.
    case button
    /// Secondary lines such as workout meta on a hero card.
    case caption
    /// Small meta text under cards.
    case captionSmall
    /// Chips and compact labels.
    case label
    /// Tab bar labels.
    case tabLabel
    /// Tiny uppercase badges.
    case overline

    var font: Font {
        switch self {
        case .display: AppFont.font(size: AppFontSize.xxl, weight: .heavy)
        case .heading: AppFont.font(size: AppFontSize.xl, weight: .heavy)
        case .title: AppFont.font(size: AppFontSize.lg, weight: .regular)
        case .body: AppFont.font(size: AppFontSize.md, weight: .regular)
        case .button: AppFont.font(size: AppFontSize.md, weight: .heavy)
        case .caption: AppFont.font(size: AppFontSize.sm, weight: .regular)
        case .captionSmall: AppFont.font(size: AppFontSize.xxs, weight: .regular)
        case .label: AppFont.font(size: AppFontSize.xxs, weight: .bold)
        case .tabLabel: AppFont.font(size: AppFontSize.xs, weight: .bold)
        case .overline: AppFont.font(size: AppFontSize.xxs, weight: .heavy)
        }
    }
}

extension View {
    func textStyle(_ style: AppTextStyle) -> some View {
        font(style.font)
    }
}
