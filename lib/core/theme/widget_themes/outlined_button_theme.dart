import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class TOutlinedButtonTheme {
  TOutlinedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: ColorConstant.dark,
      side: const BorderSide(color: ColorConstant.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: ColorConstant.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ColorConstant.light,
      side: const BorderSide(color: ColorConstant.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: ColorConstant.textWhite, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
    ),
  );
}
