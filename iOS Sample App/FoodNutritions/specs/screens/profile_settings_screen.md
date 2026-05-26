# Profile & Settings Screen (Refined)

**Stitch Screen ID:** `704cfdf2b95e4a05a60339dd2c9e41cb`
**Source:** `projects/1763144866449552571/screens/704cfdf2b95e4a05a60339dd2c9e41cb`
**Device:** Mobile (390pt width)
**Role:** User profile display and app settings hub.

---

## 1. Navigation Context

- **Tab:** Profile (fourth tab, rightmost)
- **Tab Bar Position:** Fixed bottom, 4 tabs: Diary | Search | Progress | Profile
- **Active Indicator:** `green-600` color with filled icon (`person`), `scale-110`, bold uppercase label

---

## 2. Top App Bar

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Style            | Fixed, glassmorphic                        |
| Background       | `white/80` + `backdrop-blur-lg`            |
| Shadow           | `0 8px 32px rgba(0,0,0,0.04)`             |
| Leading          | User avatar (40pt circle, `surface-container` fallback bg) |
| Title            | "Today" — `font-headline`, bold, `text-lg`, tight tracking |
| Trailing Action  | Calendar icon (`calendar_today`), `green-600` |

---

## 3. Profile Hero Section

Centered layout showcasing user identity.

### Profile Image
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Size             | 128x128pt                                  |
| Shape            | `rounded-xl` (not circle)                  |
| Shadow           | `0 8px 32px rgba(0,0,0,0.06)`             |
| Overflow         | Hidden                                     |
| Edit badge       | Overlapping bottom-right                   |

### Edit Badge
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Size             | 36x36pt circle                             |
| Position         | `absolute -bottom-1 -right-1`             |
| Background       | `primary`                                  |
| Icon             | `edit`, `18px`, white                      |
| Shadow           | `lg`                                       |
| Border           | `4px` white                                |
| Interaction      | `active:scale-90`                          |

### User Info
| Element          | Style                                      |
|------------------|--------------------------------------------|
| Name             | "Alex Rivera" — `font-headline`, `text-2xl`, extrabold, tight tracking, `on-surface` |
| Membership       | "Member since May 2023" — `zinc-400`, medium, `text-xs`, uppercase, `tracking-widest` |
| Spacing          | `mt-1` between name and membership         |

---

## 4. Quick Stats Grid (2-column)

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Layout           | 2-column grid, `gap-3`                    |

### Per Stat Card
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-lowest`                 |
| Corner radius    | `xl` (24px)                                |
| Shadow           | `0 8px 32px rgba(0,0,0,0.03)`             |
| Padding          | `p-6`                                      |
| Alignment        | Center, vertical stack                     |

| Card        | Icon                     | Icon Color  | Icon Fill | Value     | Label   |
|-------------|--------------------------|-------------|-----------|-----------|---------|
| Streak      | `local_fire_department`  | `primary`   | Filled    | "14 Days" | "STREAK"|
| Weight Lost | `weight`                 | `tertiary`  | Filled    | "8.4 lbs" | "LOST"  |

### Per Card Elements
| Element    | Style                                             |
|------------|---------------------------------------------------|
| Icon       | Material Symbol, `text-2xl`, `mb-3`               |
| Value      | `text-2xl`, `font-headline`, extrabold, `on-surface` |
| Label      | `10px`, bold, `zinc-400`, uppercase, `tracking-widest`, `mt-1` |

---

## 5. Settings List

### Section Header
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Text             | "SETTINGS"                                 |
| Style            | `10px`, bold, `zinc-400`, uppercase, `tracking-[0.2em]` |
| Padding          | `px-2`                                     |

### List Container
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Spacing          | `space-y-2` between rows                  |

### Per Settings Row
| Property         | Value                                      |
|------------------|--------------------------------------------|
| Background       | `surface-container-lowest`                 |
| Corner radius    | `xl` (24px)                                |
| Shadow           | `0 4px 20px rgba(0,0,0,0.02)`             |
| Padding          | `p-4`                                      |
| Layout           | Flex row, `justify-between`, `items-center` |
| Interaction      | `active:scale-[0.98]`, cursor pointer      |

### Row Content
| Element          | Style                                      |
|------------------|--------------------------------------------|
| Icon container   | 40x40pt circle, tinted bg (`color/10`)     |
| Icon             | Material Symbol, matching color            |
| Label            | `font-semibold`, `on-surface`              |
| Trailing         | Chevron (`chevron_right`), `outline-variant` |
| Secondary value  | (optional) `text-sm`, medium, `zinc-400` — before chevron |

### Settings Items
| Item           | Icon             | Icon BG          | Icon Color    | Secondary Value |
|----------------|------------------|------------------|---------------|-----------------|
| Account        | `person`         | `primary/10`     | `primary`     | —               |
| Notifications  | `notifications`  | `secondary/10`   | `secondary`   | —               |
| Units          | `straighten`     | `tertiary/10`    | `tertiary`    | "Metric"        |
| Help           | `help_center`    | `zinc-100`       | `zinc-600`    | —               |

---

## 6. Sign Out Button

| Property         | Value                                      |
|------------------|--------------------------------------------|
| Width            | Full                                       |
| Padding          | `py-4 px-6`                                |
| Background       | `error-container/20`                       |
| Corner radius    | `xl` (24px)                                |
| Shadow           | `0 4px 20px rgba(0,0,0,0.02)`             |
| Text             | "Sign Out" — `font-headline`, bold, `error` |
| Icon             | `logout`, `20px`, `error`                  |
| Layout           | Flex row, centered, `gap-2`                |
| Interaction      | `active:scale-95`                          |

---

## 7. Bottom Navigation Bar

Same as Diary screen — see `diary_screen.md` section 7. Profile tab is active with:
- Color: `green-600`
- Icon: `person` (filled)
- Scale: `1.1`

---

## 8. Data Requirements

| Data Point              | Type       | Source            |
|-------------------------|------------|-------------------|
| User name               | String     | User profile      |
| User avatar URL         | URL?       | User profile      |
| Membership date         | Date       | User profile      |
| Streak days             | Int        | Computed from diary entries |
| Weight lost             | Float      | User profile / progress data |
| Weight unit             | Enum       | User settings (lbs/kg) |
| Notification settings   | Bool/Config| User settings     |
| Unit preference         | Enum       | Metric/Imperial   |

---

## 9. User Interactions / Intents

| Interaction                | Intent / Action                              |
|----------------------------|----------------------------------------------|
| Tap edit badge on avatar   | Open image picker / camera for new photo     |
| Tap calendar icon          | Open date picker                             |
| Tap Account row            | Navigate to Account settings                 |
| Tap Notifications row      | Navigate to Notification preferences         |
| Tap Units row              | Navigate to Unit selection (Metric/Imperial) |
| Tap Help row               | Navigate to Help/FAQ/Support                 |
| Tap Sign Out               | Show confirmation dialog, then sign out      |
| Tap tab bar item           | Switch tab                                   |

---

## 10. Accessibility Notes

- Profile image + edit badge: group as single element, `accessibilityLabel` = "Profile photo, double tap to change"
- Stat cards: announce icon meaning + value + label (e.g., "Streak, 14 days")
- Settings rows: each is a button, announce label + secondary value if present
- Sign Out: `accessibilityTraits` = `.button`, announce "Sign Out"
- All touch targets: minimum 44x44pt
- Settings list: announce section header "Settings" before first row
