import 'package:flutter/material.dart';
import 'package:city_wheels/login/login_page.dart';
import 'package:city_wheels/login/signup_page.dart';
import 'package:city_wheels/widgets/bottom_bar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: const Text("Signup"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomBar()),
                );
              },
              child: const Text("Continue as Guest"),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:city_wheels/login/login_page.dart';
// import 'package:city_wheels/login/signup_page.dart';
// import 'package:city_wheels/widgets/bottom_bar.dart';

// class LandingPage extends StatelessWidget {
//   const LandingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.blue.shade800,
//               Colors.blue.shade600,
//               Colors.blue.shade400,
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Background elements
//             Positioned(
//               top: size.height * 0.1,
//               left: -50,
//               child: Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withOpacity(0.1),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: size.height * 0.15,
//               right: -30,
//               child: Container(
//                 width: 150,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withOpacity(0.1),
//                 ),
//               ),
//             ),

//             // Main content
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Logo and title
//                     SizedBox(height: size.height * 0.1),
//                     Hero(
//                       tag: 'app-logo',
//                       child: Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white,
//                         ),
//                         child: Icon(
//                           Icons.directions_car,
//                           size: 60,
//                           color: Colors.blue.shade800,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'CityWheels',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Your Ultimate City Companion',
//                       style: TextStyle(fontSize: 16, color: Colors.white70),
//                     ),
//                     SizedBox(height: size.height * 0.1),

//                     // Buttons (remain unchanged)
//                     _buildAuthButton(
//                       context,
//                       title: 'Login',
//                       icon: Icons.login,
//                       color: Colors.white,
//                       textColor: Colors.blue.shade800,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation, secondaryAnimation) =>
//                                     const LoginPage(),
//                             transitionsBuilder: (
//                               context,
//                               animation,
//                               secondaryAnimation,
//                               child,
//                             ) {
//                               return FadeTransition(
//                                 opacity: animation,
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     _buildAuthButton(
//                       context,
//                       title: 'Sign Up',
//                       icon: Icons.person_add,
//                       color: Colors.blue.shade900,
//                       textColor: Colors.white,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation, secondaryAnimation) =>
//                                     const SignupPage(),
//                             transitionsBuilder: (
//                               context,
//                               animation,
//                               secondaryAnimation,
//                               child,
//                             ) {
//                               return SlideTransition(
//                                 position: Tween<Offset>(
//                                   begin: const Offset(1, 0),
//                                   end: Offset.zero,
//                                 ).animate(animation),
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const BottomBar(),
//                           ),
//                           (route) => false,
//                         );
//                       },
//                       child: const Text(
//                         'Continue as Guest',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAuthButton(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required Color color,
//     required Color textColor,
//     required VoidCallback onPressed,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 5,
//           shadowColor: Colors.black.withOpacity(0.3),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: textColor),
//             const SizedBox(width: 10),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
