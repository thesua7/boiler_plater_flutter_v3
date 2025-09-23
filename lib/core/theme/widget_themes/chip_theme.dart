import 'package:flutter/material.dart';
import '../../constants/colors.dart';


class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: ColorConstant.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: ColorConstant.black),
    selectedColor: ColorConstant.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: ColorConstant.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: ColorConstant.darkerGrey,
    labelStyle: TextStyle(color: ColorConstant.white),
    selectedColor: ColorConstant.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: ColorConstant.white,
  );
}
