//
//  CategoryChip.swift
//  mypersonalfit
//

import SwiftUI

struct CategoryChip: View {
    let category: WorkoutCategory

    var body: some View {
        Text(category.displayName)
            .textStyle(.label)
            .foregroundStyle(AppColors.textStrong)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.xl)
            .background(AppColors.surface, in: RoundedRectangle(cornerRadius: AppRadius.md))
    }
}

#Preview {
    HStack(spacing: AppSpacing.sm) {
        ForEach(WorkoutCategory.allCases) { CategoryChip(category: $0) }
    }
    .padding(AppSpacing.xxxl)
    .background(AppColors.background)
}
