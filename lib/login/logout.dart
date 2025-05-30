import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_wheels/screens/landing_page.dart';

Future<void> logout(BuildContext context) async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Remove saved email
  // await prefs.remove('email');

  // Navigate to LandingPage and clear navigation stack
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LandingPage()),
    (Route<dynamic> route) => false,
  );
}
