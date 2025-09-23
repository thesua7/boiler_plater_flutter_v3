import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: ColorConstant.light,
      backgroundColor: ColorConstant.primary,
      disabledForegroundColor: ColorConstant.darkGrey,
      disabledBackgroundColor: ColorConstant.buttonDisabled,
      side: const BorderSide(color: ColorConstant.primary),
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: ColorConstant.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: ColorConstant.light,
      backgroundColor: ColorConstant.primary,
      disabledForegroundColor: ColorConstant.darkGrey,
      disabledBackgroundColor: ColorConstant.darkerGrey,
      side: const BorderSide(color: ColorConstant.primary),
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: ColorConstant.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
    ),
  );
}
