// import 'package:flutter/material.dart';
// import 'package:city_wheels/database/firebase_config.dart';
// import 'package:city_wheels/screens/landing_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await FirebaseConfig.initialize(); // Initialize Firebase

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'My App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const LandingPage(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:city_wheels/database/firebase_config.dart';
import 'package:city_wheels/screens/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseConfig.initialize(); // Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'City Wheels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LandingPage(),
    );
  }
}
