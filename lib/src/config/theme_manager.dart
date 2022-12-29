import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_size.dart';
import '../core/utils/font_manager.dart';
import '../core/utils/styles_manager.dart';

void setLightStatusBarIcons() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

void setDarkStatusBarIcons() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

ThemeData getAppTheme() {
  setLightStatusBarIcons();

  return ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: Color.fromARGB(255, 105, 105, 105),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 105, 105, 105),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 105, 105, 105),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0.0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    textTheme: TextTheme(
      headlineLarge:
          getBlackStyle(fontSize: FontSize.title, color: AppColors.white),
      headlineMedium:
          getBoldStyle(fontSize: FontSize.subTitle, color: AppColors.white),
      titleLarge: getBoldStyle(color: AppColors.white),
      // titleMedium Used in text form field
      titleMedium: getRegularStyle(color: AppColors.black),
      bodyLarge: getMediumStyle(color: AppColors.black),
      bodyMedium: getRegularStyle(color: AppColors.black),
      bodySmall: getLightStyle(color: AppColors.blackWithOpacity),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(color: AppColors.white),
        backgroundColor: Color.fromARGB(255, 105, 105, 105),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s5),
        ),
        elevation: 0.0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: getRegularStyle(color: AppColors.blackWithOpacity),
      hintStyle: getRegularStyle(color: AppColors.blackWithOpacity),
      errorStyle: getLightStyle(color: AppColors.error),
      fillColor: AppColors.light,
      filled: true,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: AppSize.s1_5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black, width: AppSize.s1_5),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: AppSize.s1_5),
      ),
      enabledBorder: InputBorder.none,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color.fromARGB(255, 105, 105, 105)),
  );
}
