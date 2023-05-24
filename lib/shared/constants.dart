import 'package:flutter/material.dart';

class Constants {
  // klucze
  static String collectApiKey = "2b0yJA0CsgKpRmxkhN5Jqn:1NJNL5yiYqlR0cfSEFKH7Z";
  static String googleApiKey = "AIzaSyD7w6X2U8SffS4vt6CT29ksceUUPzg1tCk";

  static String projectId = "TV-app";

  // UI
  static Color primaryColor = Color.fromRGBO(198, 50, 40, 100);
  static LinearGradient primaryGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.yellowAccent, Colors.orangeAccent, Colors.purple]);
  static EdgeInsets edgeInsets =
      EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0);
}
