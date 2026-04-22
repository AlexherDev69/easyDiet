# EasyDiet — React handoff

Clean ES module port of the EasyDiet prototype. No device frames, no design canvas, no Babel standalone — drop into Vite / Next / CRA.

## Structure

```
src/
  theme.css            # CSS variables (accent, glass tokens) + Nunito + blob keyframes
  data/fixtures.js     # All French meal/recipe/shopping/weight mock data
  components/
    Glass.jsx          # Frosted glass card wrapper
    Pill.jsx           # Day / filter chip
    GradText.jsx       # Emerald gradient title
    BlobBG.jsx         # Animated gradient blob background
    TabBar.jsx         # Bottom tab navigation (glass)
    RadialMacro.jsx    # Donut macro chart
    WeightChart.jsx    # Smoothed line chart
  screens/
    Dashboard.jsx
    MealPlan.jsx
    Shopping.jsx
    RecipesList.jsx
    RecipeDetail.jsx
    Weight.jsx
  App.jsx              # Screen router + bottom tabs
  main.jsx             # Vite entry
```

## Install

```sh
npm install
npm run dev
```

## Notes for integration

1. **Icons** — uses `lucide-react` with one-word names (Home, Utensils, ShoppingCart, BookOpen, Scale, …). Replace with your icon library if needed.
2. **Fonts** — Nunito via `@fontsource/nunito`. Imported once in `main.jsx`.
3. **Theme** — All colors live in `src/theme.css` as CSS custom properties. To hook into Tailwind, mirror these vars in `tailwind.config.js` (`theme.extend.colors`).
4. **Data** — `src/data/fixtures.js` is static mock. Replace with your API/store. Shapes are exported (see JSDoc comments).
5. **State** — Screens receive `state` and `setState` where they need to mutate (meals done, shopping checked). Swap for Zustand / Redux / server state as needed.
6. **Routing** — `App.jsx` uses a single `useState('home'|'meals'|...)`. Swap for React Router or Next `app/` segments.
7. **Dark mode** — add the class `dark` to `<html>` — `theme.css` already handles the swap.
8. **Glass backdrop-blur** — requires a parent with a colored background behind each screen; `BlobBG` provides it.

## Differences vs the prototype

| Prototype | Handoff |
|---|---|
| `Object.assign(window, {...})` | `export` / `import` |
| Inline SVG icon component | `lucide-react` |
| EDITMODE tweaks panel | Removed |
| iOS/Android device frames | Removed |
| Babel standalone | Vite + React plugin |

## Mobile target

This port targets **web** (Vite). For **React Native / Expo**, the structure maps cleanly but every `<div>`→`<View>`, `<button>`→`<Pressable>`, and all inline `style={{...}}` → `StyleSheet.create`. `backdrop-filter` isn't supported on RN — use `expo-blur` for the glass effect.
