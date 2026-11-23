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
            VStack(alignment: .leading, spacing: AppSpacing.sectionGap) {
                greeting(userName: home.userName)

                sectionTitle("Featured")
                FeaturedWorkoutCard(featured: home.featured)

                sectionTitle("Categories")
                HStack(spacing: AppSpacing.sm) {
                    ForEach(home.categories) { CategoryChip(category: $0) }
                }

                sectionTitle("Popular workouts")
                HStack(alignment: .top, spacing: AppSpacing.lg) {
                    ForEach(home.popularWorkouts) { WorkoutCard(workout: $0) }
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.top, AppSpacing.xl)
            .padding(.bottom, AppSpacing.xxl)
        }
        .refreshable { await viewModel.load() }
    }

    private func greeting(userName: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(ProgramsViewModel.greeting())
                    .textStyle(.body)
                    .foregroundStyle(AppColors.textSecondary)
                Text(userName)
                    .textStyle(.display)
                    .foregroundStyle(AppColors.textPrimary)
            }
            Spacer()
            Circle()
                .fill(AppColors.textPrimary)
                .frame(width: AppSize.avatar, height: AppSize.avatar)
                .accessibilityHidden(true)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .textStyle(.title)
            .foregroundStyle(AppColors.textPrimary)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    ProgramsView()
}
