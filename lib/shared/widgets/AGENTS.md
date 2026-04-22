<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose
9 reusable UI components across features: gradient/solid cards, dialogs, form fields, stepper cards, and styling utilities.

## Key Files
| File | Description |
|------|-------------|
| `gradient_card.dart` | Hero card with gradient background (meal calories, weight progress) |
| `solid_card.dart` | Standard card with solid background (info cards) |
| `free_days_section.dart` | Calendar widget for selecting free days |
| `stepper_card.dart` | Form stepper for multi-step inputs |
| `glass_card.dart` | Glassmorphism card (frosted glass effect) |
| `glass_dialog.dart` | Dialog with glass background |
| `gradient_title.dart` | Title with gradient text (section headers) |
| `pill_chip.dart` | Pill-shaped chip for tags (allergies, diet types) |
| `sync_text_field.dart` | Text field synchronized with external state |

## For AI Agents

### Working In This Directory
- Each widget is a pure, const-constructible component with no business logic.
- Parameterize via constructor: colors, text, callbacks, padding.
- Use `AppColors` from `lib/core/theme/app_colors.dart` for consistency.
- No state management in shared widgets — pass callbacks for interactions.
- Example usage patterns in feature pages (`lib/features/*/presentation/pages/`).

### Component Pattern
```dart
class GradientCard extends StatelessWidget {
  final String title;
  final String value;
  final Gradient gradient;
  final VoidCallback? onTap;
  
  const GradientCard({
    required this.title,
    required this.value,
    required this.gradient,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        // ... build UI
      ),
    );
  }
}
```

## Dependencies

### Internal
- `lib/core/theme/app_colors.dart` — Color palette

### External
- **flutter** — Material, StatelessWidget, BuildContext
- **google_fonts** — Nunito font

<!-- MANUAL: -->
