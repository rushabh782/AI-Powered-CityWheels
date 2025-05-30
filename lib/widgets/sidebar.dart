// import 'package:flutter/material.dart';
// import '../screens/hotels_page.dart';
// import '../screens/vehicle_rental_page.dart';
// import '../screens/landing_page.dart';

// class Sidebar extends StatelessWidget {
//   const Sidebar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           // Sidebar Header
//           Container(
//             color: Colors.blue,
//             padding: const EdgeInsets.only(
//               top: 40,
//               left: 16,
//               right: 16,
//               bottom: 20,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Back button aligned to left
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LandingPage(),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 // Centered Title & Subtitle
//                 Column(
//                   children: const [
//                     Text(
//                       'CityWheels',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       'Explore, Rent, and Stay',
//                       style: TextStyle(color: Colors.white70, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.hotel, color: Colors.blue),
//                   title: const Text('Hotel Booking'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const HotelsPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.car_rental, color: Colors.blue),
//                   title: const Text('Vehicle Rental'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const VehicleRentalPage(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:city_wheels/screens/ai_page.dart';
// import 'package:city_wheels/screens/restaurants_listings.dart';
// import 'package:city_wheels/screens/vehicle_rental_page.dart';
// import 'package:flutter/material.dart';
// import '../screens/hotels_page.dart';
// import '../screens/landing_page.dart';
// import '../screens/recommendations_page.dart'; // Import Recommendations Page

// class Sidebar extends StatelessWidget {
//   const Sidebar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           // Sidebar Header (Compact)
//           Container(
//             color: Colors.blue,
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//             child: Row(
//               children: [
//                 // Back Button
//                 IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                     size: 28,
//                   ),
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LandingPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 10),
//                 // Sidebar Title
//                 const Text(
//                   'CityWheels',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.hotel, color: Colors.blue),
//                   title: const Text('Hotel Booking'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const HotelsPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.recommend, color: Colors.blue),
//                   title: const Text('Recommendations'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const RecommendationsPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 // Vehicle Rentals
//                 ListTile(
//                   leading: const Icon(Icons.directions_car, color: Colors.blue),
//                   title: const Text('Vehicle Rentals'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const VehicleRentalPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 // Restaurant Table Booking
//                 ListTile(
//                   leading: const Icon(Icons.restaurant, color: Colors.blue),
//                   title: const Text('Restaurant Table Booking'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const RestaurantListingsPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 // AI Chatbot
//                 ListTile(
//                   leading: const Icon(Icons.chat_bubble, color: Colors.blue),
//                   title: const Text('AI Chatbot'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const AIPage()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:city_wheels/screens/ai_page.dart';
import 'package:city_wheels/screens/all_bookings_page.dart'; // Import the new page
import 'package:city_wheels/screens/restaurants_listings.dart';
import 'package:city_wheels/screens/vehicle_rental_page.dart';
import 'package:flutter/material.dart';
import '../screens/hotels_page.dart';
import '../screens/landing_page.dart';
import '../screens/recommendations_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Sidebar Header (Compact)
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                // Back Button
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LandingPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                // Sidebar Title
                const Text(
                  'CityWheels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.hotel, color: Colors.blue),
                  title: const Text('Hotel Booking'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HotelsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.recommend, color: Colors.blue),
                  title: const Text('Recommendations'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecommendationsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.directions_car, color: Colors.blue),
                  title: const Text('Vehicle Rentals'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VehicleRentalPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant, color: Colors.blue),
                  title: const Text('Restaurant Table Booking'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RestaurantListingsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_bubble, color: Colors.blue),
                  title: const Text('AI Chatbot'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AIPage()),
                    );
                  },
                ),
                // Add new All Bookings option
                ListTile(
                  leading: const Icon(Icons.book_online, color: Colors.blue),
                  title: const Text('My Bookings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllBookingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
