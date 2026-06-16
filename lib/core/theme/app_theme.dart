import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.accentPurple,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentPurple,
        onPrimary: AppColors.bgLight,
        secondary: AppColors.accentLavender,
        surface: AppColors.bgLight,
        onSurface: AppColors.textBlack,
        error: AppColors.error,
        outline: AppColors.borderLight,
        surfaceContainer: AppColors.surfaceLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: AppColors.textBlack,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.textBlack),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentPurple, width: 1.2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 0.5,
        space: 1,
      ),
      textTheme: _textTheme(AppColors.textBlack, AppColors.textGrey),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentLight,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentLight,
        onPrimary: AppColors.bgDark,
        secondary: AppColors.accentGreyDark,
        surface: AppColors.bgDark,
        onSurface: AppColors.textWhite,
        error: AppColors.error,
        outline: AppColors.borderDark,
        surfaceContainer: AppColors.surfaceDark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: AppColors.textWhite,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.textWhite),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        hintStyle: const TextStyle(color: AppColors.textGreyDark, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentLight, width: 1.2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 0.5,
        space: 1,
      ),
      textTheme: _textTheme(AppColors.textWhite, AppColors.textGreyDark),
    );
  }

  static ThemeData get neoBrutalistLightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.neoAccent,
      scaffoldBackgroundColor: AppColors.neoBgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.neoAccent,
        onPrimary: AppColors.neoTextLight,
        secondary: AppColors.neoAccent,
        surface: AppColors.neoBgLight,
        onSurface: AppColors.neoTextLight,
        error: AppColors.error,
        outline: AppColors.neoBorderLight,
        surfaceContainer: AppColors.neoSurfaceLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.neoCardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.neoBorderLight, width: 1.5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.neoBgLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: AppColors.neoTextLight,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.neoTextLight),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neoSurfaceLight,
        hintStyle: const TextStyle(color: AppColors.neoTextGreyLight, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neoBorderLight, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neoBorderLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neoBorderLight, width: 2.0),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neoBorderLight,
        thickness: 1.5,
        space: 1,
      ),
      textTheme: _neoTextTheme(AppColors.neoTextLight, AppColors.neoTextGreyLight),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neoAccent,
          foregroundColor: AppColors.neoTextLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.neoBorderLight, width: 1.5),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neoTextLight,
          side: const BorderSide(color: AppColors.neoBorderLight, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.neoTextLight,
          textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ),
    );
  }

  static ThemeData get neoBrutalistDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.neoAccent,
      scaffoldBackgroundColor: AppColors.neoBgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neoAccent,
        onPrimary: AppColors.neoTextDark,
        secondary: AppColors.neoAccent,
        surface: AppColors.neoBgDark,
        onSurface: AppColors.neoTextDark,
        error: AppColors.error,
        outline: AppColors.neoBorderDark,
        surfaceContainer: AppColors.neoSurfaceDark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.neoCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.neoBorderDark, width: 1.5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.neoBgDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: AppColors.neoTextDark,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.neoTextDark),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neoSurfaceDark,
        hintStyle: const TextStyle(color: AppColors.neoTextGreyDark, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neoBorderDark, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neoBorderDark, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neoAccent, width: 2.0),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neoBorderDark,
        thickness: 1.5,
        space: 1,
      ),
      textTheme: _neoTextTheme(AppColors.neoTextDark, AppColors.neoTextGreyDark),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neoAccent,
          foregroundColor: AppColors.neoBgDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.neoBorderDark, width: 1.5),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neoTextDark,
          side: const BorderSide(color: AppColors.neoBorderDark, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.neoTextDark,
          textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color textColor, Color subColor) {
    return TextTheme(
      displayLarge: AppTypography.display.copyWith(color: textColor, fontWeight: FontWeight.w800),
      headlineMedium: AppTypography.headline.copyWith(color: textColor, fontWeight: FontWeight.bold),
      titleLarge: AppTypography.title.copyWith(color: textColor, fontWeight: FontWeight.bold),
      bodyLarge: AppTypography.body.copyWith(color: textColor),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: textColor, fontWeight: FontWeight.w600),
      labelMedium: AppTypography.label.copyWith(color: subColor),
      labelSmall: AppTypography.tag.copyWith(color: textColor),
    );
  }

  static TextTheme _neoTextTheme(Color textColor, Color subColor) {
    return TextTheme(
      displayLarge: AppTypography.neoDisplay.copyWith(color: textColor),
      headlineMedium: AppTypography.neoHeadline.copyWith(color: textColor),
      titleLarge: AppTypography.neoTitle.copyWith(color: textColor),
      titleMedium: AppTypography.neoTitleSmall.copyWith(color: textColor),
      bodyLarge: AppTypography.neoBody.copyWith(color: textColor),
      bodyMedium: AppTypography.neoBodyMedium.copyWith(color: textColor),
      labelMedium: AppTypography.neoLabel.copyWith(color: subColor),
      labelSmall: AppTypography.neoTag.copyWith(color: textColor),
    );
  }
}

