//
//  WorkoutCard.swift
//  mypersonalfit
//

import SwiftUI

struct WorkoutCard: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Color.clear
                .frame(height: 100)
                .overlay {
                    Image(workout.imageName)
                        .resizable()
                        .scaledToFill()
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .accessibilityHidden(true)

            Text(workout.title)
                .font(.system(size: 13))
                .foregroundStyle(.black)

            Text(workout.summary)
                .font(.system(size: 10))
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
    .padding(20)
    .background(AppColors.background)
}
