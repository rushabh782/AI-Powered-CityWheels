// // restaurants/booking_confirmation_page.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class BookingConfirmationPage extends StatelessWidget {
//   final String restaurantId;
//   final DateTime date;
//   final TimeOfDay time;
//   final int guests;
//   final String mealType;
//   final double coverCharge;

//   const BookingConfirmationPage({
//     super.key,
//     required this.restaurantId,
//     required this.date,
//     required this.time,
//     required this.guests,
//     required this.mealType,
//     required this.coverCharge,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Booking Confirmed'),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 80),
//               const SizedBox(height: 24),
//               const Text(
//                 'Booking Confirmed!',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 32),
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Restaurant ID: $restaurantId',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Date: ${DateFormat('EEE, MMM d').format(date)}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Time: ${time.format(context)}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Guests: $guests',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Meal Type: $mealType',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Cover Charge: ₹${coverCharge.toStringAsFixed(0)}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.popUntil(context, (route) => route.isFirst);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 16,
//                   ),
//                 ),
//                 child: const Text(
//                   'Back to Home',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// restaurants/booking_confirmation_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:city_wheels/screens/landing_page.dart'; // Import the LandingPage

class BookingConfirmationPage extends StatelessWidget {
  final String restaurantId;
  final DateTime date;
  final TimeOfDay time;
  final int guests;
  final String mealType;
  final double coverCharge;

  const BookingConfirmationPage({
    super.key,
    required this.restaurantId,
    required this.date,
    required this.time,
    required this.guests,
    required this.mealType,
    required this.coverCharge,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Restaurant ID: $restaurantId',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${DateFormat('EEE, MMM d').format(date)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Time: ${time.format(context)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Guests: $guests',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Meal Type: $mealType',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cover Charge: ₹${coverCharge.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Navigate to LandingPage and remove all previous routes
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingPage(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
