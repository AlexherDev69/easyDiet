import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pre-built Nunito [TextStyle]s used across the app.
///
/// Each style is a `static final` — instantiated once the first time it's
/// read, then reused forever. This removes the per-frame cost of calling
/// `GoogleFonts.nunito(...)` inline in widget `build()` methods, which
/// otherwise creates a fresh [TextStyle] every time a row repaints
/// (noticeably expensive in long scrollable lists).
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppText.h1);
/// Text('World', style: AppText.body14Bold.copyWith(color: Colors.red));
/// ```
///
/// Pick the closest style, then `.copyWith()` for one-off tweaks (size,
/// color, letterSpacing). Keep ad-hoc styles out of this file — only add
/// a new entry when it's used in ≥2 places.
class AppText {
  AppText._();

  /// Base regular style — used as a starting point for `.copyWith()`.
  static final TextStyle base = GoogleFonts.nunito();

  // ── Display / headings ──────────────────────────────────────────────

  /// 24 / w800 / tight tracking — big page titles, stat hero numbers.
  static final TextStyle h1 = GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: const Color(0xFF0F172A),
  );

  /// 20 / w800 — section titles.
  static final TextStyle h2 = GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF0F172A),
  );

  /// 18 / w700 — card titles.
  static final TextStyle h3 = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF0F172A),
  );

  // ── Body ────────────────────────────────────────────────────────────

  /// 14 / w800 — emphasized body (pill labels, strong tags).
  static final TextStyle body14Black = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF0F172A),
  );

  /// 14 / w700 — primary row titles (shopping item name, list labels).
  static final TextStyle body14Bold = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: const Color(0xFF0F172A),
  );

  /// 14 / w600 — standard body.
  static final TextStyle body14 = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF0F172A),
  );

  /// 13 / w700 — subdued body emphasis.
  static final TextStyle body13Bold = GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF64748B),
  );

  // ── Captions / meta ─────────────────────────────────────────────────

  /// 12 / w800 — pill labels, small strong caps.
  static final TextStyle caption12Black = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF0F172A),
  );

  /// 12 / w700 / tracked — section eyebrows ("CETTE SEMAINE").
  static final TextStyle eyebrow12 = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
    color: const Color(0xFF64748B),
  );

  /// 11 / w800 / tracked — small uppercase caps.
  static final TextStyle eyebrow11 = GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.6,
    color: const Color(0xFF059669),
  );

  /// 11 / w600 — secondary meta (item quantity, muted hints).
  static final TextStyle meta11 = GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF64748B),
  );

  /// 10 / w800 — tiny counters.
  static final TextStyle counter10 = GoogleFonts.nunito(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF64748B),
  );

  // ── Empty-state / helper ────────────────────────────────────────────

  /// 12 / w400 — empty-state body.
  static final TextStyle empty12 = GoogleFonts.nunito(
    fontSize: 12,
    color: const Color(0xFF64748B),
  );
}
