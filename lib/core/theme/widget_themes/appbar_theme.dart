import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../theme_service.dart';

class TAppBarTheme{
  TAppBarTheme._();

  static AppBarTheme get lightAppBarTheme => AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: ColorConstant.black, size: Sizes.iconMd),
    actionsIconTheme: const IconThemeData(color: ColorConstant.black, size: Sizes.iconMd),
    titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: ColorConstant.black),
    systemOverlayStyle: getSystemUIOverlayStyle(ThemeMode.light),
  );
  static AppBarTheme get darkAppBarTheme => AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: ColorConstant.white, size: Sizes.iconMd),
    actionsIconTheme: const IconThemeData(color: ColorConstant.white, size: Sizes.iconMd),
    titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: ColorConstant.white),
    systemOverlayStyle: getSystemUIOverlayStyle(ThemeMode.dark),
  );
}