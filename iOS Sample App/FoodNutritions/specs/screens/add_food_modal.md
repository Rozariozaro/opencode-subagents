# Add Food Modal (Bottom Sheet)

**Stitch Screen ID:** `cc3e952d0bf547529744d944893c9dce` (modal variant)
**Source:** `projects/1763144866449552571/screens/cc3e952d0bf547529744d944893c9dce`
**Device:** Mobile (390pt width)
**Role:** Bottom sheet for adding a selected food item to the diary with quantity and meal selection.

---

## 1. Presentation Context

- **Type:** Modal bottom sheet (overlays Search screen)
- **Entry:** Tap "add" button on a search result, or tap a recent food
- **Backdrop:** Dimmed search screen (`on-surface/40` + `backdrop-blur-[2px]`)
- **Background mock:** Search screen shown underneath at 50% brightness, greyscale 20%
- **Max height:** `92dvh`
- **Sheet handle:** Centered, `40x4pt`, `rounded-full`, `white/40`

---

## 2. Sheet Container

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-lowest`                 |
| Corner radius    | Top `2.5rem` (40px)                        |
| Shadow           | `2xl`                                      |
| Layout           | Flex column, full height, overflow hidden  |

---

## 3. Sheet Header

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Style            | Sticky top, glassmorphic                   |
| Background       | `white/80` + `backdrop-blur-xl`            |
| Padding          | `px-6 py-5`                                |
| Leading          | Close icon (`close`), `green-600`          |
| Title            | "Add Food" — `font-headline`, bold, `text-lg`, tight tracking |
| Trailing         | More options (`more_vert`), `green-600`    |

---

## 4. Food Identity Hero

Centered identity section showing the selected food.

| Element          | Style                                      |
|------------------|--------------------------------------------|
| Image            | 96x96pt, `rounded-3xl`, `shadow-sm`       |
| Food name        | `font-headline`, `text-2xl`, extrabold, tight tracking |
| Serving desc     | `on-surface-variant`, medium weight        |
| Margin           | `mt-4 mb-8`, centered                     |

---

## 5. Macro Visualization (Editorial Bento)

### Energy Row (full width)
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-low`                    |
| Corner radius    | `2xl` (24px)                               |
| Padding          | `p-5`                                      |
| Layout           | Flex row, `justify-between`                |

**Left side:**
| Element          | Style                                      |
|------------------|--------------------------------------------|
| Label            | "Energy" — `label-sm`, semibold, uppercase, wide tracking, `on-surface-variant` |
| Value            | "100" — `font-headline`, `text-4xl`, extrabold, `primary` |
| Unit             | "kcal" — `font-label`, `text-sm`, bold, `on-surface-variant` |

**Right side — Mini Donut:**
| Property         | Size 64x64pt                               |
|------------------|--------------------------------------------|
| Track            | `surface-dim`, stroke `3`                  |
| Fill             | `primary`, stroke `4`, dasharray `75,100`  |

### Macro Breakdown (3-column grid)
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Gap              | `gap-3`                                    |
| Card bg          | `surface-container-low`                    |
| Card radius      | `2xl`                                      |
| Card padding     | `p-4`                                      |
| Text align       | Center                                     |

| Macro    | Label Style                           | Value Style                     |
|----------|---------------------------------------|---------------------------------|
| Protein  | `10px`, bold, uppercase, `on-surface-variant` | `font-headline`, `text-xl`, bold, `primary`   |
| Carbs    | `10px`, bold, uppercase, `on-surface-variant` | `font-headline`, `text-xl`, bold, `secondary` |
| Fats     | `10px`, bold, uppercase, `on-surface-variant` | `font-headline`, `text-xl`, bold, `tertiary`  |

---

## 6. Quantity Stepper

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Section title    | "Quantity" — `font-headline`, bold, `text-base` |
| Value display    | "170 grams" — `primary`, bold (right-aligned to title) |
| Container        | `surface-container-high`, `rounded-full`, `p-2` |
| Minus button     | 48x48pt circle, white bg, `shadow-sm`, `remove` icon |
| Value input      | Centered, `font-headline`, `text-xl`, bold, readonly |
| Plus button      | 48x48pt circle, white bg, `shadow-sm`, `add` icon |
| Interactions     | Buttons: `active:scale-90`                 |

---

## 7. Meal Selector

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Section title    | "Select Meal" — `font-headline`, bold, `text-base` |
| Layout           | Horizontal scroll, `gap-2`, hide scrollbar |

### Meal Chips
| State    | Background                    | Text                      | Font         |
|----------|-------------------------------|---------------------------|--------------|
| Selected | `primary-container`           | `on-primary-container`    | bold, `text-sm` |
| Default  | `surface-container-high`      | `on-surface-variant`      | semibold, `text-sm` |

| Chip shape  | `full` (pill)                              |
|-------------|--------------------------------------------|
| Padding     | `px-6 py-2.5`                              |
| Interaction | `active:scale-95`                          |

### Meal Options
| Label     | Default State |
|-----------|---------------|
| Breakfast | Selected      |
| Lunch     | Default       |
| Dinner    | Default       |
| Snacks    | Default       |

---

## 8. Footer Action (Sticky Bottom)

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Position         | Sticky bottom                              |
| Background       | `white/90` + `backdrop-blur-md`            |
| Border           | Top `1px surface-variant`                  |
| Padding          | `p-6`                                      |

### Primary Button
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Width            | Full                                       |
| Background       | Gradient `from-primary to-primary-container` at 135deg |
| Text             | "Add to Diary" — `font-headline`, extrabold, `text-lg`, white |
| Icon             | `add_task` (filled), white                 |
| Shape            | `full` (pill)                              |
| Padding          | `py-5`                                     |
| Shadow           | `lg`                                       |
| Interaction      | `active:scale-[0.98]`                      |

---

## 9. Data Requirements

| Data Point              | Type       | Source                 |
|-------------------------|------------|------------------------|
| Selected food item      | FoodItem   | Passed from search     |
| Food image URL          | URL?       | FoodItem               |
| Food name               | String     | FoodItem               |
| Serving description     | String     | FoodItem               |
| Calories                | Int        | Computed (base * qty)  |
| Protein (g)             | Float      | Computed (base * qty)  |
| Carbs (g)               | Float      | Computed (base * qty)  |
| Fats (g)                | Float      | Computed (base * qty)  |
| Quantity                | Int        | User input (stepper)   |
| Serving weight (g)      | Float      | FoodItem               |
| Selected meal           | Enum       | Breakfast/Lunch/Dinner/Snacks |

---

## 10. User Interactions / Intents

| Interaction                | Intent / Action                              |
|----------------------------|----------------------------------------------|
| Drag sheet handle down     | Dismiss modal                                |
| Tap close (X)              | Dismiss modal                                |
| Tap more options           | Show options (edit, create custom, etc.)      |
| Tap minus button           | Decrement quantity (min 1)                   |
| Tap plus button            | Increment quantity                           |
| Tap meal chip              | Select meal slot                             |
| Tap "Add to Diary"         | Save food entry to selected meal, dismiss, return to diary |

---

## 11. Accessibility Notes

- Sheet: announce as modal, trap focus within
- Close button: `accessibilityLabel` = "Close"
- Donut/macros: provide text alternative with calorie and macro values
- Quantity stepper: `accessibilityTraits` = `.adjustable`, announce current value
- Meal chips: announce selected state, use `accessibilityTraits` = `.button`
- Add to Diary button: `accessibilityLabel` = "Add [food name] to [selected meal]"
- Minimum touch target: 44x44pt for all interactive elements
