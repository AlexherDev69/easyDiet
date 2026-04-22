import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import 'blob_bg.dart';
import 'glass_card.dart';
import 'gradient_title.dart';

/// Full-screen generation loading view with pulsing hero, rotating phase,
/// progress bar, and progressively-appearing stat chips.
///
/// Used during plan generation (onboarding, plan preview, quick regenerate).
class GenerationLoadingView extends StatefulWidget {
  const GenerationLoadingView({
    this.phases = const [
      'Analyse de vos preferences...',
      'Selection des recettes...',
      'Equilibrage des macros...',
      'Calcul de la liste de courses...',
    ],
    this.chips = const [
      LoadingChip('96 recettes scannees', LucideIcons.sparkles, AppColors.emeraldPrimary),
      LoadingChip('7 jours planifies', LucideIcons.check, Color(0xFF8B5CF6)),
      LoadingChip('Macros equilibrees', LucideIcons.check, Color(0xFFF59E0B)),
    ],
    super.key,
  });

  final List<String> phases;
  final List<LoadingChip> chips;

  @override
  State<GenerationLoadingView> createState() => _GenerationLoadingViewState();
}

class _GenerationLoadingViewState extends State<GenerationLoadingView>
    with TickerProviderStateMixin {
  late final AnimationController _progressCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _shimmerCtrl;
  int _phase = 0;
  int _chipsShown = 0;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..forward();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _startPhaseRotation();
    _scheduleChips();
  }

  void _startPhaseRotation() {
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(milliseconds: 2200));
      if (!mounted) return false;
      setState(() => _phase = (_phase + 1) % widget.phases.length);
      return true;
    });
  }

  void _scheduleChips() {
    final delays = [900, 2100, 3400];
    for (var i = 0; i < widget.chips.length && i < delays.length; i++) {
      Future.delayed(Duration(milliseconds: delays[i]), () {
        if (mounted) setState(() => _chipsShown = i + 1);
      });
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: BlobBG(intensity: 1.2)),
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 40),
              child: Column(
                children: [
                  _HeroIcon(pulseCtrl: _pulseCtrl, shimmerCtrl: _shimmerCtrl),
                  const SizedBox(height: 28),
                  Text(
                    'UN INSTANT',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.emeraldDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GradientTitle(
                    'Creation de votre plan...',
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _PhaseText(phases: widget.phases, active: _phase),
                  const SizedBox(height: 20),
                  _ProgressBar(
                    progressCtrl: _progressCtrl,
                    shimmerCtrl: _shimmerCtrl,
                  ),
                  const SizedBox(height: 28),
                  _ChipsColumn(
                    chips: widget.chips,
                    shown: _chipsShown,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingChip {
  const LoadingChip(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.pulseCtrl, required this.shimmerCtrl});

  final AnimationController pulseCtrl;
  final AnimationController shimmerCtrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            _PulseRing(
              ctrl: pulseCtrl,
              delay: i * 0.33,
            ),
          AnimatedBuilder(
            animation: pulseCtrl,
            builder: (context, child) {
              final t = pulseCtrl.value;
              final scale = 1 + 0.06 * (0.5 - (t - 0.5).abs()) * 2;
              return Transform.scale(scale: scale, child: child);
            },
            child: ClipOval(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment(-0.4, -0.4),
                    colors: [
                      Color(0xFF34D399),
                      AppColors.emeraldPrimary,
                      AppColors.emeraldDark,
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withValues(alpha: 0.55),
                      blurRadius: 60,
                      offset: const Offset(0, 24),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: shimmerCtrl,
                      builder: (context, _) {
                        return Positioned.fill(
                          child: Transform.translate(
                            offset: Offset(
                              140 * (shimmerCtrl.value * 2 - 1),
                              0,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(-1, -0.2),
                                  end: Alignment(1, 0.2),
                                  colors: [
                                    Colors.transparent,
                                    Color(0x80FFFFFF),
                                    Colors.transparent,
                                  ],
                                  stops: [0.2, 0.5, 0.8],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const Icon(
                      LucideIcons.chefHat,
                      size: 60,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.ctrl, required this.delay});

  final AnimationController ctrl;
  final double delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final raw = (ctrl.value + delay) % 1.0;
        final scale = 1.0 + 0.8 * raw;
        final opacity = 0.55 * (1 - raw);
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity.clamp(0, 1),
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.emeraldPrimary.withValues(alpha: 0.5),
                    AppColors.emeraldPrimary.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.65],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PhaseText extends StatelessWidget {
  const _PhaseText({required this.phases, required this.active});

  final List<String> phases;
  final int active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        child: Text(
          phases[active],
          key: ValueKey(active),
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF475569),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progressCtrl, required this.shimmerCtrl});

  final AnimationController progressCtrl;
  final AnimationController shimmerCtrl;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(3),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: progressCtrl,
              builder: (context, _) {
                return FractionallySizedBox(
                  widthFactor: progressCtrl.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.emeraldPrimary,
                          Color(0xFF14B8A6),
                          AppColors.emeraldDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emeraldPrimary.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: shimmerCtrl,
              builder: (context, _) {
                return Positioned(
                  left: 320 * (shimmerCtrl.value * 1.5 - 0.5),
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 120,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0x99FFFFFF),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipsColumn extends StatelessWidget {
  const _ChipsColumn({required this.chips, required this.shown});

  final List<LoadingChip> chips;
  final int shown;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        children: List.generate(chips.length, (i) {
          if (i >= shown) return const SizedBox(height: 52);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChipRow(chip: chips[i]),
          );
        }),
      ),
    );
  }
}

class _ChipRow extends StatefulWidget {
  const _ChipRow({required this.chip});
  final LoadingChip chip;

  @override
  State<_ChipRow> createState() => _ChipRowState();
}

class _ChipRowState extends State<_ChipRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)),
        child: GlassCard(
          padding: const EdgeInsets.all(10),
          borderRadius: 14,
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.chip.color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(widget.chip.icon, size: 14, color: widget.chip.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.chip.label,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emeraldPrimary.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  LucideIcons.check,
                  size: 10,
                  color: AppColors.emeraldDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
