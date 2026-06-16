import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ──────────────────────────────────────────────
  // Notion & OLED Premium Palette
  // ──────────────────────────────────────────────
  
  // Accent Colors (Monochrome / Grayscale)
  static const Color accentDark     = Color(0xFF18181B); // High-contrast Charcoal/Black
  static const Color accentGrey     = Color(0xFF71717A); // Medium Gray for Light Mode
  static const Color accentLight    = Color(0xFFFFFFFF); // High-contrast White
  static const Color accentGreyDark = Color(0xFFA1A1AA); // Light Gray for Dark Mode
  
  // Keeping original names mapped for backward compatibility
  static const Color accentPurple   = accentDark;
  static const Color accentLavender = accentGrey;
  
  // Light Mode (Notion-Inspired Minimal)
  static const Color bgLight        = Color(0xFFFFFFFF);
  static const Color surfaceLight   = Color(0xFFF4F4F5);
  static const Color borderLight    = Color(0xFFE4E4E7);
  static const Color textBlack      = Color(0xFF18181B);
  static const Color textGrey       = Color(0xFF71717A);

  // Dark Mode (OLED Premium)
  static const Color bgDark         = Color(0xFF0F0F11);
  static const Color surfaceDark    = Color(0xFF18181B);
  static const Color cardDark       = Color(0xFF1F1F23);
  static const Color borderDark     = Color(0xFF2D2D30);
  static const Color textWhite      = Color(0xFFF4F4F5);
  static const Color textGreyDark   = Color(0xFFA1A1AA);

  // ──────────────────────────────────────────────
  // Neo-Brutalist Style Palette
  // ──────────────────────────────────────────────
  static const Color neoAccent       = Color(0xFFFFE600); // Cyber Yellow
  
  // Neo Light Mode
  static const Color neoBgLight      = Color(0xFFFFFFFF);
  static const Color neoSurfaceLight = Color(0xFFFFFFFF);
  static const Color neoCardLight    = Color(0xFFFFFFFF);
  static const Color neoBorderLight  = Color(0xFF000000); // Sharp Black Outlines
  static const Color neoTextLight    = Color(0xFF000000);
  static const Color neoTextGreyLight= Color(0xFF333333);

  // Neo Dark Mode
  static const Color neoBgDark       = Color(0xFF000000); // OLED Pitch Black
  static const Color neoSurfaceDark  = Color(0xFF1E1E1E); // Deep Charcoal card panels
  static const Color neoCardDark     = Color(0xFF1E1E1E);
  static const Color neoBorderDark   = Color(0xFFFFFFFF); // Sharp White Outlines
  static const Color neoTextDark     = Color(0xFFFFFFFF);
  static const Color neoTextGreyDark = Color(0xFFCCCCCC);

  // ──────────────────────────────────────────────
  // Semantic & Brand
  // ──────────────────────────────────────────────
  static const Color primary        = accentDark; // Main brand color
  static const Color error          = Color(0xFFFF3B30); // iOS System Red
  static const Color success        = Color(0xFF34C759); // iOS System Green
  static const Color warning        = Color(0xFFFFCC00); // iOS System Yellow

  // Legacy mappings for backward compatibility / stability
  static const Color background     = bgLight; 
  static const Color surface        = surfaceLight;
  static const Color card           = bgLight;
  static const Color divider        = borderLight;
  static const Color grey           = textGrey;
  static const Color greyDark       = textGrey;
  static const Color white          = bgLight;
  static const Color black          = bgDark;

  static const List<Color> primaryGradient = [
    accentPurple,
    accentLavender,
  ];
}
