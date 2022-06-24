import 'package:flutter/material.dart';

class Constants {
  static final primaryColor = Colors.grey;
  static final secondaryColor = Color(0xff112665);
  static final lightGrey = Color(0xff848A9C);
  static final iconColor = Color(0xff0C1A32).withOpacity(0.4);
  static final black = Colors.black;

  static Widget loader() => Center(
          child: CircularProgressIndicator(
        backgroundColor: Constants.secondaryColor,
        color: Constants.primaryColor,
      ));

  // static Future<SharedPreferences> init() async {
  //   prefs = await _instance;
  //   return prefs;
  // }
}
