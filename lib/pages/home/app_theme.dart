import 'package:flutter/material.dart';

abstract class IAppTheme {
  Color get primaryColor;
  Color get backgroundColor;
  Color get appBarColor;
  Color get buttonColor;
  Color get buttonTextColor;
  Color get bottomNavBarColor;
  Color get unselectedIconColor;
  TextStyle get textStyle; // Define textStyle in the interface
}

class AppTheme implements IAppTheme {
  @override
  Color get primaryColor => Colors.green;

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get appBarColor => Colors.green;

  @override
  Color get buttonColor => Colors.green;

  @override
  Color get buttonTextColor => Colors.white;

  @override
  Color get bottomNavBarColor => Colors.green;

  @override
  Color get unselectedIconColor => Colors.white60;

  @override
  TextStyle get textStyle => const TextStyle(
        fontSize: 16.0,
        color: Color.fromARGB(255, 243, 242, 242),
        fontWeight: FontWeight.normal,
      ); // Define the textStyle getter
}
