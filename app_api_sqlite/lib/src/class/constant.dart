import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constant {
  static const String logout = 'Cerrar sesión';
  static const IconData iconLogout = Icons.exit_to_app;
  static const int delayTime = 2000;

  static const String basePoint =
      'http://ec2-3-128-165-162.us-east-2.compute.amazonaws.com/tuti-handheld/api/v1';

  static const int beforeTransition = 155;
  static const int durationTransition = 300;

  static const Color primaryColor = Colors.white;
  static const Color secondaryColor = Colors.black87;
  static const Color backgroundColor = Colors.white;

  static const accentColor = Color.fromRGBO(15, 14, 159, 1);
  static const accentColorAlt = Color.fromRGBO(255, 241, 0, 1);

  static const lightTheme = SystemUiOverlayStyle(
      systemNavigationBarColor: primaryColor,
      systemNavigationBarIconBrightness: Brightness.dark);

  static const darkTheme = SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light);

  static const List<Map<String, dynamic>> choices = [
    {'text': logout, 'icon': iconLogout}
  ];
}
