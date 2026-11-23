//
//  DesignSystemPreview.swift
//  mypersonalfit
//

import SwiftUI

/// Xcode-preview-only gallery of every token. Open the canvas to review the system.
private struct DesignSystemGallery: View {
    private let colors: [(String, Color)] = [
        ("background", AppColors.background),
        ("surface", AppColors.surface),
        ("textPrimary", AppColors.textPrimary),
        ("textSecondary", AppColors.textSecondary),
        ("textStrong", AppColors.textStrong),
        ("textOnImage", AppColors.textOnImage),
        ("accent", AppColors.accent),
        ("accentStrong", AppColors.accentStrong),
        ("border", AppColors.border)
    ]

    private let styles: [(String, AppTextStyle)] = [
        ("display", .display), ("heading", .heading), ("title", .title),
        ("body", .body), ("button", .button), ("caption", .caption),
        ("captionSmall", .captionSmall), ("label", .label),
        ("tabLabel", .tabLabel), ("overline", .overline)
    ]

    private let spacing: [(String, CGFloat)] = [
        ("xxs", AppSpacing.xxs), ("xs", AppSpacing.xs), ("compact", AppSpacing.compact),
        ("sm", AppSpacing.sm), ("md", AppSpacing.md), ("lg", AppSpacing.lg),
        ("xl", AppSpacing.xl), ("xxl", AppSpacing.xxl), ("xxxl", AppSpacing.xxxl)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.sectionGap) {
                section("Colors") {
                    ForEach(colors, id: \.0) { name, color in
                        HStack(spacing: AppSpacing.lg) {
                            RoundedRectangle(cornerRadius: AppRadius.md)
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppRadius.md)
                                        .stroke(AppColors.border)
                                )
                            Text(name).textStyle(.body)
                        }
                    }
                }

                section("Text styles") {
                    ForEach(styles, id: \.0) { name, style in
                        Text(name).textStyle(style)
                    }
                }

                section("Spacing") {
                    ForEach(spacing, id: \.0) { name, value in
                        HStack(spacing: AppSpacing.lg) {
                            Text("\(name) · \(Int(value))")
                                .textStyle(.caption)
                                .frame(width: 90, alignment: .leading)
                            Rectangle()
                                .fill(AppColors.accentStrong)
                                .frame(width: value * 4, height: AppSpacing.sm)
                        }
                    }
                }

                section("Radius") {
                    HStack(spacing: AppSpacing.xxl) {
                        radiusSample("md", AppRadius.md)
                        radiusSample("lg", AppRadius.lg)
                    }
                }
            }
            .padding(AppSpacing.xxxl)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(AppColors.textPrimary)
        .background(AppColors.background)
    }

    private func section<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text(title).textStyle(.heading)
            content()
        }
    }

    private func radiusSample(_ name: String, _ radius: CGFloat) -> some View {
        VStack(spacing: AppSpacing.sm) {
            RoundedRectangle(cornerRadius: radius)
                .fill(AppColors.surface)
                .frame(width: 80, height: 80)
                .overlay(RoundedRectangle(cornerRadius: radius).stroke(AppColors.border))
            Text("\(name) · \(Int(radius))").textStyle(.caption)
        }
    }
}

#Preview("Design System") {
    DesignSystemGallery()
}
