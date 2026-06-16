import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Central design-token + theme controller for the portfolio.
///
/// Mirrors the CSS custom properties from the original prototype:
/// a dark-first terminal aesthetic with Android-green / Flutter-cyan accents
/// that can be live-swapped (the "Tweaks" panel in the source).
class AppTheme extends ChangeNotifier {
  static const _themeKey = 'omar-portfolio-theme';
  static const _primaryKey = 'omar-portfolio-primary';
  static const _secondaryKey = 'omar-portfolio-secondary';

  bool _isLight = false;
  Color _primary = const Color(0xFF2F8FEE); // default from prototype tweaks
  Color _secondary = const Color(0xFF3DDC84);

  bool get isLight => _isLight;
  bool get isDark => !_isLight;

  /// Primary accent (Android-green family by default; prototype shipped blue).
  Color get primary => _primary;

  /// Secondary accent (Flutter-cyan family).
  Color get secondary => _secondary;

  /// Accent swatch options exposed in the original Tweaks panel.
  static const List<Color> primaryOptions = [
    Color(0xFF3DDC84),
    Color(0xFF2F8FEE),
    Color(0xFF7C6CF5),
    Color(0xFFF0A830),
    Color(0xFFFF6B5E),
    Color(0xFFE84393),
  ];
  static const List<Color> secondaryOptions = [
    Color(0xFF54C5F8),
    Color(0xFF3DDC84),
    Color(0xFF7C6CF5),
    Color(0xFFF0A830),
    Color(0xFF38BDF8),
    Color(0xFFF472B6),
  ];

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLight = prefs.getString(_themeKey) == 'light';
      final p = prefs.getInt(_primaryKey);
      final s = prefs.getInt(_secondaryKey);
      if (p != null) _primary = Color(p);
      if (s != null) _secondary = Color(s);
      notifyListeners();
    } catch (_) {
      // Persistence is best-effort; ignore failures (e.g. private mode).
    }
  }

  Future<void> toggleTheme() async {
    _isLight = !_isLight;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _isLight ? 'light' : 'dark');
    } catch (_) {}
  }

  Future<void> setPrimary(Color c) async {
    _primary = c;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_primaryKey, c.toARGB32());
    } catch (_) {}
  }

  Future<void> setSecondary(Color c) async {
    _secondary = c;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_secondaryKey, c.toARGB32());
    } catch (_) {}
  }

  // ---- Palette tokens (theme-dependent) ----
  Color get bg => _isLight ? const Color(0xFFFAFAF8) : const Color(0xFF0A0E14);
  Color get bgGrid => _isLight
      ? const Color(0x0A0A0E14)
      : const Color(0x06FFFFFF); // ~0.022 alpha white
  Color get surface =>
      _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F141D);
  Color get surface2 =>
      _isLight ? const Color(0xFFF6F7F5) : const Color(0xFF141B26);
  Color get surface3 =>
      _isLight ? const Color(0xFFEEF0ED) : const Color(0xFF19212E);
  Color get border =>
      _isLight ? const Color(0xFFE4E7E3) : const Color(0xFF1E2733);
  Color get border2 =>
      _isLight ? const Color(0xFFD3D8D2) : const Color(0xFF2B3645);
  Color get text =>
      _isLight ? const Color(0xFF11161D) : const Color(0xFFE7EDF4);
  Color get text2 =>
      _isLight ? const Color(0xFF505B66) : const Color(0xFF9AA7B6);
  Color get text3 =>
      _isLight ? const Color(0xFF8A95A0) : const Color(0xFF66727F);

  /// "Green"/"Cyan" map to the swappable primary/secondary accents.
  Color get green => _primary;
  Color get cyan => _secondary;
  Color get accent => _primary;

  double get _softAlpha => _isLight ? 0.11 : 0.13;
  Color get greenSoft => _primary.withValues(alpha: _softAlpha);
  Color get cyanSoft => _secondary.withValues(alpha: _softAlpha);

  /// Foreground used on top of a solid primary fill (dark green-tinted ink
  /// in the prototype: #04140a).
  Color get onPrimary =>
      _isLight ? Colors.white : const Color(0xFF04140A);

  List<BoxShadow> get cardShadow => _isLight
      ? [
          BoxShadow(
            color: const Color(0x0A101828),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: const Color(0x40101828),
            blurRadius: 40,
            spreadRadius: -28,
            offset: const Offset(0, 18),
          ),
        ]
      : [
          BoxShadow(
            color: const Color(0xCC000000),
            blurRadius: 40,
            spreadRadius: -24,
            offset: const Offset(0, 18),
          ),
        ];

  List<BoxShadow> get glow => [
        BoxShadow(
          color: _primary.withValues(alpha: _isLight ? 0.4 : 0.35),
          blurRadius: _isLight ? 40 : 50,
          spreadRadius: -18,
          offset: const Offset(0, 14),
        ),
      ];

  // ---- Typography (Space Grotesk / IBM Plex Sans / JetBrains Mono) ----
  static TextStyle display(
          {double? size, FontWeight weight = FontWeight.w600, Color? color, double? height, double letterSpacing = -0.02}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: (size ?? 16) * letterSpacing,
      );

  static TextStyle body(
          {double? size, FontWeight weight = FontWeight.w400, Color? color, double? height}) =>
      GoogleFonts.ibmPlexSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  static TextStyle mono(
          {double? size, FontWeight weight = FontWeight.w400, Color? color, double? height, double? letterSpacing}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
}

/// Layout breakpoints matching the prototype's CSS media queries.
class Breaks {
  static const double maxContent = 1140;
  static const double lg = 960;
  static const double md = 720;
  static const double sm = 460;

  static bool isDesktop(double w) => w > lg;
  static bool isTablet(double w) => w > md && w <= lg;
  static bool isMobile(double w) => w <= md;
  static bool isSmall(double w) => w <= sm;
}
