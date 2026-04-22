import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Time the ghost spends at the origin playing the check animation
/// before it swipes away. Matches the built-in check-tile fill and
/// strike-through animations so they finish before the exit.
const Duration _kGhostCheckHold = Duration(milliseconds: 140);

/// Duration of the ghost's swipe-right exit.
const Duration _kExitDuration = Duration(milliseconds: 280);

/// Duration of the new-slot entrance animation (slide-from-right + fade).
const Duration _kEntranceDuration = Duration(milliseconds: 320);

/// Distance the ghost slides to the right as it swipes off.
const double _kExitTranslateX = 140;

/// Distance the new-slot row slides in from as it appears.
const double _kEntranceTranslateX = 42;

/// A single shopping item row — compact glass tile with a 26×26 gradient
/// check tile, label + quantity, and an info/delete trailing button.
///
/// Stateful to support an *optimistic* check: when the user taps the
/// checkbox we flip the visual state locally so the check animation plays
/// immediately, then after [_kCheckDispatchDelay] we dispatch to the cubit
/// which reorders the list (unchecked items stay on top, checked fall to
/// the bottom of their section). The user perceives "coche → descend".
class ShoppingItemRow extends StatefulWidget {
  const ShoppingItemRow({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onShowDetail,
    super.key,
  });

  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onShowDetail;

  @override
  State<ShoppingItemRow> createState() => _ShoppingItemRowState();
}

class _ShoppingItemRowState extends State<ShoppingItemRow>
    with TickerProviderStateMixin {
  /// Overrides [widget.item.isChecked] while the ghost is alive. Null
  /// means "defer to the real state".
  bool? _pendingChecked;

  /// Drives the row's slide-from-right entrance at its new position.
  late final AnimationController _entrance;

  /// True while a ghost spawned by this row is in flight. Used to
  /// short-circuit re-taps and to render the source as invisible until
  /// the cubit reorders the list. Survives a [State] disposal because
  /// the ghost is overlay-owned (see [_FlightGhostOverlay]).
  bool _hiddenForFlight = false;

  Timer? _liftoffTimer;

  /// Scheduled at ghost-spawn time to un-hide the row at its new slot
  /// once the overlay ghost has finished its swipe-right animation. The
  /// row's [State] migrates from the old to the new position via the
  /// item-id key, so this timer fires on the SAME [State] that triggered
  /// the toggle — provided the new slot is on-screen. If it isn't, the
  /// State is disposed and the timer is cancelled in [dispose].
  Timer? _unhideTimer;

  @override
  void initState() {
    super.initState();
    _entrance =
        AnimationController(vsync: this, duration: _kEntranceDuration);
  }

  @override
  void didUpdateWidget(covariant ShoppingItemRow old) {
    super.didUpdateWidget(old);
    if (_pendingChecked != null &&
        widget.item.isChecked == _pendingChecked) {
      _pendingChecked = null;
    }
  }

  @override
  void dispose() {
    _liftoffTimer?.cancel();
    _unhideTimer?.cancel();
    _entrance.dispose();
    super.dispose();
  }

  void _handleToggle() {
    if (_hiddenForFlight) return;

    final current = _pendingChecked ?? widget.item.isChecked;
    final next = !current;

    // Phase 1: optimistic check → the real row plays the check-tile fill
    // and strike-through animations for `_kGhostCheckHold`. No reorder
    // yet, nothing else moves.
    setState(() => _pendingChecked = next);
    _liftoffTimer?.cancel();
    _liftoffTimer = Timer(_kGhostCheckHold, _spawnGhostAndDispatch);
  }

  /// Phase 2: capture the row's still-current position, push a ghost into
  /// the root overlay (the ghost owns its own controller + lifecycle, so
  /// it survives this row being unmounted when the list reorders the
  /// item to an off-screen slot), then dispatch the cubit toggle.
  void _spawnGhostAndDispatch() {
    if (!mounted) return;
    final ro = context.findRenderObject();
    if (ro is! RenderBox || !ro.attached) {
      widget.onToggle();
      return;
    }
    final origin = ro.localToGlobal(Offset.zero);
    final size = ro.size;
    final overlay = Overlay.of(context, rootOverlay: true);

    _FlightGhostOverlay.spawn(
      overlay: overlay,
      origin: origin,
      size: size,
      item: widget.item,
      checked: _pendingChecked ?? widget.item.isChecked,
    );

    setState(() => _hiddenForFlight = true);
    widget.onToggle();

    // Programme la révélation de la ligne à sa NOUVELLE position. Avec
    // la `ValueKey(item.id)`, ce State migre vers la nouvelle slot
    // après le rebuild du SliverList ; le timer reste donc attaché au
    // bon State. Si la nouvelle position est hors viewport, le State
    // est disposé et le timer s'annule via `dispose`.
    _unhideTimer?.cancel();
    _unhideTimer = Timer(_kExitDuration, () {
      if (!mounted) return;
      setState(() => _hiddenForFlight = false);
      _entrance.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final checked = _pendingChecked ?? widget.item.isChecked;
    final row = _buildRow(checked);
    if (_hiddenForFlight) {
      // Preserve layout (same height + padding) but draw nothing so the
      // item only appears once — in the overlay ghost. This row will
      // typically be disposed by the next frame anyway because the
      // cubit toggle reorders the list and the item moves elsewhere.
      return Visibility(
        visible: false,
        maintainSize: true,
        maintainState: true,
        maintainAnimation: true,
        child: row,
      );
    }
    // Slide-from-right + fade-in entrance when the row un-hides at its
    // new slot. Static when the controller is dismissed → zero overhead
    // for rows that were never toggled.
    return AnimatedBuilder(
      animation: _entrance,
      builder: (ctx, child) {
        if (_entrance.status == AnimationStatus.dismissed) return child!;
        final t = Curves.easeOutCubic.transform(_entrance.value);
        final dx = (1 - t) * _kEntranceTranslateX;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: Opacity(opacity: t, child: child),
        );
      },
      child: row,
    );
  }

  Widget _buildRow(bool checked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        compact: true,
        padding: const EdgeInsets.all(12),
        borderRadius: 14,
        // Pas de onTap sur la carte : la modal de provenance (recettes
        // sources) n'est ouverte QUE depuis le bouton info à droite.
        // Taper sur le corps de la ligne ne fait rien (évite les
        // ouvertures intempestives en scrollant / en visant la coche).
        child: Row(
          children: [
            _CheckTile(checked: checked, onTap: _handleToggle),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    style: AppText.body14Bold.copyWith(
                      color: const Color(0xFF0F172A).withValues(
                        alpha: checked ? 0.5 : 1,
                      ),
                      decoration: checked ? TextDecoration.lineThrough : null,
                    ),
                    child: Text(
                      widget.item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 1),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    style: AppText.meta11.copyWith(
                      color: const Color(0xFF64748B).withValues(
                        alpha: checked ? 0.5 : 1,
                      ),
                    ),
                    child: Text(
                      QuantityFormatter.formatWithUnit(
                        widget.item.quantity,
                        widget.item.unit,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _TrailingButton(
              icon: widget.item.isManuallyAdded
                  ? LucideIcons.trash2
                  : LucideIcons.info,
              color: widget.item.isManuallyAdded
                  ? const Color(0xFFF43F5E)
                  : const Color(0xFF94A3B8),
              onTap: widget.item.isManuallyAdded
                  ? widget.onDelete
                  : widget.onShowDetail,
              tooltip: widget.item.isManuallyAdded
                  ? 'Supprimer'
                  : 'Informations',
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  const _CheckTile({required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    return Semantics(
      button: true,
      checked: checked,
      label: checked ? 'Decocher' : 'Cocher',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              gradient: checked ? gradient : null,
              color: checked
                  ? null
                  : const Color(0xFF0F172A).withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
              border: checked
                  ? null
                  : Border.all(
                      color:
                          const Color(0xFF0F172A).withValues(alpha: 0.18),
                      width: 2,
                    ),
            ),
            child: checked
                ? const Icon(
                    LucideIcons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _TrailingButton extends StatelessWidget {
  const _TrailingButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 28,
            height: 28,
            child: Icon(icon, size: 16, color: color),
          ),
        ),
      ),
    );
  }
}

/// Self-owned overlay ghost. Carries its own [AnimationController] inside
/// a [State] so it survives the source row being unmounted (which happens
/// in long lists when the cubit toggle moves the item to an off-screen
/// slot and the SliverList recycles the original element).
///
/// Spawn via [spawn]; the entry removes itself from the overlay when the
/// exit animation completes.
class _FlightGhostOverlay extends StatefulWidget {
  const _FlightGhostOverlay({
    required this.origin,
    required this.size,
    required this.item,
    required this.checked,
    required this.onComplete,
  });

  final Offset origin;
  final Size size;
  final ShoppingItem item;
  final bool checked;
  final VoidCallback onComplete;

  /// Push a fresh ghost onto [overlay] starting at [origin]. The overlay
  /// entry is removed automatically once the exit animation completes.
  static void spawn({
    required OverlayState overlay,
    required Offset origin,
    required Size size,
    required ShoppingItem item,
    required bool checked,
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _FlightGhostOverlay(
        origin: origin,
        size: size,
        item: item,
        checked: checked,
        onComplete: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  }

  @override
  State<_FlightGhostOverlay> createState() => _FlightGhostOverlayState();
}

class _FlightGhostOverlayState extends State<_FlightGhostOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _exit;

  @override
  void initState() {
    super.initState();
    _exit = AnimationController(vsync: this, duration: _kExitDuration);
    _exit.forward().whenComplete(widget.onComplete);
  }

  @override
  void dispose() {
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _exit,
      builder: (ctx, _) {
        final t = Curves.easeInCubic.transform(_exit.value);
        final dx = t * _kExitTranslateX;
        final opacity = (1 - t).clamp(0.0, 1.0);
        final scale = 1 - t * 0.04;
        return Positioned(
          left: widget.origin.dx + dx,
          top: widget.origin.dy,
          width: widget.size.width,
          height: widget.size.height,
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: _GhostRowBody(
                    item: widget.item,
                    checked: widget.checked,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Static, non-interactive rendering of a row for the ghost. Mirrors
/// [_ShoppingItemRowState._buildRow] but with stripped callbacks and no
/// animated text style (the check anim is handled by [_CheckTile] itself
/// via [AnimatedContainer], which runs regardless of context).
class _GhostRowBody extends StatelessWidget {
  const _GhostRowBody({required this.item, required this.checked});

  final ShoppingItem item;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        compact: true,
        padding: const EdgeInsets.all(12),
        borderRadius: 14,
        child: Row(
          children: [
            _CheckTile(checked: checked, onTap: () {}),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body14Bold.copyWith(
                      color: const Color(0xFF0F172A).withValues(
                        alpha: checked ? 0.5 : 1,
                      ),
                      decoration:
                          checked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    QuantityFormatter.formatWithUnit(
                      item.quantity,
                      item.unit,
                    ),
                    style: AppText.meta11.copyWith(
                      color: const Color(0xFF64748B).withValues(
                        alpha: checked ? 0.5 : 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _TrailingButton(
              icon: item.isManuallyAdded
                  ? LucideIcons.trash2
                  : LucideIcons.info,
              color: item.isManuallyAdded
                  ? const Color(0xFFF43F5E)
                  : const Color(0xFF94A3B8),
              onTap: () {},
              tooltip: '',
            ),
          ],
        ),
      ),
    );
  }
}
