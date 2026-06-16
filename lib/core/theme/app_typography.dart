import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // Using Inter - Tighter and bolder for iOS Premium look
  static TextStyle get _base => GoogleFonts.inter(letterSpacing: -0.2);
  
  static TextStyle get _mono => GoogleFonts.jetBrainsMono();

  static TextStyle get display => _base.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w900, // Black/Heavy
        letterSpacing: -1.2,
        height: 1.1,
      );

  static TextStyle get headline => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w800, // Extra Bold
        letterSpacing: -0.6,
        height: 1.2,
      );

  static TextStyle get title => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700, // Bold
        letterSpacing: -0.4,
      );

  static TextStyle get titleSmall => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get body => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600, // Semi-bold
        height: 1.4,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get label => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get tag => _base.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      );

  static TextStyle get url => _mono.copyWith(
        fontSize: 12,
        letterSpacing: -0.2,
      );

  // ──────────────────────────────────────────────
  // Neo-Brutalist Typography
  // ──────────────────────────────────────────────
  static TextStyle get neoDisplay => GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.2,
        height: 1.1,
      );

  static TextStyle get neoHeadline => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.6,
        height: 1.2,
      );

  static TextStyle get neoTitle => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.4,
      );

  static TextStyle get neoTitleSmall => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w900,
      );

  static TextStyle get neoBody => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get neoBodyMedium => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.4,
      );

  static TextStyle get neoCaption => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        height: 1.4,
      );

  static TextStyle get neoLabel => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
      );

  static TextStyle get neoTag => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      );
}

