//
//  FeaturedWorkoutCard.swift
//  mypersonalfit
//

import SwiftUI

struct FeaturedWorkoutCard: View {
    let featured: FeaturedWorkout
    var onStart: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading) {
            Text(featured.badge)
                .textStyle(.overline)
                .foregroundStyle(AppColors.textOnAccent)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.compact)
                .background(AppColors.accent, in: Capsule())

            Spacer(minLength: 0)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(featured.workout.title)
                        .textStyle(.heading)
                    Text(featured.workout.summary)
                        .textStyle(.caption)
                }
                .foregroundStyle(AppColors.textOnImage)

                Spacer(minLength: AppSpacing.sm)

                Button(action: onStart) {
                    Text("Start")
                        .textStyle(.button)
                        .foregroundStyle(AppColors.textStrong)
                        .padding(.horizontal, AppSpacing.xxxl)
                        .padding(.vertical, AppSpacing.lg)
                        .background(AppColors.accent, in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(AppSpacing.xxxl)
        .frame(maxWidth: .infinity)
        .frame(height: AppSize.heroCardHeight)
        .background {
            Image(featured.workout.imageName)
                .resizable()
                .scaledToFill()
                .overlay(AppColors.imageScrim)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    FeaturedWorkoutCard(
        featured: FeaturedWorkout(
            workout: Workout(
                id: "p", title: "Full Body", durationMinutes: 30, level: .intermediate,
                category: .strength, estimatedCalories: 320, trainerName: "Alex",
                imageName: "WorkoutFullBody"
            ),
            badge: "TODAY'S PICK"
        )
    )
    .padding(AppSpacing.xxxl)
    .background(AppColors.background)
}
