# Vitality Core — Light Mode Design System

**Stitch Asset ID:** `aceec197db6a40a39c38ecd6bf4c3b67`
**Display Name:** Vitality Core
**Color Mode:** LIGHT
**Color Variant:** FIDELITY
**Seed Color:** `#22C55E`
**Primary Override:** `#22C55E`
**Neutral Override:** `#F9FAFB`

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
| `background`                 | `#f8f9fa` |
| `surface`                    | `#f8f9fa` |
| `surface_bright`             | `#f8f9fa` |
| `surface_dim`                | `#d9dadb` |
| `surface_variant`            | `#e1e3e4` |
| `surface_tint`               | `#006e2f` |
| `surface_container`          | `#edeeef` |
| `surface_container_high`     | `#e7e8e9` |
| `surface_container_highest`  | `#e1e3e4` |
| `surface_container_low`      | `#f3f4f5` |
| `surface_container_lowest`   | `#ffffff` |
| `on_background`              | `#191c1d` |
| `on_surface`                 | `#191c1d` |
| `on_surface_variant`         | `#3d4a3d` |
| `inverse_surface`            | `#2e3132` |
| `inverse_on_surface`         | `#f0f1f2` |
| `inverse_primary`            | `#4ae176` |
| `primary`                    | `#006e2f` |
| `on_primary`                 | `#ffffff` |
| `primary_container`          | `#22c55e` |
| `on_primary_container`       | `#004b1e` |
| `primary_fixed`              | `#6bff8f` |
| `primary_fixed_dim`          | `#4ae176` |
| `on_primary_fixed`           | `#002109` |
| `on_primary_fixed_variant`   | `#005321` |
| `secondary`                  | `#2f6a3c` |
| `on_secondary`               | `#ffffff` |
| `secondary_container`        | `#afefb4` |
| `on_secondary_container`     | `#346e40` |
| `secondary_fixed`            | `#b2f2b7` |
| `secondary_fixed_dim`        | `#96d59d` |
| `on_secondary_fixed`         | `#002109` |
| `on_secondary_fixed_variant` | `#145126` |
| `tertiary`                   | `#9e4036` |
| `on_tertiary`                | `#ffffff` |
| `tertiary_container`         | `#ff8b7c` |
| `on_tertiary_container`      | `#76231b` |
| `tertiary_fixed`             | `#ffdad5` |
| `tertiary_fixed_dim`         | `#ffb4a9` |
| `on_tertiary_fixed`          | `#410001` |
| `on_tertiary_fixed_variant`  | `#7f2a21` |
| `error`                      | `#ba1a1a` |
| `on_error`                   | `#ffffff` |
| `error_container`            | `#ffdad6` |
| `on_error_container`         | `#93000a` |
| `outline`                    | `#6d7b6c` |
| `outline_variant`            | `#bccbb9` |

---

## Design Specification (designMd)

# Design System Specification: The Vitality Layer

## 1. Overview & Creative North Star: "The Living Breath"
This design system rejects the clinical, static nature of traditional tracking apps in favor of **"The Living Breath."** Our North Star is a high-density, editorial interface that feels as organic as the nutrition it tracks. We achieve this by moving away from rigid "app-like" grids and embracing a layout that breathes through intentional white space and tonal depth.

By prioritizing **SwiftUI-inspired fluidity**, we use layered surfaces and "soft-touch" geometry to make high-density data feel approachable. We don't just display numbers; we curate a wellness journey. The aesthetic is "High-End Editorial meets Native iOS" — authoritative, clean, and frictionless.

---

## 2. Colors: Tonal Architecture
We move beyond flat hex codes to a system of **Tonal Architecture**. The palette is rooted in a neutral light mode, using our signature `#22C55E` Green as a pulse of vitality.

### The "No-Line" Rule
**Explicit Instruction:** Traditional 1px solid borders are strictly prohibited for sectioning. Definition is achieved through:
- **Background Color Shifts:** A `surface-container-low` card sitting on a `surface` background.
- **Tonal Transitions:** Using the `surface-container` tiers to denote change in context.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of fine paper.
*   **Base:** `surface` (#f8f9fa) -- The foundation.
*   **Secondary Content:** `surface-container-low` (#f3f4f5) -- Use for grouped background areas.
*   **Primary Interaction:** `surface-container-lowest` (#ffffff) -- Use for the highest-level cards (e.g., today's calorie summary) to create a "lifted" feel.

### The Glass & Gradient Rule
*   **Glassmorphism:** For floating navigation or action bars, use `surface-container-lowest` at 80% opacity with a `20px` backdrop blur. This allows the vibrant greens of the content to bleed through, maintaining a sense of place.
*   **Signature Textures:** Main CTAs (like "Log Meal") must use a subtle linear gradient: `primary` (#006e2f) to `primary-container` (#22c55e) at a 135 degree angle. This adds "soul" and prevents the UI from feeling "flat-pack."

---

## 3. Typography: Editorial Authority
We utilize a pairing of **Manrope** for high-impact displays and **Inter** (as a high-performance alternative to SF Pro) for utility.

*   **Display & Headlines (Manrope):** Use `display-lg` for daily totals. The wide apertures of Manrope convey modern sophistication.
*   **Title & Body (Inter):** Use `title-md` for meal names and `body-md` for nutritional breakdowns.
*   **The Hierarchy Goal:** Use extreme scale contrast. A `display-lg` calorie count should sit adjacent to a `label-sm` unit descriptor. This creates a "Data-as-Art" feel, making high information density feel like a premium magazine layout rather than a spreadsheet.

---

## 4. Elevation & Depth: Tonal Layering
We eschew "Drop Shadows" for **Ambient Occlusion**.

*   **The Layering Principle:** Stack `surface-container-lowest` cards on top of `surface-container-low` backgrounds. The delta in hex value is enough to signify depth.
*   **Ambient Shadows:** Where floating elements are required (e.g., a "Quick Log" FAB), use a shadow color derived from `on-surface` (#191c1d) at 4% opacity with a `32px` blur and `8px` Y-offset. It should feel like a soft glow, not a hard edge.
*   **The "Ghost Border":** If a boundary is required for accessibility in low-contrast charts, use `outline-variant` (#bccbb9) at **15% opacity**.
*   **Roundedness:** Stick to the `xl` (1.5rem) for main dashboard cards and `md` (0.75rem) for inner nested items (like individual food entries). This "nested rounding" mimics iOS native containers.

---

## 5. Components: The Fluid Kit

### Buttons (The Pulse)
*   **Primary:** Gradient-fill (`primary` to `primary-container`), `full` roundedness, `title-sm` (Inter Semi-Bold).
*   **Secondary:** `surface-container-high` background with `on-surface` text. No border.
*   **Tertiary:** Transparent background, `primary` text, with a subtle `2.5` spacing underline.

### Cards & Lists (The Density Core)
*   **Forbid Dividers:** Do not use lines between list items. Use a `3` (0.6rem) vertical spacing gap.
*   **Nutrition Cards:** Use `surface-container-lowest`. Inside, use `primary-container` for progress bar tracks with `surface-dim` for the "empty" state.
*   **Nesting:** A list of "Recent Meals" should be a `surface-container-low` group with individual items inside styled as `surface-container-lowest` blocks.

### Input Fields
*   **Soft Focus:** Fields use `surface-container-high`. On focus, transition the background to `surface-container-lowest` and add a `2px` "Ghost Border" of `primary` at 30% opacity.

### Featured Component: The Macro-Donut
A custom visualization using a thick `16px` stroke. Use `primary` (Protein), `secondary` (Carbs), and `tertiary` (Fats). The center of the donut should display the remaining calories in `display-sm`.

---

## 6. Do's and Don'ts

### Do
*   **Optimize for the Thumb Zone:** Place primary actions (Add Meal, Search) within the bottom 33% of the screen.
*   **Use Intentional Asymmetry:** In the hero header, let the "Daily Summary" card slightly overlap a background texture or image to break the "boxed-in" feel.
*   **Micro-Interactions:** When a user logs a meal, use a haptic "tap" and a subtle scale-up animation (1.02x) on the card.

### Don't
*   **Don't use 100% Black:** Always use `on-surface` (#191c1d) for text to maintain a premium, soft-natural feel.
*   **Don't use Standard Dividers:** If you feel the need for a line, increase the `surface-container` contrast instead.
*   **Don't Overcrowd:** Even with high information density, ensure every data point has at least `2.5` (0.5rem) of clear space from its nearest neighbor.
