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
                .font(.system(size: 10, weight: .heavy))
                .foregroundStyle(AppColors.textPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(AppColors.accent, in: Capsule())

            Spacer(minLength: 0)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(featured.workout.title)
                        .font(.system(size: 25, weight: .heavy))
                    Text(featured.workout.summary)
                        .font(.system(size: 12))
                }
                .foregroundStyle(.white)

                Spacer(minLength: 8)

                Button(action: onStart) {
                    Text("Start")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(AppColors.accent, in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .frame(height: 226)
        .background {
            Image(featured.workout.imageName)
                .resizable()
                .scaledToFill()
                .overlay(Color.black.opacity(0.38))
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
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
    .padding(20)
    .background(AppColors.background)
}
