//
//  ProgramsView.swift
//  mypersonalfit
//
//  Created by Wagner Gil Jr. on 10/15/25.
//

import SwiftUI

struct ProgramsView: View {
    @State private var viewModel = ProgramsViewModel()

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let home):
                content(for: home)
            case .failed:
                ContentUnavailableView(
                    "Couldn't load workouts",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Pull down to try again.")
                )
            }
        }
        .task { await viewModel.load() }
    }

    private func content(for home: ProgramsHome) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                greeting(userName: home.userName)

                sectionTitle("Featured")
                FeaturedWorkoutCard(featured: home.featured)

                sectionTitle("Categories")
                HStack(spacing: 8) {
                    ForEach(home.categories) { CategoryChip(category: $0) }
                }

                sectionTitle("Popular workouts")
                HStack(alignment: .top, spacing: 12) {
                    ForEach(home.popularWorkouts) { WorkoutCard(workout: $0) }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 16)
        }
        .refreshable { await viewModel.load() }
    }

    private func greeting(userName: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(ProgramsViewModel.greeting())
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
                Text(userName)
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(AppColors.textPrimary)
            }
            Spacer()
            Circle()
                .fill(AppColors.textPrimary)
                .frame(width: 42, height: 42)
                .accessibilityHidden(true)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 17))
            .foregroundStyle(AppColors.textPrimary)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    ProgramsView()
}
