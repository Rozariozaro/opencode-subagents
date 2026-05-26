# PRD --- MVP: Daily Meal Logging (Food Nutrition App)

## 1. Objective

Deliver a low-latency, mobile-first meal logging system enabling: - Food
search (recipes + packaged foods) - Meal logging - Daily macro tracking

Constraint: Directly use PocketBase APIs (no custom backend).

## 2. Scope (MVP)

### In Scope

-   Food search
-   Autocomplete (multi-item)
-   Meal logging
-   Daily aggregation
-   Basic goals

### Out of Scope

-   AI recommendations
-   Offline sync
-   Social features

## 3. Data Model

### food_logs Collection

-   user (relation)
-   date (indexed)
-   meal_type (breakfast/lunch/dinner/snack)
-   food_type (recipe/packaged_food)
-   food_id
-   food_name
-   quantity
-   calories
-   protein
-   carbs
-   fat

## 4. API Usage

### Search

GET /recipes?filter=(name\~"query")

### Create Log

POST /food_logs

### Fetch Logs

GET /food_logs?filter=(user && date)

## 5. Core Modules

-   Search Module
-   Autocomplete Parser
-   Logging Engine
-   Aggregation Engine

## 6. iOS Architecture

View → ViewModel → Repository → API

## 7. Performance

-   Search \<300ms
-   Logging \<1s
-   Use pagination + field filtering

## 8. Security

User can only access own logs

## 9. Success Metrics

-   \<5 sec logging

-   ≥3 logs/day/user

-   90% search success

## 10. MVP Acceptance

-   Fast search
-   Accurate logging
-   Instant daily totals
