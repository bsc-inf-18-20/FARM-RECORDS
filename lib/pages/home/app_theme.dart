import 'package:flutter/material.dart';

abstract class IAppTheme {
  Color get primaryColor;
  Color get backgroundColor;
  Color get appBarColor;
  Color get buttonColor;
  Color get buttonTextColor;
  Color get bottomNavBarColor;
  Color get unselectedIconColor;
}

class AppTheme implements IAppTheme {
  @override
  Color get primaryColor => Colors.blueAccent;

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get appBarColor => Colors.blueAccent;

  @override
  Color get buttonColor => Color.fromARGB(255, 44, 133, 8);

  @override
  Color get buttonTextColor => Colors.white;

  @override
  Color get bottomNavBarColor => Colors.blueAccent;

  @override
  Color get unselectedIconColor => Colors.white60;
}
