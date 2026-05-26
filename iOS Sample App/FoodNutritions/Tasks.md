# Tasks — FoodNutritions iOS App

> Auto-maintained task tracker. Updated as work progresses.
> **Design specs** for all UI screens are in `specs/screens/`.

---

## Legend

| Symbol | Meaning |
|--------|---------|
| [x] | Completed |
| [-] | In Progress |
| [ ] | Pending |
| [!] | Blocked / Halted |

---

## Phase 1: Project Scaffolding + Models (COMPLETED)

- [x] Create Xcode project via xcodegen
- [x] Create folder structure (App, Core, Features, Repositories, Resources)
- [x] AppConfig.swift — base URL, dev credentials, calorie goal
- [x] AuthManager.swift — @Observable auth state manager
- [x] FoodNutritionsApp.swift — @main entry point
- [x] MainTabView.swift — TabView shell (Diary, Search, Profile)
- [x] Recipe.swift — full PocketBase schema (40+ fields)
- [x] PackagedFood.swift — packaged food model
- [x] FoodLog.swift — PRD-matching food log model
- [x] FoodItem.swift — unified enum wrapping Recipe/PackagedFood
- [x] MealType.swift — breakfast/lunch/dinner/snack enum
- [x] FoodType.swift — recipe/packaged_food enum
- [x] AuthResponse.swift — token + UserRecord
- [x] APIClient.swift — GET/POST, bearer auth, thread-safe token
- [x] APIError.swift — typed error enum
- [x] PocketBaseResponse.swift — generic paginated response wrapper
- [x] Date+Formatting.swift — PocketBase date + display formatters
- [x] Double+Formatting.swift — calorie/macro string helpers
- [x] AuthRepository.swift — login via PocketBase auth endpoint
- [x] RecipeRepository.swift — search recipes
- [x] PackagedFoodRepository.swift — search packaged foods
- [x] FoodLogRepository.swift — fetch/create food logs
- [x] DiaryViewModel.swift — log aggregation, meal grouping
- [x] SearchViewModel.swift — debounced search, parallel API calls
- [x] AddFoodViewModel.swift — scaled macros, POST log
- [x] DiaryView.swift — diary screen (initial scaffold)
- [x] SearchView.swift — search screen (initial scaffold)
- [x] AddFoodView.swift — add food modal (initial scaffold)
- [x] FoodDetailView.swift — food detail screen (initial scaffold)
- [x] ProfileView.swift — profile placeholder (initial scaffold)
- [x] Initial build verified: BUILD SUCCEEDED

---

## Phase 2: Hardening — Networking, Repositories, ViewModels (COMPLETED)

### Critical Bugs

- [x] **BUG FIX**: MainTabView now reads `authManager.userId` from `@Environment` instead of passing `userId: ""`
- [x] **BUG FIX**: All ViewModels and AuthManager now annotated with `@MainActor` for thread-safe state mutations

### Networking Layer

- [x] APIClient: Added `delete()` method (returns Void for 204 responses)
- [x] APIClient: Added `patch<T, U>()` method
- [x] APIError: Added `.unauthorized`, `.forbidden`, `.notFound` cases
- [x] APIClient: `execute()` and `delete()` now map 401/403/404 via `mapHTTPError()`
- [x] APIClient: Added `#if DEBUG` request logging (`debugLog()`)

### Repositories

- [x] All filter queries sanitized — `sanitize()` escapes single quotes to prevent PocketBase injection
- [x] FoodLogRepository: Added `deleteLog(id:)` method
- [x] FoodLogRepository: Added `updateLog(_:)` method (PATCH)

### Models

- [x] FoodLog: Added `fiber: Double` field + CodingKey
- [x] AddFoodViewModel: `logFood()` now includes `fiber: scaledFiber` in FoodLog construction

### ViewModels

- [x] Added `@MainActor` to DiaryViewModel
- [x] Added `@MainActor` to SearchViewModel
- [x] Added `@MainActor` to AddFoodViewModel
- [x] Added `@MainActor` to AuthManager
- [x] SearchViewModel: Removed unused `import Combine`
- [x] DiaryViewModel: Added `removeLogLocally(_:)` for optimistic delete support

### Extensions

- [x] Date+Formatting: Cached `DateFormatter` instances as static properties, pinned locale to `en_US_POSIX`

### Build Verification

- [x] Rebuild project after all Phase 2 changes: BUILD SUCCEEDED

---

## Phase 3: Pagination Support (COMPLETED)

> Goal: Enable "load more" pattern for search results and support >100 food logs per day.

### New Model

- [x] Created `PaginatedResult<T>` struct — wraps items + page, totalPages, totalItems, hasMore

### Repository Changes

- [x] RecipeRepository: Added `search(query:, page:)` returning `PaginatedResult<Recipe>` (original non-paginated overload kept for backward compat)
- [x] PackagedFoodRepository: Added `search(query:, page:)` returning `PaginatedResult<PackagedFood>` (original non-paginated overload kept for backward compat)
- [x] FoodLogRepository: Added `fetchLogs(userId:, date:, page:)` returning `PaginatedResult<FoodLog>` (original non-paginated overload kept for backward compat)
- [x] Regenerated Xcode project via xcodegen to pick up new `PaginatedResult.swift`

### ViewModel Changes

- [x] SearchViewModel: Tracks page per source (recipePage/packagedPage), `canLoadMore` computed, `loadMore()` appends next pages, `resetPagination()` on new query, `isLoadingMore` state
- [x] DiaryViewModel: `loadLogs()` now uses paginated fetch, `loadMoreLogs()` appends next page, `canLoadMore` + `isLoadingMore` exposed

### Build Verification

- [x] Rebuild project after all Phase 3 changes: BUILD SUCCEEDED

---

## Phase 4: UI Views (COMPLETED)

> Design specs: `specs/screens/` — each file contains full component hierarchy,
> color tokens, typography, spacing, data requirements, and accessibility notes.
> Design system: "The Vitality Layer" — tonal surface layering, no hard borders, gradient CTAs.

### Design Infrastructure

- [x] DesignTokens.swift — DS enum with full color palette, spacing/radius constants, shadow helpers, primaryGradient, DSCard ViewModifier
- [x] Font+Theme.swift — Typography system (Manrope headlines, Inter body) with `.headline()`, `.body()`, `.label()` presets
- [x] DonutChartView.swift — Reusable ring chart component with configurable segments
- [x] MacroProgressBar.swift — Horizontal progress bar with tonal track/fill
- [x] GradientButton.swift — Primary CTA with 135deg gradient, pill shape, loading state
- [x] Manrope + Inter variable fonts bundled in `Resources/Fonts/`
- [x] project.yml updated with font registration (UIAppFonts) and NSAppTransportSecurity
- [x] Info.plist generated via xcodegen with font entries

### Screens

- [x] MainTabView.swift — 4-tab shell (Diary, Search, Progress, Profile) with DS.primary tint
- [x] ProgressTabView.swift — Placeholder "Coming Soon" tab
- [x] DiaryView.swift — Hero calorie donut card, macro quick view (2-col), meal cards with food items, FAB, date navigation with chevrons + calendar picker, swipe-to-delete, pull-to-refresh
- [x] SearchView.swift — Pill search bar, filter chips (All/Recipes/Packaged), result rows with inline add, load-more pagination trigger, navigationDestination for food detail
- [x] AddFoodView.swift — Bottom sheet with food hero, energy row + mini donut, macro bento, quantity stepper, meal chip selector, gradient CTA, preselectedMeal support
- [x] FoodDetailView.swift — 144pt donut, macro bento with progress bars, image spotlight placeholder, ALL 30+ micronutrients from Recipe model, nutrition insight card, ingredients section, serving adjuster, gradient CTA
- [x] ProfileView.swift — Profile hero (128pt avatar + edit badge), quick stats grid, settings list rows, sign out button with confirmation dialog, dynamic version from Bundle
- [x] FoodNutritionsApp.swift — DS-styled auth gate with gradient button, `.preferredColorScheme(.light)`

### Functional Enhancements

- [x] AuthManager.logout() — clears token, userId, userEmail, sets isAuthenticated = false
- [x] ProfileView sign out wired to authManager.logout()
- [x] DiaryView "+" button pre-selects meal type via selectedMealForAdd passed to SearchView
- [x] SearchView accepts preselectedMeal parameter, passes to AddFoodView
- [x] AddFoodView accepts preselectedMeal parameter, sets viewModel.mealType in onAppear
- [x] FoodItem.servingWeight extension — parses serving weight from servingSize string

### Build Verification

- [x] xcodegen generate: project regenerated successfully
- [x] xcodebuild build (iPhone 17 Pro Simulator, iOS 17.0): BUILD SUCCEEDED — zero errors

---

## Phase 5: App Entry + Navigation (COMPLETED)

> Goal: Scene lifecycle, glassmorphic nav bars, NavigationStack per tab, shared diary refresh.

- [x] Auth gating / loading / error states (completed in Phase 4 — FoodNutritionsApp.swift)
- [x] Scene phase observation — FoodNutritionsApp posts `.appDidBecomeActive` / `.appDidEnterBackground` / `.diaryNeedsRefresh` notifications via `onChange(of: scenePhase)`
- [x] Glassmorphic nav bars — MainTabView configures `UITabBarAppearance` with `UIBlurEffect(style: .systemUltraThinMaterial)` + white 80% alpha; DiaryView uses `.toolbarBackground(.ultraThinMaterial)`
- [x] NavigationStack per tab — all 4 tabs (Diary, Search, Progress, Profile) wrapped in NavigationStack
- [x] Shared diary refresh — AddFoodView posts `.diaryNeedsRefresh` notification with `toastMessage` userInfo on successful log; DiaryView listens via `.onReceive`

---

## Phase 6: Polish (COMPLETED)

> Goal: Optimistic UI, haptics, smart FAB, empty states, toast, skeleton shimmer, animations.

- [x] Optimistic UI on food logging — AddFoodView calls `diaryViewModel.addLogLocally()` instantly + posts refresh; DiaryView delete uses `removeLogLocally()` with server rollback on failure
- [x] Pull-to-refresh (completed in Phase 4 — DiaryView)
- [x] Bundle version reading instead of hardcoded "1.0.0" (completed in Phase 4 — ProfileView)
- [x] Haptic feedback — `UIImpactFeedbackGenerator` on tab switch, FAB tap, quantity stepper; `UINotificationFeedbackGenerator` on successful log/delete and errors
- [x] Smart FAB meal — `smartMealType` computed: breakfast (5-10am), lunch (10am-2pm), snack (2-5pm), dinner (5-10pm), snack otherwise
- [x] Empty meal states — each meal card shows "No foods logged" with meal icon when empty
- [x] Success toast — `ToastView` component (capsule with icon + message, auto-dismiss 2s) + `ToastModifier` + `.toast()` View extension
- [x] Skeleton shimmer — `ShimmerModifier`, `ShimmerRow`, `DiarySkeletonView` with animated gradient overlay; DiaryView shows skeleton while loading
- [x] Animated transitions — donut chart animates via `animateDonut`/`animateMacros` state flags with staggered delays; `contentTransition(.numericText)` on remaining calories
- [x] Build verification — xcodegen + xcodebuild (iPhone 17 Pro, iOS 26.2): BUILD SUCCEEDED — zero errors

### New Files Created

- [x] `FoodNutritions/Core/Components/ToastView.swift` — ToastView, ToastModifier, `.toast()` extension
- [x] `FoodNutritions/Core/Components/ShimmerView.swift` — ShimmerModifier, ShimmerRow, DiarySkeletonView, `.shimmer()` extension

### Files Modified

- [x] `FoodNutritions/App/FoodNutritionsApp.swift` — scenePhase observation, Notification.Name extensions
- [x] `FoodNutritions/App/MainTabView.swift` — NavigationStack per tab, glassmorphic tab bar, haptic on tab switch
- [x] `FoodNutritions/Features/Diary/DiaryView.swift` — skeleton, animated donut/macros, smart FAB, empty states, toast, optimistic delete, haptics, glassmorphic nav, scene phase refresh
- [x] `FoodNutritions/Features/AddFood/AddFoodView.swift` — optimistic UI, haptic feedback, toast notification post
- [x] `project.yml` — added shared scheme, disabled code signing for simulator builds

---

## Cross-Cutting Technical Debt

| # | Issue | Severity | File(s) | Status |
|---|-------|----------|---------|--------|
| 1 | No dependency injection — all repos use `APIClient.shared` | Medium | All repositories, all ViewModels | Open |
| 2 | No token persistence (Keychain/UserDefaults) | Low (MVP) | AuthManager | Open |
| 3 | No token refresh / expiry handling | Low (MVP) | AuthManager, APIClient | Open |
| 4 | ~~No logout functionality~~ | ~~Low (MVP)~~ | ~~AuthManager, ProfileView~~ | Fixed (Phase 4) |
| 5 | Recipe model over-defined (40+ fields, ~18 fetched, ~10 displayed) | Info | Recipe.swift, RecipeRepository | Open |
| 6 | No request retry logic on transient failures | Low | APIClient | Open |
| 7 | FoodItem.foodId redundant (same as id) | Info | FoodItem.swift | Open |
| 8 | ~~Unused `Combine` import~~ | ~~Info~~ | ~~SearchViewModel~~ | Fixed (Phase 2) |
| 9 | Deep link handling not implemented | Low (MVP) | FoodNutritionsApp | Open |
