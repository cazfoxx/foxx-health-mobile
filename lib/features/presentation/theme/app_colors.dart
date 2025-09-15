import 'package:flutter/material.dart';

class AppColors {
  // Primary color
  static const lightViolet = Color(0xffCEA2FD);
  static const background = Color(0xffF1EFF7);
  static const backgroundDefault = Color(0xffFEEFF1);
  static const disabledButton = Color(0xffCECECF);

  static const amethystViolet = Color(0xff805EC9);
  static const blue = Color(0xff007AFF);

  static const optionBG = Color(0xffF1EFF7);
  static const foxxwhite = Color(0xffFFFCFC);






  // Brand Colors
  static const davysGray = Color(0xFF5E5C6C); 
  static const amethyst = Color(0xFF805EC9);
  static const amethyst50 = Color(0xFFF1EFF7);
  static const mauve = Color(0xFFCEA2FD); 
  static const mauve50 = Color(0xFFDEBFFF);
  static const flax = Color(0xFFFEEE99);
  static const sunglow = Color(0xFFFFCA4B); 
  static const foxxWhite = Color(0xFFFFFCFC); 

  // Gray Colors
  static const gray900 = Color(0xFF3E3D4B);
  static const gray800 = Color(0xFF5E5C6C); 
  static const gray700 = Color(0xFF67646C);
  static const gray600 = Color(0xFF99989F);
  static const gray400 = Color(0xFFCECECF); 
  static const gray300 = Color(0xFFD9D9D9);
  static const gray200 = Color(0xFFEFEFF0);
  static const gray100 = Color(0xFFFFFCFC); // Same as foxxWhite
  static const grayWhite = Color(0xFFFFFFFF);

  // Level Colors
  static const darkRed = Color(0xFFBF0F0F);
  static const red = Color(0xFFEB3C3C);
  static const orange = Color(0xFFE7931D);
  static const yellow = Color(0xFFFFCD04);

  // Semantic Colors (from Figma)

  static const primary01 = gray900;
  static const inputFieldDisabled = gray400;
  static const border01 = gray400;
  static const border02 = gray100;
  static const surface01 = grayWhite;
  static const surface02 = foxxWhite;
  static const surface03 = gray100;
  static const primaryTint = amethyst;
  static const primaryTint50 = amethyst50;
  static const programBase = flax;
  static const programBaseSolid = sunglow;
  static const backgroundHighlight = mauve;

  // Figma color tokens
  static const Color primaryTxt = Color(0xff3E3D48); // primary-txt
  static const Color inputTxtPlaceholder = gray600; // input-txt-placeholder
  static const Color secondaryTxt = gray700; // 2ndary-txt
  static const Color brandTxt = amethyst; // brand-txt
  static const Color primaryBtnTxt = foxxWhite; // primary-btn-txt
  static const Color secondaryBtnTxt = amethyst; // 2ndary-btn-txt
  static const Color tertiaryBtnTxt = gray700; // tertiary-btn-txt
  static const Color progressBarBase = grayWhite; // progress-bar-base
  static const Color progressBarSelected = sunglow; // progress-bar-selected
  static const Color backgroundHighlighted = mauve; // background-highlighted

  // Surface
  static const crossGlassBase = grayWhite;
  static const crossGlassSelected = foxxWhite;
  static const sandRadioBase = gray200;
  static const sandRadioSelected = flax;
  static const sandRadioHover = gray100;
  static const overlay = Color(0x33000000); // 20% black
  static const overlaySoft = Color(0x1A000000); // 10% black
  static const overlayLight = Color(0x0D000000); // 5% black

  // Kits
  static const kitLevel0 = gray400;
  static const kitLevel1 = yellow;
  static const kitLevel2 = sunglow;
  static const kitLevel3 = orange;
  static const kitLevel4 = red;
  static const kitPrimaryEnabled = mauve;
  static const kitDisabled = gray400;
  static const kitTertiaryBase = gray100;
  static const kitTertiarySolidSelected = grayWhite;
  static const kitLogoDefault = amethyst50;
  static const kitLogoDefaultSolid = amethyst;
  static const kitStrokeAlert = red;

  // Input Fields
  static const inputBg = red; 
  static const inputBgPrimary = grayWhite;
  static const inputBgActive = red; 
  static const inputField = gray400;
  static const inputOutline = red; 
  static const inputOutlineSelected = amethyst;

  // Icon
  static const iconPrimaryEnabled = amethyst;
  static const iconPrimaryDisabled = mauve;
  static const iconSecondaryEnabled = gray400;

  /// Primary background gradient using brand Mauve and Sunglow
  static  LinearGradient primaryBackgroundGradient = LinearGradient(
    begin: Alignment(1.01, 0.99),
    end: Alignment(0.21, -0.13),
    colors: [
       // color-brand-Mauve
      AppColors.mauve.withOpacity(0.45),
      AppColors.sunglow.withOpacity(0.45), // color-brand-Sunglow
    ],
  );

  /// Glass card treatment for home cards 
  // static final BoxDecoration glassCardDecoration = BoxDecoration(
  //   color: AppColors.crossGlassBase.withOpacity(0.28),
  //   borderRadius: BorderRadius.circular(20),
  //   border: Border.all(
  //     color: AppColors.gray200.withOpacity(0.9),
  //     width: 1.2,
  //   ),

  //   boxShadow: [
  //     BoxShadow(
  //       color: AppColors.gray400.withOpacity(0.08),
  //       blurRadius: 12,
  //       offset: Offset(0, 2),
  //     ),
  //   ],
  // );

  /// Inner shadow decoration for glass cards
  static final BoxDecoration glassCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white.withOpacity(0.28),

  );
   static final BoxDecoration glassCardDecoration2 = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white.withOpacity(0.48),

  );

  static LinearGradient gradient45 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFE6B2).withOpacity(0.45),
      Color(0xFFE6D6FF).withOpacity(0.45),
    ],
  );
}
