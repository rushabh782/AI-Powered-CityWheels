// import 'package:flutter/material.dart';
// import 'package:city_wheels/screens/home_page.dart';
// import 'package:city_wheels/screens/vehicle_rental_page.dart';
// import 'package:city_wheels/screens/ai_page.dart';
// import 'package:city_wheels/screens/hotels_page.dart';
// import 'package:city_wheels/screens/recommendations_page.dart';
//
// class BottomBar extends StatefulWidget {
//   const BottomBar({super.key});
//
//   @override
//   _BottomBarState createState() => _BottomBarState();
// }
//
// class _BottomBarState extends State<BottomBar> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = [
//     HomePage(),
//     CarRentalPage(),
//     AIPage(),
//     HotelsPage(),
//     RecommendationsPage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex], // Change the displayed page
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Car Rental'),
//           BottomNavigationBarItem(
//             icon: CircleAvatar(
//               backgroundColor: Colors.blue,
//               child: Icon(Icons.smart_toy, color: Colors.white),
//             ),
//             label: 'AI',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Hotels'),
//           BottomNavigationBarItem(icon: Icon(Icons.recommend), label: 'Recommendations'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped, // Updates the selected index
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }

import 'package:city_wheels/screens/vehicle_rental_page.dart';
import 'package:flutter/material.dart';
import 'package:city_wheels/screens/home_page.dart';
import 'package:city_wheels/screens/ai_page.dart';
import 'package:city_wheels/screens/hotels_page.dart';
import 'package:city_wheels/screens/restaurants_listings.dart'; // Import Restaurant Listings Page

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const VehicleRentalPage(),
    const AIPage(),
    const HotelsPage(),
    // HotelsPage(),
    const RestaurantListingsPage(), // ✅ Added Restaurant Listings Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Vehicle Rental',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.smart_toy, color: Colors.white),
            ),
            label: 'AI',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Hotels'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant), // Added Restaurant Icon
            label: 'Restaurants',
          ), // ✅ Added Restaurant Item
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
