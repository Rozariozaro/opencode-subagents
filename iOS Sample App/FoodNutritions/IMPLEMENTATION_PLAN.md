# Implementation Plan: FoodNutritions iOS App

## Summary of Decisions

- **Auth**: Hardcode email/password in config, call PocketBase auth endpoint on launch, extract token + user ID
- **User**: `rozariorapheal@gmail.com` (password placeholder to fill in)
- **Base URL**: `https://pocketbase.rapheal.in`
- **iOS Target**: 17+ (enables `@Observable` macro)
- **food_logs**: Already exists in PocketBase
- **Project**: Created via CLI

---

## Phase 1: Project Scaffolding + Models

### 1.1 Create Xcode project via CLI

- iOS app target with SwiftUI lifecycle
- Deployment target: iOS 17.0
- Bundle ID: `com.antigravity.FoodNutritions`

### 1.2 Folder Structure

```
FoodNutritions/
  App/
    FoodNutritionsApp.swift
    AppConfig.swift
  Core/
    Networking/
      APIClient.swift
      APIError.swift
      PocketBaseResponse.swift
    Models/
      Recipe.swift
      PackagedFood.swift
      FoodLog.swift
      FoodItem.swift
      MealType.swift
      FoodType.swift
      AuthResponse.swift
    Extensions/
      Date+Formatting.swift
      Double+Formatting.swift
  Features/
    Diary/
      DiaryView.swift
      DiaryViewModel.swift
    Search/
      SearchView.swift
      SearchViewModel.swift
    AddFood/
      AddFoodView.swift
      AddFoodViewModel.swift
    FoodDetail/
      FoodDetailView.swift
      FoodDetailViewModel.swift
    Profile/
      ProfileView.swift
  Repositories/
    AuthRepository.swift
    RecipeRepository.swift
    PackagedFoodRepository.swift
    FoodLogRepository.swift
  Resources/
    Assets.xcassets
specs/
  screens/
    diary_screen.md
    search_screen.md
    add_food_modal.md
    food_detail_screen.md
    profile_settings_screen.md
```

### 1.3 Data Models

- **Recipe**: Full schema from OpenAPI spec (all micronutrients optional)
- **PackagedFood**: `id, type, code_or_barcode, name, brand, calories, carbs, protein, fat, fiber, calcium_mg, iron_mg, sodium_mg, source`
- **FoodLog**: `id, user, date, meal_type, food_type, food_id, food_name, quantity, calories, protein, carbs, fat`
- **FoodItem**: Unified enum `case recipe(Recipe) | case packagedFood(PackagedFood)` with computed properties
- **MealType**: Enum `breakfast, lunch, dinner, snack`
- **FoodType**: Enum `recipe, packaged_food`
- **AuthResponse**: `token: String`, `record: UserRecord`

---

## Phase 2: Networking Layer

### APIClient

- Configurable `baseURL` from `AppConfig`
- Stored auth token (set after login)
- `func get<T: Decodable>(path:, queryItems:) async throws -> T`
- `func post<T: Decodable, U: Encodable>(path:, body:) async throws -> T`
- Uses `URLSession.shared`
- Adds `Authorization: Bearer <token>` header
- JSON decoder with snake_case key strategy
- Typed `APIError` enum

### PocketBaseResponse<T>

- Generic wrapper: `page, perPage, totalItems, totalPages, items: [T]`

---

## Phase 3: Repositories

- **AuthRepository**: `login(email:, password:) async throws -> AuthResponse`
- **RecipeRepository**: `search(query:) async throws -> [Recipe]`
- **PackagedFoodRepository**: `search(query:) async throws -> [PackagedFood]`
- **FoodLogRepository**: `fetchLogs(userId:, date:) async throws -> [FoodLog]`, `createLog(_:) async throws -> FoodLog`

---

## Phase 4: Features — ViewModels + UI Views

### Design Specs

All UI views reference the Stitch design specs in `specs/screens/`. Each spec
contains the exact component hierarchy, color tokens, typography, spacing,
data requirements, user intents, and accessibility notes.

| Feature       | Design Spec                                  |
|---------------|----------------------------------------------|
| Diary         | [`specs/screens/diary_screen.md`](specs/screens/diary_screen.md) |
| Search        | [`specs/screens/search_screen.md`](specs/screens/search_screen.md) |
| Add Food      | [`specs/screens/add_food_modal.md`](specs/screens/add_food_modal.md) |
| Food Detail   | [`specs/screens/food_detail_screen.md`](specs/screens/food_detail_screen.md) |
| Profile       | [`specs/screens/profile_settings_screen.md`](specs/screens/profile_settings_screen.md) |

### 4.1 Diary

- DiaryViewModel: fetches today's logs, groups by meal type, aggregates totals
- DiaryView: Calorie ring, macro progress bars, meal cards with food items, FAB, date navigation
  - Spec: `specs/screens/diary_screen.md`

### 4.2 Search

- SearchViewModel: debounced search (300ms), merges recipes + packaged foods
- SearchView: Multi-item search bar, barcode scanner, filter chips, recent foods grid, result rows with inline add
  - Spec: `specs/screens/search_screen.md`

### 4.3 Add Food

- AddFoodViewModel: selected food, quantity, meal type, computed macros, POST log
- AddFoodView: Bottom sheet modal — food hero, macro bento, quantity stepper, meal selector, gradient CTA
  - Spec: `specs/screens/add_food_modal.md`

### 4.4 Food Detail

- FoodDetailView: Donut chart, macro cards with progress bars, image spotlight, micronutrients list, nutrition insight, inline serving adjuster + add CTA
  - Spec: `specs/screens/food_detail_screen.md`

### 4.5 Profile

- ProfileView: Profile hero, quick stats grid (streak, weight lost), settings list, sign out
  - Spec: `specs/screens/profile_settings_screen.md`

---

## Phase 5: App Entry + Navigation

- Auth gating / loading / error states
- TabView: Diary, Search, Progress, Profile (4 tabs per design spec)
- NavigationStack per tab
- .sheet for AddFood modal (bottom sheet presentation)
- Shared diary refresh callback

---

## Phase 6: Polish

- Optimistic UI update on food logging
- No full-screen reloads
- <5s logging flow
- Pull-to-refresh on diary
- Glassmorphic nav bars (white/80% + backdrop blur)
- Gradient primary buttons (primary → primary-container at 135°)
- Tonal surface layering per design system (no hard borders)

---

## Key Architecture Decisions

1. `@Observable` macro (iOS 17) -- no `@Published` boilerplate
2. No third-party dependencies -- pure Foundation URLSession
3. snake_case decoding via `JSONDecoder.keyDecodingStrategy`
4. Unified `FoodItem` enum for merged search results
5. Optimistic UI on food logging for instant diary refresh
6. ~25 Swift files total
7. UI implementation follows Stitch design specs in `specs/screens/` — "The Vitality Layer" design system
8. Tonal surface layering (no hard borders), glassmorphic nav bars, gradient CTAs per design system
9. 4-tab navigation: Diary, Search, Progress, Profile
