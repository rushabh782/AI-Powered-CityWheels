// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:city_wheels/widgets/bottom_bar.dart';
// // import 'package:city_wheels/vehicle_rental/our_fleet.dart';

// class VehicleRentalPage extends StatefulWidget {
//   const VehicleRentalPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _VehicleRentalPageState createState() => _VehicleRentalPageState();
// }

// Widget _buildGlowingText(
//   String text, {
//   double fontSize = 24.0,
//   FontWeight fontWeight = FontWeight.normal,
//   List<Color> colors = const [Colors.black, Colors.white],
// }) {
//   return RichText(
//     text: TextSpan(
//       style: TextStyle(
//         fontSize: fontSize,
//         fontWeight: fontWeight,
//         shadows:
//             colors.map((color) {
//               return Shadow(
//                 color: color,
//                 offset: Offset(0, 0),
//                 blurRadius: 10.0,
//               );
//             }).toList(),
//       ),
//       children: [TextSpan(text: text, style: TextStyle(color: colors.first))],
//     ),
//   );
// }

// class _VehicleRentalPageState extends State<VehicleRentalPage> {
//   Timer? _timer;
//   final List<String> changingTexts = ['Faster', 'Safer', 'Affordable'];
//   int textIndex = 0;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> vehicles = [];

//   @override
//   void initState() {
//     super.initState();

//     _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
//       if (mounted) {
//         setState(() {
//           textIndex = (textIndex + 1) % changingTexts.length;
//         });
//       } else {
//         timer.cancel();
//       }
//     });

//     // Fetch vehicles from Firestore
//     fetchVehicles();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // ✅ Dispose of the Timer to prevent memory leaks
//     super.dispose();
//   }

//   Future<void> fetchVehicles() async {
//     try {
//       QuerySnapshot snapshot =
//           await firestore.collection('vehicles').limit(15).get();

//       if (!mounted) return;

//       setState(() {
//         vehicles =
//             snapshot.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;

//               return {
//                 'id': doc.id,
//                 'type': data['type'] ?? 'Unknown',
//                 'imageUrl': data['imageUrl'] ?? '',
//                 'pricePerHour':
//                     (data['pricePerHour'] is num)
//                         ? (data['pricePerHour'] as num).toDouble()
//                         : 0.0,
//                 'name': data['name'],
//                 'ratings':
//                     (data['Ratings'] is num)
//                         ? (data['Ratings'] as num).toDouble()
//                         : 4.0,
//               };
//             }).toList();
//       });
//     } catch (e) {
//       print('Error fetching vehicles: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vehicle Rentals'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.9,
//               child: Image.asset(
//                 'assets/images/car_vr_intro.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           SingleChildScrollView(
//             // <-- Added to prevent overflow
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Search for vehicles...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.all(85.0),
//                   // child: Text('Our Fleet', style: Theme.of(context).textTheme.titleLarge),
//                 ),

//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildGlowingText(
//                         'Rent the vehicles of your dreams',
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         colors: [
//                           Colors.white,
//                           Colors.red,
//                         ], // Black glow, Gold text
//                       ),
//                       const SizedBox(height: 8),
//                       _buildGlowingText(
//                         changingTexts[textIndex],
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         colors: [
//                           Colors.white,
//                           Colors.blue,
//                         ], // Black glow, Blue text
//                       ),
//                     ],
//                   ),
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.all(47.0),
//                   // child: Text('Our Fleet', style: Theme.of(context).textTheme.titleLarge),
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment:
//                         MainAxisAlignment
//                             .spaceBetween, // Ensure space between text and icon
//                     children: [
//                       // Glowing Text
//                       _buildGlowingText(
//                         'Our Fleet',
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         colors: [
//                           Colors.blue,
//                           Colors.black,
//                         ], // Blue text with black glow
//                       ),

//                       // Navigation Icon
//                       // GestureDetector(
//                       //   onTap: () {
//                       //     Navigator.push(
//                       //       context,
//                       //       MaterialPageRoute(
//                       //         builder: (context) => OurFleetPage(),
//                       //       ),
//                       //     );
//                       //   },
//                         child: Icon(
//                           Icons.arrow_forward, // Arrow icon
//                           size: 30,
//                           color: Colors.blue, // Match "Our Fleet" text color
//                           shadows: const [
//                             Shadow(
//                               blurRadius: 10, // Glow effect
//                               color: Colors.black, // Black shadow
//                               offset: Offset(0, 0),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 if (vehicles.isNotEmpty)
//                   SizedBox(
//                     height: 200,
//                     child: CarouselSlider.builder(
//                       options: CarouselOptions(
//                         height: 200,
//                         enlargeCenterPage: true,
//                         viewportFraction: 0.85,
//                         scrollPhysics: const BouncingScrollPhysics(),
//                       ),
//                       itemCount: vehicles.length,
//                       itemBuilder: (context, index, realIndex) {
//                         // print("Building VehicleCard for index: $index");
//                         // print("Vehicle Details - Type: ${vehicles[index]['type']}, "
//                         //     "Image URL: ${vehicles[index]['imageUrl']}, "
//                         //     "Price Per Day: ${vehicles[index]['pricePerDay']}, "
//                         //     "Vehicle ID: ${vehicles[index]['id']}, "
//                         //     "Name: ${vehicles[index]['name']}, "
//                         //     "Ratings: ${vehicles[index]['ratings']}");
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: VehicleCard(
//                             type: vehicles[index]['type'],
//                             imageUrl: vehicles[index]['imageUrl'],
//                             pricePerHour:
//                                 vehicles[index]['pricePerHour'].toDouble(),
//                             vehicleId: vehicles[index]['id'],
//                             name: vehicles[index]['name'],
//                             ratings: vehicles[index]['ratings'],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//vehicle_rental_page.dart
// import 'dart:async';
// import 'package:city_wheels/vehicle_rental/vehicle_card.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// // import 'package:city_wheels/widgets/bottom_bar.dart';
// // import 'package:city_wheels/vehicle_rental/our_fleet.dart';

// class VehicleRentalPage extends StatefulWidget {
//   const VehicleRentalPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _VehicleRentalPageState createState() => _VehicleRentalPageState();
// }

// Widget _buildGlowingText(
//   String text, {
//   double fontSize = 24.0,
//   FontWeight fontWeight = FontWeight.normal,
//   List<Color> colors = const [Colors.black, Colors.white],
// }) {
//   return RichText(
//     text: TextSpan(
//       style: TextStyle(
//         fontSize: fontSize,
//         fontWeight: fontWeight,
//         shadows:
//             colors.map((color) {
//               return Shadow(
//                 color: color,
//                 offset: const Offset(0, 0),
//                 blurRadius: 10.0,
//               );
//             }).toList(),
//       ),
//       children: [TextSpan(text: text, style: TextStyle(color: colors.first))],
//     ),
//   );
// }

// class _VehicleRentalPageState extends State<VehicleRentalPage> {
//   Timer? _timer;
//   final List<String> changingTexts = ['Faster', 'Safer', 'Affordable'];
//   int textIndex = 0;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> vehicles = [];

//   @override
//   void initState() {
//     super.initState();

//     _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
//       if (mounted) {
//         setState(() {
//           textIndex = (textIndex + 1) % changingTexts.length;
//         });
//       } else {
//         timer.cancel();
//       }
//     });

//     // Fetch vehicles from Firestore
//     fetchVehicles();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // ✅ Dispose of the Timer to prevent memory leaks
//     super.dispose();
//   }

//   Future<void> fetchVehicles() async {
//     try {
//       QuerySnapshot snapshot =
//           await firestore.collection('vehicles').limit(15).get();

//       if (!mounted) return;

//       setState(() {
//         vehicles =
//             snapshot.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;

//               return {
//                 'id': doc.id,
//                 'type': data['type'] ?? 'Unknown',
//                 'imageUrl': data['imageUrl'] ?? '',
//                 'pricePerHour':
//                     (data['pricePerHour'] is num)
//                         ? (data['pricePerHour'] as num).toDouble()
//                         : 0.0,
//                 'name': data['name'],
//                 'ratings':
//                     (data['Ratings'] is num)
//                         ? (data['Ratings'] as num).toDouble()
//                         : 4.0,
//               };
//             }).toList();
//       });
//     } catch (e) {
//       print('Error fetching vehicles: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vehicle Rentals'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.9,
//               child: Image.asset(
//                 'assets/images/car_vr_intro.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Search for vehicles...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Padding(padding: const EdgeInsets.all(85.0)),
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildGlowingText(
//                         'Rent the vehicles of your dreams',
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         colors: [Colors.white, Colors.red],
//                       ),
//                       const SizedBox(height: 8),
//                       _buildGlowingText(
//                         changingTexts[textIndex],
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         colors: [Colors.white, Colors.blue],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(padding: const EdgeInsets.all(47.0)),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildGlowingText(
//                         'Our Fleet',
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         colors: [Colors.blue, Colors.black],
//                       ),
//                       Icon(
//                         Icons.arrow_forward,
//                         size: 30,
//                         color: Colors.blue,
//                         shadows: const [
//                           Shadow(
//                             blurRadius: 10,
//                             color: Colors.black,
//                             offset: Offset(0, 0),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (vehicles.isNotEmpty)
//                   SizedBox(
//                     height: 200,
//                     child: CarouselSlider.builder(
//                       options: CarouselOptions(
//                         height: 200,
//                         enlargeCenterPage: true,
//                         viewportFraction: 0.85,
//                         scrollPhysics: const BouncingScrollPhysics(),
//                       ),
//                       itemCount: vehicles.length,
//                       itemBuilder: (context, index, realIndex) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: VehicleCard(
//                             type: vehicles[index]['type'],
//                             imageUrl: vehicles[index]['imageUrl'],
//                             pricePerHour:
//                                 vehicles[index]['pricePerHour'].toDouble(),
//                             vehicleId: vehicles[index]['id'],
//                             name: vehicles[index]['name'],
//                             ratings: vehicles[index]['ratings'],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:city_wheels/vehicle_rental/vehicle_card.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class VehicleRentalPage extends StatefulWidget {
//   const VehicleRentalPage({super.key});

//   @override
//   _VehicleRentalPageState createState() => _VehicleRentalPageState();
// }

// Widget _buildGlowingText(
//   String text, {
//   double fontSize = 24.0,
//   FontWeight fontWeight = FontWeight.normal,
//   List<Color> colors = const [Colors.black, Colors.white],
// }) {
//   return RichText(
//     text: TextSpan(
//       style: TextStyle(
//         fontSize: fontSize,
//         fontWeight: fontWeight,
//         shadows:
//             colors
//                 .map(
//                   (color) => Shadow(
//                     color: color,
//                     offset: const Offset(0, 0),
//                     blurRadius: 10.0,
//                   ),
//                 )
//                 .toList(),
//       ),
//       children: [TextSpan(text: text, style: TextStyle(color: colors.first))],
//     ),
//   );
// }

// class _VehicleRentalPageState extends State<VehicleRentalPage> {
//   Timer? _timer;
//   final List<String> changingTexts = ['Faster', 'Safer', 'Affordable'];
//   int textIndex = 0;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> vehicles = [];
//   List<Map<String, dynamic>> filteredVehicles = [];
//   TextEditingController searchController = TextEditingController();
//   bool isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
//       if (mounted) {
//         setState(() {
//           textIndex = (textIndex + 1) % changingTexts.length;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//     fetchVehicles();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     searchController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchVehicles() async {
//     try {
//       QuerySnapshot snapshot =
//           await firestore.collection('vehicles').limit(15).get();

//       if (!mounted) return;

//       setState(() {
//         vehicles =
//             snapshot.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               return {
//                 'id': doc.id,
//                 'type': data['type'] ?? 'Unknown',
//                 'imageUrl': data['imageUrl'] ?? '',
//                 'pricePerHour':
//                     (data['pricePerHour'] is num)
//                         ? (data['pricePerHour'] as num).toDouble()
//                         : 0.0,
//                 'name': data['name'],
//                 'ratings':
//                     (data['Ratings'] is num)
//                         ? (data['Ratings'] as num).toDouble()
//                         : 4.0,
//               };
//             }).toList();
//         filteredVehicles = List.from(vehicles);
//       });
//     } catch (e) {
//       print('Error fetching vehicles: $e');
//     }
//   }

//   void filterVehicles(String query) {
//     setState(() {
//       isSearching = query.isNotEmpty;
//       filteredVehicles =
//           vehicles
//               .where(
//                 (vehicle) =>
//                     vehicle['name'].toLowerCase().contains(
//                       query.toLowerCase(),
//                     ) ||
//                     vehicle['type'].toLowerCase().contains(query.toLowerCase()),
//               )
//               .toList();
//     });
//   }

//   void clearSearch() {
//     setState(() {
//       searchController.clear();
//       isSearching = false;
//       filteredVehicles = List.from(vehicles);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vehicle Rentals'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.9,
//               child: Image.asset(
//                 'assets/images/car_vr_intro.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     controller: searchController,
//                     onChanged: filterVehicles,
//                     decoration: InputDecoration(
//                       hintText: 'Search for vehicles...',
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon:
//                           isSearching
//                               ? IconButton(
//                                 icon: const Icon(Icons.clear),
//                                 onPressed: clearSearch,
//                               )
//                               : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 85),
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildGlowingText(
//                         'Rent the vehicles of your dreams',
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         colors: [Colors.white, Colors.red],
//                       ),
//                       const SizedBox(height: 8),
//                       _buildGlowingText(
//                         changingTexts[textIndex],
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         colors: [Colors.white, Colors.blue],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 47),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildGlowingText(
//                         isSearching ? 'Search Results' : 'Our Fleet',
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         colors: [Colors.blue, Colors.black],
//                       ),
//                       if (!isSearching)
//                         Icon(
//                           Icons.arrow_forward,
//                           size: 30,
//                           color: Colors.blue,
//                           shadows: const [
//                             Shadow(
//                               blurRadius: 10,
//                               color: Colors.black,
//                               offset: Offset(0, 0),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//                 if (filteredVehicles.isEmpty && isSearching)
//                   const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Center(
//                       child: Text(
//                         'No vehicles found matching your search',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   )
//                 else if (filteredVehicles.isNotEmpty)
//                   SizedBox(
//                     height: 200,
//                     child: CarouselSlider.builder(
//                       options: CarouselOptions(
//                         height: 200,
//                         enlargeCenterPage: true,
//                         viewportFraction: 0.85,
//                         scrollPhysics: const BouncingScrollPhysics(),
//                       ),
//                       itemCount: filteredVehicles.length,
//                       itemBuilder: (context, index, realIndex) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: VehicleCard(
//                             type: filteredVehicles[index]['type'],
//                             imageUrl: filteredVehicles[index]['imageUrl'],
//                             pricePerHour:
//                                 filteredVehicles[index]['pricePerHour']
//                                     .toDouble(),
//                             vehicleId: filteredVehicles[index]['id'],
//                             name: filteredVehicles[index]['name'],
//                             ratings: filteredVehicles[index]['ratings'],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:city_wheels/vehicle_rental/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VehicleRentalPage extends StatefulWidget {
  const VehicleRentalPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VehicleRentalPageState createState() => _VehicleRentalPageState();
}

Widget _buildGlowingText(
  String text, {
  double fontSize = 24.0,
  FontWeight fontWeight = FontWeight.normal,
  List<Color> colors = const [Colors.black, Colors.white],
}) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows:
            colors
                .map(
                  (color) => Shadow(
                    color: color,
                    offset: const Offset(0, 0),
                    blurRadius: 10.0,
                  ),
                )
                .toList(),
      ),
      children: [TextSpan(text: text, style: TextStyle(color: colors.first))],
    ),
  );
}

class _VehicleRentalPageState extends State<VehicleRentalPage> {
  Timer? _timer;
  final List<String> changingTexts = ['Faster', 'Safer', 'Affordable'];
  int textIndex = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> vehicles = [];
  List<Map<String, dynamic>> filteredVehicles = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (mounted) {
        setState(() {
          textIndex = (textIndex + 1) % changingTexts.length;
        });
      } else {
        timer.cancel();
      }
    });
    fetchVehicles();
  }

  @override
  void dispose() {
    _timer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchVehicles() async {
    try {
      QuerySnapshot snapshot =
          await firestore.collection('vehicles').limit(15).get();

      if (!mounted) return;

      setState(() {
        vehicles =
            snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                'type': data['type'] ?? 'Unknown',
                'imageUrl': data['imageUrl'] ?? '',
                'pricePerHour':
                    (data['pricePerHour'] is num)
                        ? (data['pricePerHour'] as num).toDouble()
                        : 0.0,
                'name': data['name'],
                'ratings':
                    (data['Ratings'] is num)
                        ? (data['Ratings'] as num).toDouble()
                        : 4.0,
              };
            }).toList();
        filteredVehicles = List.from(vehicles);
      });
    } catch (e) {
      debugPrint('Error fetching vehicles: $e');
    }
  }

  void filterVehicles(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      filteredVehicles =
          vehicles
              .where(
                (vehicle) =>
                    vehicle['name'].toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    vehicle['type'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
      isSearching = false;
      filteredVehicles = List.from(vehicles);
    });
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredVehicles.length,
      itemBuilder: (context, index) {
        return VehicleCard(
          type: filteredVehicles[index]['type'],
          imageUrl: filteredVehicles[index]['imageUrl'],
          pricePerHour: filteredVehicles[index]['pricePerHour'].toDouble(),
          vehicleId: filteredVehicles[index]['id'],
          name: filteredVehicles[index]['name'],
          ratings: filteredVehicles[index]['ratings'],
        );
      },
    );
  }

  Widget _buildFleetCarousel() {
    return SizedBox(
      height: 200,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 200,
          enlargeCenterPage: true,
          viewportFraction: 0.85,
          scrollPhysics: const BouncingScrollPhysics(),
        ),
        itemCount: filteredVehicles.length,
        itemBuilder: (context, index, realIndex) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: VehicleCard(
              type: filteredVehicles[index]['type'],
              imageUrl: filteredVehicles[index]['imageUrl'],
              pricePerHour: filteredVehicles[index]['pricePerHour'].toDouble(),
              vehicleId: filteredVehicles[index]['id'],
              name: filteredVehicles[index]['name'],
              ratings: filteredVehicles[index]['ratings'],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Rentals'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/car_vr_intro.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterVehicles,
                    decoration: InputDecoration(
                      hintText: 'Search for vehicles...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          isSearching
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: clearSearch,
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 85),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildGlowingText(
                        'Rent the vehicles of your dreams',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        colors: [Colors.white, Colors.red],
                      ),
                      const SizedBox(height: 8),
                      _buildGlowingText(
                        changingTexts[textIndex],
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        colors: [Colors.white, Colors.blue],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 47),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlowingText(
                        isSearching ? 'Search Results' : 'Our Fleet',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        colors: [Colors.blue, Colors.black],
                      ),
                      if (!isSearching)
                        Icon(
                          Icons.arrow_forward,
                          size: 30,
                          color: Colors.blue,
                          shadows: const [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (filteredVehicles.isEmpty && isSearching)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No vehicles found matching your search',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else if (isSearching)
                  _buildSearchResults()
                else
                  _buildFleetCarousel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
