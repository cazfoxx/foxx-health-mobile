import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class AppTextStyles {
  static const _fontFamily = 'Merriweather';
  static const _fontFamilyOpenSans = 'Opensans';

  static const TextStyle heading1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle body2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle labelOpensans = TextStyle(
    fontFamily: _fontFamilyOpenSans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  // OpenSans styles
  static const TextStyle bodyOpenSans = TextStyle(
    fontFamily: _fontFamilyOpenSans,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle body2OpenSans = TextStyle(
    fontFamily: _fontFamilyOpenSans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle captionOpenSans = TextStyle(
    fontFamily: _fontFamilyOpenSans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
   

  );

  static const TextStyle buttonOpenSans = TextStyle(
    fontFamily: _fontFamilyOpenSans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
