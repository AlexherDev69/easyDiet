<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# design-claude

## Purpose
Design system documentation and UI handoff: design tokens, component library, style guide, and Figma/design tool exports for developers.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `handoff/` | Vite project with design tokens, component showcase, interactive style guide |

## For AI Agents

### Working In This Directory
- **design-claude/** is a design documentation index.
- **handoff/** is a Vite+Vue/React project for interactive design tool integration.
- Update design tokens, component specs, and color palette here.
- Designers use this to export design specs; developers use it to reference Material 3 specs and Emerald palette.

## Dependencies

### Internal
- `lib/core/theme/app_colors.dart` — Live color palette
- `lib/core/theme/app_theme.dart` — Material 3 theme definitions

### External
- Design tool (Figma, Adobe XD) — Export specs
- Vite (optional handoff project)

<!-- MANUAL: -->
