import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const background = Color(0xFF0A0A0A);
  static const card = Color(0xFF161616);
  static const cardHigh = Color(0xFF1F1F1F);
  static const border = Color(0xFF2A2A2A);
  static const primary = Color(0xFF39FF14); // neon green
  static const primaryDark = Color(0xFF1E8C0B); // primary muscles on body map
  static const primaryLight = Color(0xFF9DFF85); // secondary muscles on body map
  static const onPrimary = Color(0xFF051400);
  static const text = Color(0xFFF2F2F2);
  static const textMuted = Color(0xFF9A9A9A);
  static const danger = Color(0xFFFF4D4D);
  static const warning = Color(0xFFFFC83D);
  static const info = Color(0xFF3DB8FF);
  static const protein = Color(0xFFFF6B6B);
  static const carbs = Color(0xFFFFC83D);
  static const fat = Color(0xFF3DB8FF);
  static const water = Color(0xFF3DB8FF);
  static const rest = Color(0xFF5A5A5A);
}

class AppTheme {
  static const fontAr = 'Cairo';
  static const fontEn = 'Inter';

  static ThemeData dark(Locale locale) {
    final family = locale.languageCode == 'ar' ? fontAr : fontEn;
    final scheme = const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.card,
      onSurface: AppColors.text,
      error: AppColors.danger,
      surfaceContainerHighest: AppColors.cardHigh,
      outline: AppColors.border,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: family,
      fontFamilyFallback: const [fontAr, fontEn],
      scaffoldBackgroundColor: AppColors.background,
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.primary.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
              color: s.contains(WidgetState.selected) ? AppColors.primary : AppColors.textMuted,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
              fontFamily: family,
              fontSize: 12,
              color: s.contains(WidgetState.selected) ? AppColors.primary : AppColors.textMuted,
            )),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(64, 52),
          textStyle: TextStyle(fontFamily: family, fontWeight: FontWeight.w700, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.cardHigh,
        selectedColor: AppColors.primary.withValues(alpha: 0.25),
        side: const BorderSide(color: AppColors.border),
        labelStyle: TextStyle(fontFamily: family, color: AppColors.text),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, space: 1),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.cardHigh,
        contentTextStyle: TextStyle(color: AppColors.text),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: AppColors.card),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      sliderTheme: base.sliderTheme.copyWith(activeTrackColor: AppColors.primary, thumbColor: AppColors.primary),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.onPrimary : AppColors.textMuted),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.cardHigh),
      ),
    );
  }
}
