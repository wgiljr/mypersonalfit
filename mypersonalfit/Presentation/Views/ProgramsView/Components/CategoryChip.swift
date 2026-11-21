//
//  CategoryChip.swift
//  mypersonalfit
//

import SwiftUI

struct CategoryChip: View {
    let category: WorkoutCategory

    var body: some View {
        Text(category.displayName)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.black)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppColors.surface, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HStack(spacing: 8) {
        ForEach(WorkoutCategory.allCases) { CategoryChip(category: $0) }
    }
    .padding(20)
    .background(AppColors.background)
}
