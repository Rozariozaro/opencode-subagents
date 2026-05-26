# Food Detail Screen (Compact)

**Stitch Screen ID:** `d7a9c3b5d7d944689d6391e05fb46c5f`
**Source:** `projects/1763144866449552571/screens/d7a9c3b5d7d944689d6391e05fb46c5f`
**Device:** Mobile (390pt width)
**Role:** Comprehensive nutritional detail view for a food item, with inline add-to-diary action.

---

## 1. Navigation Context

- **Entry:** Push navigation from Search results, Diary food item tap, or Recent food tap
- **Back:** Arrow back to previous screen
- **No tab bar** — this is a detail/pushed screen

---

## 2. Top App Bar

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Style            | Fixed, glassmorphic                        |
| Background       | `white/80` + `backdrop-blur-md`            |
| Shadow           | `sm`                                       |
| Height           | 64pt                                       |
| Leading          | Back arrow (`arrow_back`), `green-600`     |
| Title            | "Food Details" — `font-headline` (Manrope), bold, `text-lg`, tight tracking |
| Trailing         | More options (`more_vert`), `green-600`    |

---

## 3. Header & Branding Section

| Element          | Style                                      |
|------------------|--------------------------------------------|
| Food name        | `font-headline`, `text-2xl`, extrabold, tight tracking, `on-surface` |
| Brand + serving  | `text-sm`, `on-surface-variant`, medium — e.g., "Fage Total 0% • 170g serving" |
| Spacing          | `space-y-0.5`                              |

---

## 4. Hero: Macro Donut & Calorie Display

### Container
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-lowest`                 |
| Corner radius    | `3xl` (24px)                               |
| Padding          | `p-4`                                      |
| Shadow           | `sm`                                       |
| Background accent| Blurred circle `primary/5`, `w-40 h-40`, top-right, `blur-3xl` |

### Donut Chart (centered)
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Size             | 144x144pt (w-36 h-36)                     |
| Track            | `surface-dim`, radius 60, stroke-width 14  |
| Fill             | `primary-container`, radius 60, stroke-width 14, round linecap |
| Rotation         | `-90deg`                                   |
| Center — value   | `font-headline`, `text-3xl`, extrabold, `on-surface`, tight tracking |
| Center — unit    | `font-label`, `10px`, bold, `on-surface-variant`, uppercase, wide tracking |

### Daily Goal Indicator (below donut)
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Icon             | `bolt` (filled), `primary`, `text-xs`      |
| Text             | "5% of Daily Goal" — `primary`, semibold, `text-xs` |
| Layout           | Flex row, centered, `space-x-1.5`, `mt-2`  |

---

## 5. Macro Bento Section (3-column grid)

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Layout           | 3-column grid, `gap-3`                    |
| Card bg          | `surface-container-lowest`                 |
| Card radius      | `2xl`                                      |
| Card padding     | `p-3`                                      |
| Card shadow      | `sm`                                       |
| Card border      | `1px outline-variant/10`                   |
| Alignment        | Center, vertical stack                     |

### Per Macro Card
| Element          | Style                                      |
|------------------|--------------------------------------------|
| Label            | `9px`, bold, uppercase, `tracking-widest`, `on-surface-variant` |
| Value            | `font-headline`, `text-lg`, bold           |
| Progress track   | `w-full h-1`, `surface-dim`, `rounded-full` |
| Progress fill    | Macro-colored, proportional width          |

| Macro    | Value Color  | Bar Color            | Example |
|----------|-------------|----------------------|---------|
| Protein  | `primary`   | `primary-container`  | 18g, 75% fill |
| Carbs    | `secondary` | `secondary-container`| 6g, 25% fill  |
| Fat      | `tertiary`  | `tertiary-container` | 0g, 0% fill   |

---

## 6. Image Spotlight

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Width            | Full                                       |
| Height           | 128pt (h-32)                               |
| Corner radius    | `3xl` (24px)                               |
| Overflow         | Hidden                                     |
| Image fit        | `object-cover`                             |
| Hover effect     | `scale-105` over 700ms                     |
| Overlay          | Gradient `from-black/40 to-transparent` (bottom to top) |
| Caption          | Bottom-left, white, `text-xs`, medium, italic, `opacity-90` — e.g., "Naturally High in Probiotics" |

---

## 7. Micronutrients Section

### Section Header
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Title            | "Micronutrients" — `font-headline`, `text-lg`, bold |
| Trailing action  | "View All" — `primary`, `text-sm`, semibold |

### Container
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-low`                    |
| Corner radius    | `3xl` (24px)                               |
| Padding          | `p-1.5`                                    |
| Item spacing     | `space-y-1`                                |

### Per Nutrient Row
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-lowest`                 |
| Corner radius    | `2xl`                                      |
| Padding          | `px-4 py-2.5`                              |
| Layout           | Flex row, `justify-between`                |

| Element          | Style                                      |
|------------------|--------------------------------------------|
| Icon container   | 28x28pt circle, colored bg (category)      |
| Icon             | Material Symbol, matching color, `text-xs` |
| Nutrient name    | `text-sm`, medium, `on-surface`            |
| Value            | `text-sm`, semibold (right-aligned)        |

### Example Nutrients
| Nutrient   | Icon bg       | Icon color    | Icon          | Value    |
|------------|---------------|---------------|---------------|----------|
| Sodium     | `orange-100`  | `orange-600`  | `science`     | 65 mg    |
| Potassium  | `blue-100`    | `blue-600`    | `water_drop`  | 240 mg   |
| Calcium    | `yellow-100`  | `yellow-600`  | `wb_sunny`    | 20% DV   |

---

## 8. Nutrition Insight Card

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `primary/5`                                |
| Corner radius    | `3xl` (24px)                               |
| Padding          | `p-5`                                      |
| Layout           | Flex row, `space-x-4`, `items-start`       |
| Icon             | `info` (filled), `primary-container` color |
| Title            | "Nutrition Insight" — bold, `text-sm`, `on-primary-container` |
| Body             | `text-xs`, `on-surface-variant`, `leading-relaxed` |

---

## 9. Bottom Action Area (Fixed)

### Container
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Position         | Fixed bottom, full width, z-50             |
| Background       | `white/80` + `backdrop-blur-xl`            |
| Padding          | `p-4`                                      |

### Serving Adjuster
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-high`                   |
| Corner radius    | `2xl`                                      |
| Padding          | `p-2 px-4`                                |
| Left — label     | "Serving Size" — `10px`, bold, uppercase, `on-surface-variant` |
| Left — value     | "170 grams (1 container)" — semibold, `text-sm` |
| Right — stepper  | Minus (32pt circle, white, shadow-sm) + count (`text-lg`, bold) + Plus |
| Button interaction| `active:scale-90`                         |

### Primary Action Button
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Width            | Full                                       |
| Background       | Gradient `from-primary to-primary-container` |
| Text             | "Add to Diary" — `on-primary`, semibold, `text-lg` |
| Icon             | `add_circle` (filled)                      |
| Shape            | `full` (pill)                              |
| Padding          | `py-4`                                     |
| Shadow           | `lg`                                       |
| Interaction      | `active:scale-[0.98]`                      |

---

## 10. Data Requirements

| Data Point              | Type       | Source                 |
|-------------------------|------------|------------------------|
| Food item               | FoodItem   | Passed from navigation |
| Food name               | String     | FoodItem               |
| Brand                   | String?    | FoodItem               |
| Serving description     | String     | FoodItem               |
| Serving weight (g)      | Float      | FoodItem               |
| Calories                | Int        | FoodItem (per serving) |
| Daily calorie goal      | Int        | User profile           |
| Daily % of goal         | Computed   | calories / goal * 100  |
| Protein (g)             | Float      | FoodItem               |
| Carbs (g)               | Float      | FoodItem               |
| Fat (g)                 | Float      | FoodItem               |
| Protein target (g)      | Float      | User profile           |
| Carbs target (g)        | Float      | User profile           |
| Fat target (g)          | Float      | User profile           |
| Image URL               | URL?       | FoodItem               |
| Image caption           | String?    | FoodItem or generated  |
| Micronutrients          | [Nutrient] | FoodItem               |
| Nutrient.name           | String     |                        |
| Nutrient.value          | String     | "65 mg" or "20% DV"   |
| Nutrient.icon           | String     | Material Symbol name   |
| Nutrient.color          | Color      | Category color         |
| Nutrition insight       | String?    | Generated/static       |
| Quantity                | Int        | User input (stepper)   |

---

## 11. User Interactions / Intents

| Interaction                | Intent / Action                              |
|----------------------------|----------------------------------------------|
| Tap back arrow             | Pop navigation, return to previous screen    |
| Tap more options           | Show action sheet (share, report, etc.)      |
| Tap "View All" nutrients   | Expand full micronutrient list               |
| Tap minus (serving)        | Decrement serving count (min 1)              |
| Tap plus (serving)         | Increment serving count                      |
| Tap "Add to Diary"         | Open meal selector or add to default meal    |
| Hover/focus on image       | Subtle scale-up animation                    |

---

## 12. Accessibility Notes

- Donut chart: `accessibilityLabel` = "100 calories, 5% of daily goal"
- Macro cards: each announces label + value + progress (e.g., "Protein, 18 grams, 75% of target")
- Image spotlight: `accessibilityLabel` with descriptive alt text
- Micronutrient rows: group icon + name + value as single accessible element
- Insight card: announce as informational note
- Serving stepper: `accessibilityTraits` = `.adjustable`
- Add to Diary: `accessibilityLabel` = "Add [food name] to diary"
- All touch targets: minimum 44x44pt
