import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Color tokens. Neutrals carry the UI; [primary] is the single accent.
/// Macro / water / sleep colors are data colors for charts and rings only.
class AppColors {
  // Surfaces, from the page up.
  static const background = Color(0xFF0A0C0F);
  static const card = Color(0xFF13161B);
  static const cardHigh = Color(0xFF1B1F26);
  static const cardHighest = Color(0xFF252A32);
  static const border = Color(0xFF262B33);
  static const borderStrong = Color(0xFF353B45);

  // Accent ("volt").
  static const primary = Color(0xFFC6F432);
  static const primaryDark = Color(0xFF7FA315); // primary muscles on body map
  static const primaryLight = Color(0xFFE2FA9A); // secondary muscles on body map
  static const onPrimary = Color(0xFF0D1300);

  // Text.
  static const text = Color(0xFFF2F4F7);
  static const textMuted = Color(0xFF8E97A6);
  static const textSubtle = Color(0xFF5E6674);

  // Status.
  static const danger = Color(0xFFFF5A5F);
  static const warning = Color(0xFFFFB020);
  static const info = Color(0xFF4DA8FF);

  // Data.
  static const protein = Color(0xFFFF7A6B);
  static const carbs = Color(0xFFFFC247);
  static const fat = Color(0xFFA78BFA);
  static const water = Color(0xFF4DB8FF);
  static const rest = Color(0xFF4A515C);
}

/// Spacing and radius tokens (4px rhythm).
class AppSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

class AppRadius {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 28.0;
  static const pill = 999.0;
}

/// Motion tokens. Everything animated in the app picks its timing from here.
class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 260);
  static const slow = Duration(milliseconds: 420);
  static const reveal = Duration(milliseconds: 900);

  /// Delay between items of a staggered list entrance.
  static const stagger = Duration(milliseconds: 45);

  static const standard = Curves.easeOutCubic;
  static const emphasized = Curves.easeOutQuart;
  static const overshoot = Curves.easeOutBack;
}

class AppTheme {
  static const fontAr = 'Cairo';
  static const fontEn = 'Inter';

  static const _tabular = [FontFeature.tabularFigures()];

  static TextTheme _textTheme(String family) {
    TextStyle s(double size, FontWeight w, {double? height, double? spacing, Color? color, bool nums = false}) =>
        TextStyle(
          fontFamily: family,
          fontSize: size,
          fontWeight: w,
          height: height,
          letterSpacing: spacing,
          color: color ?? AppColors.text,
          fontFeatures: nums ? _tabular : null,
        );
    return TextTheme(
      displayLarge: s(56, FontWeight.w800, height: 1.05, spacing: -1.5, nums: true),
      displayMedium: s(44, FontWeight.w800, height: 1.08, spacing: -1, nums: true),
      displaySmall: s(36, FontWeight.w800, height: 1.1, spacing: -0.5, nums: true),
      headlineLarge: s(30, FontWeight.w800, height: 1.15, spacing: -0.5),
      headlineMedium: s(26, FontWeight.w800, height: 1.2, spacing: -0.3),
      headlineSmall: s(22, FontWeight.w700, height: 1.25, nums: true),
      titleLarge: s(20, FontWeight.w700, height: 1.3),
      titleMedium: s(16, FontWeight.w700, height: 1.35),
      titleSmall: s(14, FontWeight.w600, height: 1.35),
      bodyLarge: s(16, FontWeight.w400, height: 1.5),
      bodyMedium: s(14, FontWeight.w400, height: 1.5),
      bodySmall: s(12.5, FontWeight.w400, height: 1.45, color: AppColors.textMuted),
      labelLarge: s(14, FontWeight.w700, height: 1.2),
      labelMedium: s(12, FontWeight.w600, height: 1.2, color: AppColors.textMuted),
      labelSmall: s(11, FontWeight.w600, height: 1.2, spacing: 0.4, color: AppColors.textMuted),
    );
  }

  static ThemeData dark(Locale locale) {
    final family = locale.languageCode == 'ar' ? fontAr : fontEn;
    final text = _textTheme(family);
    final scheme = const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: Color(0xFF2A3510),
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      secondaryContainer: AppColors.cardHighest,
      onSecondaryContainer: AppColors.text,
      tertiary: AppColors.info,
      surface: AppColors.card,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.textMuted,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.card,
      surfaceContainer: AppColors.card,
      surfaceContainerHigh: AppColors.cardHigh,
      surfaceContainerHighest: AppColors.cardHighest,
      error: AppColors.danger,
      onError: Color(0xFF1A0001),
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.border,
      shadow: Colors.black,
      scrim: Colors.black,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: family,
      fontFamilyFallback: const [fontAr, fontEn],
      scaffoldBackgroundColor: AppColors.background,
      textTheme: text,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
    );
    final shapeMd = RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md));
    final buttonText = TextStyle(fontFamily: family, fontWeight: FontWeight.w700, fontSize: 16);
    return base.copyWith(
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        for (final p in TargetPlatform.values) p: const LiftPageTransitionsBuilder(),
      }),
      iconTheme: const IconThemeData(color: AppColors.text, size: 24, weight: 400, fill: 0, opticalSize: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSpace.lg,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primary.withValues(alpha: 0.16),
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
              color: s.contains(WidgetState.selected) ? AppColors.primary : AppColors.textMuted,
              fill: s.contains(WidgetState.selected) ? 1 : 0,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
              fontFamily: family,
              fontSize: 12,
              fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
              color: s.contains(WidgetState.selected) ? AppColors.text : AppColors.textMuted,
            )),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((s) {
            if (s.contains(WidgetState.disabled)) return AppColors.cardHighest;
            if (s.contains(WidgetState.pressed)) return AppColors.primaryLight;
            return AppColors.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.disabled) ? AppColors.textSubtle : AppColors.onPrimary),
          overlayColor: WidgetStatePropertyAll(AppColors.onPrimary.withValues(alpha: 0.08)),
          minimumSize: const WidgetStatePropertyAll(Size(64, 54)),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 22)),
          textStyle: WidgetStatePropertyAll(buttonText),
          iconSize: const WidgetStatePropertyAll(22),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md + 2))),
          animationDuration: AppMotion.fast,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: AppColors.borderStrong),
          minimumSize: const Size(64, 50),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          textStyle: buttonText.copyWith(fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md + 2)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: TextStyle(fontFamily: family, fontWeight: FontWeight.w700, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        extendedTextStyle: buttonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.textSubtle),
        labelStyle: const TextStyle(color: AppColors.textMuted),
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.cardHigh,
        selectedColor: AppColors.primary.withValues(alpha: 0.16),
        checkmarkColor: AppColors.primary,
        side: WidgetStateBorderSide.resolveWith((s) => BorderSide(
              color: s.contains(WidgetState.selected) ? AppColors.primary.withValues(alpha: 0.6) : AppColors.border,
            )),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
        labelStyle: TextStyle(fontFamily: family, color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.cardHigh),
          foregroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? AppColors.onPrimary : AppColors.textMuted),
          side: const WidgetStatePropertyAll(BorderSide(color: AppColors.border)),
          textStyle: WidgetStatePropertyAll(TextStyle(fontFamily: family, fontWeight: FontWeight.w700)),
          shape: WidgetStatePropertyAll(shapeMd),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: TextStyle(fontFamily: family, fontWeight: FontWeight.w700, fontSize: 14),
        unselectedLabelStyle: TextStyle(fontFamily: family, fontWeight: FontWeight.w600, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        indicator: ShapeDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          shape: StadiumBorder(side: BorderSide(color: AppColors.primary.withValues(alpha: 0.45))),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.textMuted,
        textColor: AppColors.text,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
        minVerticalPadding: 10,
        titleTextStyle: text.titleSmall,
        subtitleTextStyle: text.bodySmall,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textMuted,
        shape: Border(),
        collapsedShape: Border(),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, space: 1, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cardHighest,
        contentTextStyle: TextStyle(fontFamily: family, color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
        actionTextColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          side: const BorderSide(color: AppColors.borderStrong),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.card,
        showDragHandle: true,
        dragHandleColor: AppColors.borderStrong,
        dragHandleSize: Size(40, 4),
        modalBarrierColor: Color(0xB3000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardHigh,
        surfaceTintColor: Colors.transparent,
        barrierColor: const Color(0xB3000000),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.textMuted),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.cardHighest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        textStyle: text.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.borderStrong),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.cardHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.borderStrong),
        ),
        textStyle: TextStyle(fontFamily: family, color: AppColors.text, fontSize: 12),
      ),
      badgeTheme: const BadgeThemeData(backgroundColor: AppColors.primary, textColor: AppColors.onPrimary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.cardHighest,
        circularTrackColor: Colors.transparent,
        linearMinHeight: 6,
      ),
      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.cardHighest,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        valueIndicatorColor: AppColors.cardHighest,
        trackHeight: 6,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.onPrimary : AppColors.textMuted),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.cardHighest),
        trackOutlineColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.borderStrong),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.transparent),
        checkColor: const WidgetStatePropertyAll(AppColors.onPrimary),
        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.textMuted),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.cardHigh,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: AppColors.cardHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.cardHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      ),
    );
  }
}

/// Page transition: the new route lifts in (fade + short upward slide + slight
/// scale) while the old one recedes a little. Calmer than the zoom default.
class LiftPageTransitionsBuilder extends PageTransitionsBuilder {
  const LiftPageTransitionsBuilder();

  @override
  Duration get transitionDuration => AppMotion.slow;

  @override
  Duration get reverseTransitionDuration => AppMotion.base;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final enter = CurvedAnimation(parent: animation, curve: AppMotion.emphasized, reverseCurve: Curves.easeInCubic);
    final exit = CurvedAnimation(parent: secondaryAnimation, curve: AppMotion.standard);
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.6).animate(exit),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 0.97).animate(exit),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: animation, curve: const Interval(0, 0.6, curve: Curves.easeOut))),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(enter),
            child: ScaleTransition(scale: Tween<double>(begin: 0.985, end: 1).animate(enter), child: child),
          ),
        ),
      ),
    );
  }
}
