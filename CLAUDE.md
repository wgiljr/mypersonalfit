# mypersonalfit

iOS fitness app (SwiftUI). Users browse workout programs; currently one real screen (Programs home, built from a Figma mock) plus an Account/Settings placeholder. No backend yet — all data is mocked behind repository protocols.

## Stack

- SwiftUI, iOS 18.2+ (iPhone + iPad), Swift 5 language mode, built with Xcode 27 (iOS 27 simulator SDK only)
- `@Observable` (Observation framework) + `async/await`. No Combine, no third-party dependencies (no SPM packages).
- Tests: XCTest (`mypersonalfitTests`, `mypersonalfitUITests`) — mostly template stubs today.
- Bundle ID: `gilwagner.mypersonalfit`. Single scheme: `mypersonalfit`.

## Commands

```bash
# Build
xcodebuild -scheme mypersonalfit -destination 'platform=iOS Simulator,name=iPhone 17' build -quiet

# Unit tests only (UI tests are slow; run them only when asked)
xcodebuild -scheme mypersonalfit -destination 'platform=iOS Simulator,name=iPhone 17' test -only-testing:mypersonalfitTests -quiet
```

Always build after changing Swift code. Use `-quiet` and grep for `error:` to keep output small.

#Lint
swiftlint

**Prefer MCP tools** (`build_sim`, `test_sim`) over these raw commands.
MCP returns structured JSON with categorized errors.

## Project layout

```
mypersonalfit/
  mypersonalfitApp.swift        @main entry -> ContentView
  Domain/Entities/              Plain models (Codable, Hashable, Identifiable). No SwiftUI imports.
  Data/Repositories/            Repository protocols + implementations (e.g. ProgramsRepository)
  Data/Sources/                 Data sources (Mock* today, network later)
  Presentation/
    DesignSystem/               Tokens: AppColors, AppTypography, AppSpacing, AppRadius, AppSize
    Views/ContentView.swift     Root TabView (Programs, Account)
    Views/<Feature>/            <Feature>View.swift, <Feature>ViewModel.swift, Components/
  Assets.xcassets               Images (workout photos), AppIcon, AccentColor
```

The Xcode project uses **file-system synchronized groups** (objectVersion 77): files added under `mypersonalfit/` are picked up automatically. **Never edit `project.pbxproj`** to add or remove source files.

## Architecture rules

Flow: `View -> ViewModel -> Repository (protocol) -> DataSource`.

- **Domain** entities are pure value types (`struct`/`enum`), `Codable` to match a future API response. Display helpers that are pure formatting (e.g. `displayName`, `summary`) may live on the entity.
- **Repositories**: define a protocol (`ProgramsRepository`), ship a `Mock…` implementation. Inject via the ViewModel initializer with the mock as the default argument — this keeps previews and tests working without setup.
- **ViewModels**: `@MainActor @Observable final class`, owned by the view with `@State private var viewModel = …`. Expose state as `private(set) var state: State` with an enum (`loading` / `loaded(T)` / `failed`). Async work via `func load() async`, triggered from `.task {}` and `.refreshable {}`.
- **Views** stay dumb: no data fetching, no business logic. Break large `body`s into `private func` helpers or components in `Components/`.
- **Components** take plain model values and closures (`var onStart: () -> Void = {}`), never a ViewModel.
- Pure logic that needs testing (e.g. `ProgramsViewModel.greeting(for:calendar:)`) takes its dependencies (date, calendar) as parameters with defaults.

## Design system (mandatory)

Never use raw literals for visual values in views. Use the tokens in `Presentation/DesignSystem/`:

| Need | Use | Not |
|---|---|---|
| Color | `AppColors.textPrimary`, `.accent`, `.surface`… | `Color.black`, `.gray`, `Color(hex:)` in views |
| Text | `.textStyle(.body)` (`AppTextStyle`) | `.font(.system(size: 13))` |
| Padding / gaps | `AppSpacing.lg`, `.screenHorizontal`, `.sectionGap` | `.padding(12)` |
| Corners | `AppRadius.md` / `.lg`, `Capsule()`, `Circle()` | `cornerRadius: 16` |
| Fixed sizes | `AppSize.avatar`, `.heroCardHeight` | `.frame(height: 226)` |

- Pick the closest existing token. Add a new token only when the design truly needs it, with a doc comment saying where it's used, and add it to `DesignSystemPreview.swift`.
- Typeface goes through `AppFont.font(size:weight:)` only (Inter will replace system font there).
- Design is light-only for now; don't add dark-mode variants unless asked.
- When implementing from Figma, map Figma values to existing tokens first.

## SwiftUI conventions

- Every view and component gets a `#Preview` with realistic inline data, `AppColors.background` behind it, and padding.
- Prefer modern APIs: `Tab(...)` in `TabView`, `.foregroundStyle`, `.background(_:in:)`, `.clipShape`, `ContentUnavailableView`, `NavigationStack` (not `NavigationView`), `@Observable` (not `ObservableObject`/`@Published`).
- `ForEach` over `Identifiable` models; no index-based `id: \.self` on model arrays.
- Accessibility: mark section titles `.accessibilityAddTraits(.isHeader)`, hide decorative images (`.accessibilityHidden(true)`), group cards with `.accessibilityElement(children: .combine/.contain)`.
- Images are asset-catalog names for now (`Workout.imageName`); will become remote URLs.
- User-facing strings are inline English literals for now (no localization yet).
- File header: the short 3-line `//  FileName.swift / //  mypersonalfit` comment like existing files.
- Prefer composition over large Views.
- Keep View bodies declarative.
- Move business logic out of View bodies.
- Avoid `AnyView`.
- Avoid excessive View extraction.
- Avoid custom property wrappers unless necessary.
- Prefer system SwiftUI components before custom components.
- Prefer `@Observable` for new observable reference types.
- Use `@State` for View-owned state.
- Use `@Environment` for shared dependencies.
- Avoid duplicating state between View and ViewModel.
- Avoid performing side effects directly during View initialization.
- Use `.task` for async work tied to View lifecycle.

## Concurrency

Use Swift structured concurrency.

Preferred:
- async/await
- Task
- async let
- actors
- MainActor

Avoid:
- DispatchQueue for new concurrency code
- completion handlers for new APIs
- Task.detached unless required
- unstructured global Tasks

UI state should be updated from MainActor-isolated code.

Do not silence concurrency warnings with unsafe annotations unless there is
a documented reason.

## Testing

- New ViewModel or repository logic → add XCTest unit tests in `mypersonalfitTests/` using a fake repository conforming to the protocol. Mark tests touching ViewModels `@MainActor`.
- Don't write UI tests unless asked.
- Do not write tests that simply test constructors or variable setting.
- Evaluate if a written test is truly validating business logic.
- Good tests should fail, if business logic changes.

## Working efficiently (agents)

- The codebase is small: read the specific file you need rather than searching broadly. `Programs` feature is the reference implementation — copy its patterns for new features.
- Ignore `xcuserdata/`, `*.xcassets/**/Contents.json`, and `project.pbxproj` unless the task is about them.
- Keep changes scoped to the request; don't refactor unrelated files or reformat.

## Git

- Branch off `main` for non-trivial work. Commit only when asked.
- Commit messages: imperative summary line, blank line, short body explaining what and why (see `git log`).
- Do not commit with 'by Claude', 'Claude' or anything like that

## Before Modifying Code

Before implementing a feature:

- Find the existing implementation closest to the requested behavior.
- Follow its established patterns.
- Reuse existing components and services.
- Check related tests.
- Only introduce new abstractions when existing ones are insufficient.

## Definition of Done

A task is complete when:

- The implementation matches existing architecture.
- Relevant tests are added or updated.
- The affected target builds successfully.
- Relevant tests pass.
- No unrelated files were modified.
- No new warnings were introduced.

## Important Constraints

- Do not add third-party dependencies without justification.
- Do not change the deployment target without explicit approval.
- Do not modify project architecture for a small feature.
- Do not rename public APIs unless required.
- Do not modify unrelated files.
- Prefer the smallest change that correctly solves the problem.
- Do not introduce Combine for new code.
- Do not introduce UIKit unless necessary.
- Do not create protocols solely for mocking.
- Do not create a repository layer unless the feature requires it.
- Do not add a dependency without approval.
- Do not refactor unrelated code.
- Do not create a new abstraction when an existing one is sufficient.