import 'package:flutter/material.dart';


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

class AppHeadingTextStyles {
  static const String _fontFamily = 'Merriweather';

  // h1-mw-bold
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 40, // 4xl
    height: 1.2,  // 2xl line height (approximate)
    letterSpacing: 0.0, // base
  );

  // h2-mw-bold
  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 32, // 3xl
    height: 1.2,  // xl line height (approximate)
    letterSpacing: 0.0, // base
  );

  // h3-mw-bold
  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 24, // 2xl
    height: 1.15, // lg line height (approximate)
    letterSpacing: 0.0, // base
  );

  // h4-mw-bold
  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 18, // xl
    height: 1.1,  // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
}

class AppOSTextStyles {
  static const String _fontFamily = 'OpenSans';

  // --- Title Styles ---
  static const TextStyle osXl = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // regular
    fontSize: 24, // xl
    height: 1.5, // xl line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osXlSemibold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 24, // xl
    height: 1.5, // xl line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osLgSemibold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 20, // lg
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.15, // lg
  );
  static const TextStyle osMdSemiboldTitle = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 16, // md
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.15, // lg
  );
  static const TextStyle osMdBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 16, // md
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.15, // lg
  );

  // --- Body Styles ---
  static const TextStyle osLg = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // regular
    fontSize: 20, // lg
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osMd = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, 
    // regular
    fontSize: 16, // md
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osMdSemiboldBody = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 16, // md
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osSmSemiboldBody = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 14, // sm
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );

  // --- Label Styles ---
  static const TextStyle osSbBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 12, // sb
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osSbSemibold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 12, // sb
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osSmSingleLine = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 14, // sm
    height: 1.0, // single line
    letterSpacing: 0.0, // base
  );
  static const TextStyle osMdSemiboldLabel = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 16, // md
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osMdSemiboldLink = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 16, // md
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
    decoration: TextDecoration.underline,
  );
  static const TextStyle osSmSemiboldLabel = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 14, // sm
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle osXsSemibold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 10, // xs
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
  static const TextStyle os2XsSemibold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // semibold
    fontSize: 8, // 2xs
    height: 1.2, // sm line height (approximate)
    letterSpacing: 0.0, // base
  );
}
