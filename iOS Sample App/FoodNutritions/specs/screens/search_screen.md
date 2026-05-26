# Search Screen (High Density)

**Stitch Screen ID:** `e2c2b69fb24b4c6185589b2ee9f47794`
**Source:** `projects/1763144866449552571/screens/e2c2b69fb24b4c6185589b2ee9f47794`
**Device:** Mobile (390pt width)
**Role:** Multi-item food search with barcode scanning, filters, recents, and results.

---

## 1. Navigation Context

- **Tab:** Search (second tab)
- **Tab Bar Position:** Fixed bottom, 4 tabs: Diary | Search | Progress | Profile
- **Active Indicator:** `primary` color with filled icon (`search`), bold uppercase label

---

## 2. Top App Bar

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Style            | Fixed, glassmorphic                        |
| Background       | `white/80%` + `backdrop-blur-lg`           |
| Border           | Bottom `1px` `surface-container-low`       |
| Leading          | User avatar (32pt circle)                  |
| Title            | "Search" — `font-headline`, bold, `text-lg`, tight tracking |
| Trailing Action  | Calendar icon (`calendar_today`), `primary` |

---

## 3. Search Input Section

### Search Bar
| Property         | Value                                            |
|------------------|--------------------------------------------------|
| Height           | 48pt                                             |
| Background       | `surface-container-lowest`                       |
| Border           | `1px surface-container`                          |
| Corner radius    | `2xl` (24px)                                     |
| Shadow           | `sm`                                             |
| Leading icon     | `search`, `primary` color                        |
| Placeholder      | "e.g. naan + chicken curry" — `zinc-400`, medium |
| Trailing action  | Barcode scanner button                           |

### Barcode Button (inside search bar)
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Size             | 32x32pt                                    |
| Background       | `primary/10`                               |
| Corner radius    | `lg` (12px)                                |
| Icon             | `barcode_scanner`, `primary`, `text-xl`    |
| Interaction      | `active:scale-90`                          |

### Parsed Multi-Item Chips
Displayed below the search bar when user enters multi-item queries (e.g., "naan + chicken").

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Layout           | Horizontal flex wrap, `gap-2`              |
| Chip bg          | `primary/10`                               |
| Chip border      | `1px primary/20`                           |
| Chip shape       | `full` (pill)                              |
| Text             | `primary`, `text-xs`, bold                 |
| Dismiss icon     | `close`, `16px`                            |
| Add Item button  | `surface-container-low` bg, `zinc-500` text, `add` icon |

### Filter Chips (horizontal scroll)
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Layout           | Horizontal scroll, `gap-2`, hide scrollbar |
| Active chip      | `primary` bg, `white` text, `shadow-sm shadow-primary/20` |
| Inactive chip    | `surface-container-lowest` bg, `1px surface-container` border, `zinc-600` text |
| Shape            | `full` (pill)                              |
| Padding          | `px-5 py-2`                                |
| Font             | `text-xs`, bold, `whitespace-nowrap`       |

### Filter Options
| Label       | Default State |
|-------------|---------------|
| All         | Active        |
| My Foods    | Inactive      |
| Recipes     | Inactive      |
| Restaurants | Inactive      |

---

## 4. Recent Section

### Section Header
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Label            | "RECENT" — `font-headline`, bold, `text-xs`, uppercase, `tracking-widest`, `zinc-400` |
| Trailing action  | "CLEAR ALL" — `primary`, `text-xs`, bold, uppercase |

### Recent Items Grid (2-column)
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Layout           | 2-column grid, `gap-3`                    |
| Card bg          | `surface-container-lowest`                 |
| Card border      | `1px surface-container`                    |
| Card shape       | `2xl` (24px)                               |
| Card shadow      | `sm`                                       |
| Padding          | `p-4`                                      |

### Per Recent Card
| Element          | Style                                      |
|------------------|--------------------------------------------|
| Icon container   | 40x40pt, `rounded-xl`, colored bg (category-specific) |
| Icon             | Material Symbol, `text-xl`, matching color |
| Food name        | `text-sm`, bold, truncate                  |
| Calories         | `10px`, bold, `zinc-400`, uppercase        |

### Example Recent Items
| Name           | Calories | Icon bg      | Icon color   | Icon          |
|----------------|----------|--------------|--------------|---------------|
| Avocado Toast  | 320 kcal | `orange-50`  | `orange-500` | `restaurant`  |
| Oat Milk Latte | 145 kcal | `blue-50`    | `blue-500`   | `local_cafe`  |

---

## 5. Popular Results Section

### Section Header
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Label            | "POPULAR RESULTS" — `font-headline`, bold, `text-xs`, uppercase, `tracking-widest`, `zinc-400` |

### Results Card Container
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-lowest`                 |
| Border           | `1px surface-container`                    |
| Corner radius    | `2xl` (24px)                               |
| Shadow           | `soft` custom shadow                       |
| Dividers         | `divide-y divide-surface-container-low`    |

### Per Result Row
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Padding          | `p-2.5`                                    |
| Hover state      | `bg-surface-container-low/30`              |

| Element          | Style                                      |
|------------------|--------------------------------------------|
| Image            | 40x40pt, `rounded-lg`, `shadow-sm`, `1px surface-container` border |
| Food name        | `13px`, bold, truncate; search term highlighted in `primary` |
| Serving info     | `9px`, bold, `zinc-400`, uppercase         |
| Highlight macro  | Colored dot + `9px` bold uppercase label   |
| Calories         | `13px`, extrabold right-aligned            |
| Calorie unit     | `9px`, `zinc-400`, bold, uppercase         |

### Add Button (per row)
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Size             | 32x32pt circle                             |
| First result     | `primary` bg, `on-primary` icon, `shadow-md shadow-primary/20` |
| Other results    | `primary/10` bg, `primary` icon, `1px primary/20` border |
| Icon             | `add`, `text-lg`                           |
| Interaction      | `active:scale-90`                          |

### Example Results
| Name                  | Serving         | Highlight      | Kcal |
|-----------------------|-----------------|----------------|------|
| Chicken Tikka Masala  | 300g (1 Bowl)   | 38g Protein (primary dot) | 450  |
| Garlic Naan           | 90g (1 Piece)   | 45g Carbs (secondary dot) | 260  |
| Greek Yogurt, Plain   | 170g (1 Cont.)  | 18g Protein (primary dot) | 100  |

---

## 6. Bottom Navigation Bar

Same as Diary screen — see `diary_screen.md` section 7. Search tab is active.

---

## 7. Data Requirements

| Data Point              | Type          | Source                 |
|-------------------------|---------------|------------------------|
| Search query            | String        | User input             |
| Parsed search items     | [String]      | Parsed from "+" delimiter |
| Active filter           | Enum          | All / My Foods / Recipes / Restaurants |
| Recent foods            | [FoodItem]    | Local storage / history |
| Search results          | [FoodItem]    | API / local database   |
| FoodItem.name           | String        |                        |
| FoodItem.calories       | Int           |                        |
| FoodItem.servingSize    | String        |                        |
| FoodItem.highlightMacro | (name, value, color) |                  |
| FoodItem.imageURL       | URL?          |                        |

---

## 8. User Interactions / Intents

| Interaction                | Intent / Action                              |
|----------------------------|----------------------------------------------|
| Type in search bar         | Filter/search foods, parse multi-item queries |
| Tap barcode scanner        | Open camera for barcode scanning             |
| Tap chip dismiss (x)       | Remove parsed item from query                |
| Tap "+ Item" chip          | Focus search bar to add another item         |
| Tap filter chip            | Switch active filter category                |
| Tap "Clear All"            | Clear recent food history                    |
| Tap recent food card       | Navigate to Food Detail or Add Food modal    |
| Tap result row             | Navigate to Food Detail screen               |
| Tap add button on result   | Open Add Food modal for that item            |
| Tap tab bar item           | Switch tab                                   |

---

## 9. Accessibility Notes

- Search bar: `accessibilityLabel` = "Search for foods, separate multiple items with plus sign"
- Barcode button: `accessibilityLabel` = "Scan barcode"
- Filter chips: `accessibilityTraits` = `.button`, announce selected state
- Result rows: group as single accessible element, announce name + calories + serving
- Add buttons: `accessibilityLabel` = "Add [food name] to diary"
- All touch targets: minimum 44x44pt
