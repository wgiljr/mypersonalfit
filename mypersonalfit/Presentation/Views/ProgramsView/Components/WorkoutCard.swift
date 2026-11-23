//
//  WorkoutCard.swift
//  mypersonalfit
//

import SwiftUI

struct WorkoutCard: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Color.clear
                .frame(height: AppSize.cardImageHeight)
                .overlay {
                    Image(workout.imageName)
                        .resizable()
                        .scaledToFill()
                }
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .accessibilityHidden(true)

            Text(workout.title)
                .textStyle(.body)
                .foregroundStyle(AppColors.textStrong)

            Text(workout.summary)
                .textStyle(.captionSmall)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    WorkoutCard(
        workout: Workout(
            id: "p", title: "Lower Body", durationMinutes: 25, level: .beginner,
            category: .strength, estimatedCalories: 240, trainerName: "Sam",
            imageName: "WorkoutLowerBody"
        )
    )
    .frame(width: 169)
    .padding(AppSpacing.xxxl)
    .background(AppColors.background)
}
