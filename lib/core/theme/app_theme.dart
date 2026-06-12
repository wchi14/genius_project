import 'package:flutter/material.dart';

/// Neo-Casino / tactical mind-sport palette (Design: Nova Phase 1).
abstract final class AppTheme {
  static const Color neoBackground = Color(0xFF121826);
  static const Color neoPurple = Color(0xFF8A2BE2);
  static const Color neoGold = Color(0xFFFFD700);
  static const Color neoTextPrimary = Color(0xFFFFFFFF);
  static const Color neoTextMuted = Color(0xFF9CA3AF);

  static TextTheme _neoTextTheme(TextTheme base) {
    TextStyle? w(TextStyle? s, FontWeight weight) =>
        s?.copyWith(fontWeight: weight);
    TextStyle? c(TextStyle? s, Color color) => s?.copyWith(color: color);

    // Material 3 already provides good baseline metrics; we mainly tighten the
    // hierarchy and add a bit more character through weight/spacing.
    return base.copyWith(
      displaySmall: w(base.displaySmall, FontWeight.w700)?.copyWith(letterSpacing: -0.6),
      headlineLarge: w(base.headlineLarge, FontWeight.w800)?.copyWith(letterSpacing: -0.8),
      headlineMedium: w(base.headlineMedium, FontWeight.w800)?.copyWith(letterSpacing: -0.6),
      headlineSmall: w(base.headlineSmall, FontWeight.w700)?.copyWith(letterSpacing: -0.3),
      titleLarge: w(base.titleLarge, FontWeight.w700),
      titleMedium: w(base.titleMedium, FontWeight.w700),
      titleSmall: w(base.titleSmall, FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.25),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.25),
      bodySmall: base.bodySmall?.copyWith(height: 1.2),
      labelLarge: w(base.labelLarge, FontWeight.w700)?.copyWith(letterSpacing: 0.2),
      labelMedium: w(base.labelMedium, FontWeight.w700)?.copyWith(letterSpacing: 0.2),
      labelSmall: w(base.labelSmall, FontWeight.w700)?.copyWith(letterSpacing: 0.15),
    ).apply(
      bodyColor: neoTextPrimary,
      displayColor: neoTextPrimary,
    ).copyWith(
      bodyMedium: c(base.bodyMedium, neoTextPrimary),
    );
  }

  /// Dark app shell used by [MaterialApp].
  static ThemeData neoCasinoDark() {
    final seeded = ColorScheme.fromSeed(
      seedColor: neoPurple,
      brightness: Brightness.dark,
    );
    final scheme = seeded.copyWith(
      surface: neoBackground,
      onSurface: neoTextPrimary,
      onSurfaceVariant: neoTextMuted,
      primary: neoPurple,
      onPrimary: neoTextPrimary,
      secondary: neoGold,
      onSecondary: neoBackground,
      surfaceContainerLow: const Color(0xFF161C2C),
      surfaceContainerHigh: const Color(0xFF1C2436),
      surfaceContainerHighest: const Color(0xFF232D42),
      outline: neoTextMuted.withValues(alpha: 0.45),
      outlineVariant: neoTextMuted.withValues(alpha: 0.25),
    );

    final textTheme = _neoTextTheme(ThemeData(brightness: Brightness.dark).textTheme);
    final radius = BorderRadius.circular(16);
    const buttonPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 14);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: neoBackground,
      colorScheme: scheme,
      textTheme: textTheme,
      dividerColor: neoTextMuted.withValues(alpha: 0.25),
      appBarTheme: const AppBarTheme(
        backgroundColor: neoBackground,
        foregroundColor: neoTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHigh,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: radius),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: neoTextPrimary,
          backgroundColor: neoPurple,
          disabledBackgroundColor: scheme.surfaceContainerHighest,
          disabledForegroundColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
          padding: buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          disabledForegroundColor: scheme.onSurfaceVariant.withValues(alpha: 0.6),
          padding: buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: radius),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.primary.withValues(alpha: 0.25),
        disabledColor: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        labelStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }
}
