# Vitality Core Dynamic — Dark Mode Design System

**Stitch Asset ID:** `63c8589607e04780a8b7a79e6122d8ff`
**Display Name:** Vitality Core Dynamic
**Color Mode:** DARK
**Color Variant:** VIBRANT
**Seed Color:** `#22C55E`
**Primary Override:** `#22C55E`
**Neutral Override:** `#0F172A`
**Spacing Scale:** 2

---

## Typography

| Role      | Font Family | Notes                     |
|-----------|-------------|---------------------------|
| Headline  | Manrope     | Display & headline text   |
| Body      | Inter       | Body copy & UI text       |
| Label     | Inter       | Labels, captions, metadata|

## Shape

| Property   | Value       |
|------------|-------------|
| Roundness  | ROUND_EIGHT |

---

## Named Colors

| Token                        | Hex       |
|------------------------------|-----------|
| `background`                 | `#060e20` |
| `surface`                    | `#060e20` |
| `surface_bright`             | `#1f2b49` |
| `surface_dim`                | `#060e20` |
| `surface_variant`            | `#192540` |
| `surface_tint`               | `#6bff8f` |
| `surface_container`          | `#0f1930` |
| `surface_container_high`     | `#141f38` |
| `surface_container_highest`  | `#192540` |
| `surface_container_low`      | `#091328` |
| `surface_container_lowest`   | `#000000` |
| `on_background`              | `#dee5ff` |
| `on_surface`                 | `#dee5ff` |
| `on_surface_variant`         | `#a3aac4` |
| `inverse_surface`            | `#faf8ff` |
| `inverse_on_surface`         | `#4d556b` |
| `inverse_primary`            | `#006e2f` |
| `primary`                    | `#6bff8f` |
| `on_primary`                 | `#005f28` |
| `primary_container`          | `#0abc56` |
| `on_primary_container`       | `#002c0f` |
| `primary_dim`                | `#5bf083` |
| `primary_fixed`              | `#6bff8f` |
| `primary_fixed_dim`          | `#5bf083` |
| `on_primary_fixed`           | `#004a1d` |
| `on_primary_fixed_variant`   | `#006a2d` |
| `secondary`                  | `#7afbb7` |
| `on_secondary`               | `#005e3a` |
| `secondary_container`        | `#006d44` |
| `on_secondary_container`     | `#e1ffe9` |
| `secondary_fixed`            | `#7afbb7` |
| `secondary_fixed_dim`        | `#6beca9` |
| `on_secondary_fixed`         | `#00492c` |
| `on_secondary_fixed_variant` | `#006942` |
| `tertiary`                   | `#7de9ff` |
| `on_tertiary`                | `#005561` |
| `tertiary_container`         | `#00e0fd` |
| `on_tertiary_container`      | `#004b56` |
| `tertiary_dim`               | `#00d1ec` |
| `tertiary_fixed`             | `#00e0fd` |
| `tertiary_fixed_dim`         | `#00d1ec` |
| `on_tertiary_fixed`          | `#00363e` |
| `on_tertiary_fixed_variant`  | `#005561` |
| `error`                      | `#ff7351` |
| `on_error`                   | `#450900` |
| `error_container`            | `#b92902` |
| `error_dim`                  | `#d53d18` |
| `on_error_container`         | `#ffd2c8` |
| `outline`                    | `#6d758c` |
| `outline_variant`            | `#40485d` |

---

## Design Specification (designMd)

# Design System Specification: Editorial Vitality

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Kinetic Atelier."**

This is not a static interface; it is a living, breathing editorial space that balances the high-energy pulse of performance with the sophisticated restraint of a premium boutique. We move beyond the "boxed-in" web by utilizing intentional asymmetry, overlapping depth, and a dramatic typographic scale. The goal is to make the user feel they are interacting with a high-end digital magazine that responds to their touch, rather than a database of inputs.

Through the use of **Tonal Layering** and **Glassmorphism**, we eliminate the rigid lines of traditional UI, creating a fluid environment where content is separated by light and shadow rather than borders.

---

## 2. Colors & Surface Architecture
Our palette centers on a high-octane Primary Green (`#6BFF8F`), contrasted against a deep, multi-tonal midnight foundation.

### The "No-Line" Rule
**Strict Mandate:** Designers are prohibited from using 1px solid borders for sectioning or containment. Structural boundaries must be defined exclusively through background color shifts.
*   Use `surface-container-low` for secondary sections sitting on a `surface` background.
*   Use `surface-container-high` for interactive elements to create natural prominence.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Each inner container should shift one tier in the surface scale to define importance:
*   **Base:** `surface` (#060E20)
*   **Structural Sections:** `surface-container-low` (#091328)
*   **Interactive Cards:** `surface-container` (#0F1930)
*   **Floating/Active Elements:** `surface-container-highest` (#192540)

### The "Glass & Gradient" Rule
To achieve a signature premium feel, floating elements (modals, navigation bars, hover states) should utilize **Glassmorphism**.
*   **Formula:** `surface-variant` at 60% opacity + 20px Backdrop Blur.
*   **Gradients:** Use a subtle linear gradient (Top-Left to Bottom-Right) transitioning from `primary` (#6BFF8F) to `primary-container` (#0ABC56) for Hero CTAs and progress indicators to provide a sense of "liquid energy."

---

## 3. Typography: The Editorial Voice
We pair the geometric authority of **Manrope** with the hyper-legible utility of **Inter**.

*   **Display & Headlines (Manrope):** Use `display-lg` (3.5rem) and `headline-lg` (2rem) to create clear entry points. Headlines should feel "oversized" to establish an editorial hierarchy.
*   **Body & UI (Inter):** Use `body-lg` (1rem) for long-form content and `label-md` (0.75rem) for functional metadata.
*   **Visual Polish:** Set `on-surface` (Pure White) for titles to ensure maximum contrast, and `on-surface-variant` (#A3AAC4) for secondary body text to reduce visual noise and eye strain.

---

## 4. Elevation & Depth
Depth is a functional tool, not a decoration. We use **Tonal Layering** to achieve a soft, natural lift.

*   **The Layering Principle:** Place a `surface-container-lowest` card on a `surface-container-low` section. This creates a "recessed" or "lifted" feel without a single pixel of stroke.
*   **Ambient Shadows:** For high-level floating elements (e.g., popovers), use a custom shadow:
    *   `box-shadow: 0 24px 48px -12px rgba(0, 0, 0, 0.5);`
    *   The shadow must feel like ambient light being occluded, not a dark smudge.
*   **The "Ghost Border" Fallback:** If a container sits on a background of the same tone, use a `outline-variant` (#40485D) at **15% opacity**. This provides a whisper of a boundary that remains nearly invisible.

---

## 5. Components

### Buttons
*   **Primary:** `primary` (#6BFF8F) background with `on-primary` text. Use a 24px (`xl`) corner radius. On hover, apply a glow effect using a 15px spread of the primary color at 20% opacity.
*   **Secondary:** `outline-variant` ghost border (15% opacity) with `on-surface` text.
*   **Tertiary:** Text-only, using `primary` color for the label, suggesting a "link" but with the weight of a button.

### Cards & Lists
*   **Card Styling:** 24px (`xl`) corner radius. Use `surface-container` for the background.
*   **The Divider Ban:** Never use horizontal rules (`<hr>`). Separate list items using `spacing-4` (1rem) of vertical white space or a 2% shift in background luminance between items.

### Input Fields
*   **State:** Background should be `surface-container-highest`.
*   **Focus:** Transition the "Ghost Border" from 15% opacity to 100% `primary` color.
*   **Corner Radius:** 8px (`md`) to maintain a "functional" look compared to the "expressive" 24px cards.

### Selection Controls
*   **Checkboxes/Radios:** When active, use a `primary` to `secondary` gradient fill. The high-contrast green against the `#060E20` background ensures the "Vitality" brand is always the focus of action.

---

## 6. Do's and Don'ts

### Do
*   **Do** use asymmetrical margins (e.g., `spacing-24` on the left, `spacing-12` on the right) for hero headers to create an editorial feel.
*   **Do** lean into `surface-bright` (#1F2B49) for subtle hover states on dark backgrounds.
*   **Do** prioritize `Manrope` for any text larger than 24px to inject brand personality.

### Don't
*   **Don't** use 100% opaque borders. It breaks the "Kinetic Atelier" immersion.
*   **Don't** use pure black (#000000) for backgrounds; keep it to the deep navy/charcoal of `surface` (#060E20) to maintain tonal depth.
*   **Don't** crowd elements. If in doubt, double the vertical spacing using the `spacing-16` (4rem) or `spacing-20` (5rem) tokens.
