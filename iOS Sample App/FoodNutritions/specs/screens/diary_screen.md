# Diary Screen (Unified Buttons)

**Stitch Screen ID:** `cc3e952d0bf547529744d944893c9dce`
**Source:** `projects/1763144866449552571/screens/cc3e952d0bf547529744d944893c9dce`
**Device:** Mobile (390pt width)
**Role:** Primary daily food logging hub — the app's home screen.

---

## 1. Navigation Context

- **Tab:** Diary (first tab, active by default)
- **Tab Bar Position:** Fixed bottom, 4 tabs: Diary | Search | Progress | Profile
- **Active Indicator:** `primary` color with filled icon (`event_note`), bold uppercase label

---

## 2. Top App Bar

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Style            | Fixed, glassmorphic                        |
| Background       | `white/80%` + `backdrop-blur-lg`           |
| Border           | Bottom `1px` `surface-container-low`       |
| Leading          | User avatar (32pt circle, `surface-container` fallback bg) |
| Title            | "Today" — `font-headline`, bold, `text-lg`, tight tracking |
| Trailing Action  | Calendar icon (`calendar_today`), `primary` color |

---

## 3. Daily Summary Card (Hero)

The primary visual element. A single elevated card showing remaining calories and daily progress.

### Layout
- Background: `surface-container-lowest`
- Corner radius: `8px`
- Shadow: `sm`
- Border: `1px surface-container`
- Padding: `20px`

### Content — Left Column
| Element         | Style                                                        |
|-----------------|--------------------------------------------------------------|
| Label           | "Remaining" — `10px`, `zinc-400`, bold, uppercase, wide tracking |
| Value           | "1,482" — `font-headline`, `text-5xl`, extrabold, `primary`, tight tracking, no leading |

### Content — Right Column (Donut Chart)
| Property        | Value                                        |
|-----------------|----------------------------------------------|
| Size            | 80x80pt                                      |
| Track           | `surface-container-high`, stroke-width `8`   |
| Fill            | `primary`, stroke-width `8`, round linecap   |
| Center Label    | "75%" — `10px`, bold, `zinc-400`             |
| Rotation        | `-90deg` (starts from top)                   |

### Footer Row (3-column grid below separator)
| Column    | Label      | Value Style                          |
|-----------|------------|--------------------------------------|
| Goal      | "Goal"     | `2,200` — `text-base`, bold          |
| Food      | "Food"     | `840` — `text-base`, bold, `secondary` |
| Exercise  | "Exercise" | `122` — `text-base`, bold, `tertiary`  |

Separator: `border-t border-surface-container-low`, `mt-6 pt-5`

---

## 4. Macro Quick View (2-column grid)

Two compact progress bar cards side-by-side.

### Card Structure
- Background: `surface-container-lowest`
- Corner radius: `8px`
- Shadow: `sm`
- Border: `1px surface-container`
- Padding: `12px`

### Per Card
| Property       | Protein Card             | Carbs Card               |
|----------------|--------------------------|--------------------------|
| Label          | "PROTEIN" `10px` bold    | "CARBS" `10px` bold      |
| Value          | "42/150g" `10px` bold    | "98/250g" `10px` bold    |
| Bar track      | `surface-dim` h-1.5 full | `surface-dim` h-1.5 full |
| Bar fill color | `primary` 30% width     | `secondary` 40% width   |

---

## 5. Meal Cards

Repeating card pattern for each meal: Breakfast, Lunch, Dinner, Snacks.

### Card Container
- Background: `surface-container-lowest`
- Corner radius: `8px`
- Shadow: `sm`
- Border: `1px surface-container`
- Overflow: hidden

### Card Header
| Property     | Value                                                              |
|--------------|--------------------------------------------------------------------|
| Padding      | `px-5 pt-4 pb-3`                                                  |
| Icon         | Material Symbol, `primary` (filled) or `zinc-400` for empty meals |
| Title        | `font-headline`, bold, `text-base`                                |
| Calorie Sum  | After bullet separator, `zinc-500` or `zinc-400` for 0            |
| Separator    | `border-b border-surface-container/50`                             |

### Meal Icons per Slot
| Meal      | Icon           | Icon Style      |
|-----------|----------------|-----------------|
| Breakfast | `wb_sunny`     | primary, filled |
| Lunch     | `light_mode`   | primary, filled |
| Dinner    | `nights_stay`  | zinc-400        |
| Snacks    | `cookie`       | zinc-400        |

### Food Items (inside logged meals)
| Property     | Value                                          |
|--------------|------------------------------------------------|
| Layout       | Horizontal — name/details left, kcal right     |
| Name         | `text-sm`, semibold                            |
| Details      | `11px`, `zinc-400` — "250g • P: 22g C: 15g F: 2g" |
| Calories     | `text-sm`, bold (right-aligned)                |
| Spacing      | `space-y-4` between items                     |

### Add Food Button (per card)
| Property     | Value                                                     |
|--------------|-----------------------------------------------------------|
| Width        | Full                                                      |
| Padding      | `py-2.5`                                                  |
| Background   | `primary/10`                                              |
| Text         | `primary`, `text-sm`, bold                                |
| Border       | `1px primary/20`                                          |
| Corner radius| `8px`                                                     |
| Icon         | `add` (Material Symbol), `text-lg`                        |
| Label        | "Add Food" / "Add Dinner" / "Add Snack"                   |
| Container bg | `surface-container-lowest` with top border separator       |

---

## 6. Floating Action Button (FAB)

| Property      | Value                                     |
|---------------|-------------------------------------------|
| Position      | Fixed, `bottom-24 right-6`, z-60          |
| Size          | 56x56pt                                   |
| Shape         | Circle (full)                             |
| Background    | `primary`                                 |
| Icon          | `add`, `text-3xl`, white                  |
| Shadow        | `lg`                                      |
| Ring          | `4px` white ring                          |
| Interaction   | `active:scale-90`                         |

---

## 7. Bottom Navigation Bar

| Property      | Value                                     |
|---------------|-------------------------------------------|
| Position      | Fixed bottom, full width, z-50            |
| Background    | `white` (light) / `zinc-900` (dark)       |
| Border        | Top `1px surface-container`               |
| Padding       | `px-8 pt-3 pb-6`                          |
| Layout        | Horizontal, `justify-around`              |

### Tab Items
| Tab       | Icon         | Active State                                |
|-----------|--------------|---------------------------------------------|
| Diary     | `event_note` | `primary`, filled, bold label               |
| Search    | `search`     | `zinc-400`, outlined, medium label          |
| Progress  | `insights`   | `zinc-400`, outlined, medium label          |
| Profile   | `person`     | `zinc-400`, outlined, medium label          |

Label style: `10px`, uppercase, `tracking-widest`, `mt-1`

---

## 8. Data Requirements

| Data Point              | Type       | Source            |
|-------------------------|------------|-------------------|
| Daily calorie goal      | Int        | User profile      |
| Food calories consumed  | Int        | Sum of logged meals |
| Exercise calories       | Int        | Activity tracker  |
| Remaining calories      | Computed   | goal - food + exercise |
| Macro targets (P/C/F)   | Int (g)    | User profile      |
| Macro consumed (P/C/F)  | Int (g)    | Sum of logged meals |
| Meals array             | [Meal]     | Diary entries for selected date |
| Meal.foods              | [FoodEntry]| Each meal's logged items |
| Selected date           | Date       | Calendar picker state |

---

## 9. User Interactions / Intents

| Interaction                | Intent / Action                          |
|----------------------------|------------------------------------------|
| Tap calendar icon          | Open date picker / navigate to date      |
| Tap "Add Food" in meal card| Navigate to Search screen (meal context) |
| Tap FAB                    | Navigate to Search / Add Food flow       |
| Tap food item row          | Navigate to Food Detail screen           |
| Tap tab bar item           | Switch tab                               |
| Swipe left on food item    | Delete food entry (stretch goal)         |

---

## 10. Accessibility Notes

- Donut chart: provide `accessibilityLabel` with "75% of daily calories consumed, 1482 remaining"
- Progress bars: `accessibilityValue` with current/goal (e.g., "42 of 150 grams protein")
- Meal card headers: group icon + title + calorie count as single accessible element
- FAB: `accessibilityLabel` = "Add food"
- All touch targets: minimum 44x44pt
