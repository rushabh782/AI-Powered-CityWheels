// import 'package:flutter/material.dart';

// class AllBookingsPage extends StatefulWidget {
//   const AllBookingsPage({super.key});

//   @override
//   State<AllBookingsPage> createState() => _AllBookingsPageState();
// }

// class _AllBookingsPageState extends State<AllBookingsPage> {
//   int _selectedSection =
//       0; // 0: none selected, 1: vehicle, 2: hotel, 3: restaurant

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('My Bookings'), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildSectionCard(
//                 context,
//                 number: 1,
//                 title: "Vehicle",
//                 isSelected: _selectedSection == 1,
//                 onTap: () => setState(() => _selectedSection = 1),
//               ),
//               const SizedBox(width: 12),
//               _buildSectionCard(
//                 context,
//                 number: 2,
//                 title: "Hotel",
//                 isSelected: _selectedSection == 2,
//                 onTap: () => setState(() => _selectedSection = 2),
//               ),
//               const SizedBox(width: 12),
//               _buildSectionCard(
//                 context,
//                 number: 3,
//                 title: "Restaurant",
//                 isSelected: _selectedSection == 3,
//                 onTap: () => setState(() => _selectedSection = 3),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionCard(
//     BuildContext context, {
//     required int number,
//     required String title,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.28, // 28% of screen width
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.shade700 : Colors.black,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 24,
//               height: 24,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   number.toString(),
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // lib/screens/all_bookings_page.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../widgets/vehicle_booking_card.dart';

// class AllBookingsPage extends StatefulWidget {
//   const AllBookingsPage({super.key});

//   @override
//   State<AllBookingsPage> createState() => _AllBookingsPageState();
// }

// class _AllBookingsPageState extends State<AllBookingsPage> {
//   int _selectedSection = 0;
//   final String email = "nadarnikson@gmail.com"; // Hardcoded email
//   List<Map<String, dynamic>> vehicleBookings = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchVehicleBookings();
//   }

//   // Future<void> _fetchVehicleBookings() async {
//   //   setState(() => isLoading = true);
//   //   try {
//   //     // First get all bookings matching the email
//   //     final bookingsQuery =
//   //         await FirebaseFirestore.instance
//   //             .collection('vehicle_bookings')
//   //             .where('userEmail', isEqualTo: email)
//   //             .get();

//   //     // Process all bookings in parallel
//   //     final bookings = await Future.wait(
//   //       bookingsQuery.docs.map((doc) async {
//   //         final bookingData = doc.data();
//   //         final vehicleId = bookingData['vehicleId'];

//   //         // Get vehicle details for each booking
//   //         final vehicleDoc =
//   //             await FirebaseFirestore.instance
//   //                 .collection('vehicles')
//   //                 .doc(vehicleId)
//   //                 .get();

//   //         return {
//   //           ...bookingData,
//   //           'id': doc.id,
//   //           'vehicleName': vehicleDoc['model'] ?? 'Unknown Vehicle',
//   //           'imageUrl': vehicleDoc['imageUrl'] ?? '',
//   //         };
//   //       }),
//   //     );

//   //     setState(() {
//   //       vehicleBookings = bookings;
//   //       isLoading = false;
//   //     });
//   //   } catch (e) {
//   //     setState(() => isLoading = false);
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(SnackBar(content: Text('Error fetching bookings: $e')));
//   //   }
//   // }
//   Future<void> _fetchVehicleBookings() async {
//     setState(() => isLoading = true);
//     try {
//       final bookingsQuery =
//           await FirebaseFirestore.instance
//               .collection('vehicle_bookings')
//               .where('userEmail', isEqualTo: email)
//               .get();

//       final bookings = <Map<String, dynamic>>[];

//       for (var doc in bookingsQuery.docs) {
//         // ignore: unnecessary_cast
//         final bookingData = doc.data() as Map<String, dynamic>;
//         final vehicleId = bookingData['vehicleId'] as String; // Explicit cast

//         final vehicleDoc =
//             await FirebaseFirestore.instance
//                 .collection('vehicles')
//                 .doc(vehicleId)
//                 .get();

//         if (vehicleDoc.exists) {
//           final vehicleData = vehicleDoc.data() as Map<String, dynamic>;
//           bookings.add({
//             ...bookingData,
//             'id': doc.id,
//             'vehicleName':
//                 vehicleData['model']?.toString() ?? 'Unknown Vehicle',
//             'imageUrl': vehicleData['imageUrl']?.toString() ?? '',
//           });
//         }
//       }

//       setState(() {
//         vehicleBookings = bookings;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error fetching bookings: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('My Bookings'), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Section Selection Row
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildSectionCard(
//                     context,
//                     number: 1,
//                     title: "Vehicle",
//                     isSelected: _selectedSection == 1,
//                     onTap: () => setState(() => _selectedSection = 1),
//                   ),
//                   const SizedBox(width: 12),
//                   _buildSectionCard(
//                     context,
//                     number: 2,
//                     title: "Hotel",
//                     isSelected: _selectedSection == 2,
//                     onTap: () => setState(() => _selectedSection = 2),
//                   ),
//                   const SizedBox(width: 12),
//                   _buildSectionCard(
//                     context,
//                     number: 3,
//                     title: "Restaurant",
//                     isSelected: _selectedSection == 3,
//                     onTap: () => setState(() => _selectedSection = 3),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Content Area
//             Expanded(
//               child:
//                   _selectedSection == 1
//                       ? _buildVehicleBookings()
//                       : Center(
//                         child: Text(
//                           "Select a section to view bookings",
//                           style: Theme.of(context).textTheme.headlineSmall,
//                         ),
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVehicleBookings() {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (vehicleBookings.isEmpty) {
//       return const Center(
//         child: Text(
//           "No vehicle bookings found",
//           style: TextStyle(fontSize: 16),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchVehicleBookings,
//       child: ListView.builder(
//         padding: const EdgeInsets.only(bottom: 20),
//         itemCount: vehicleBookings.length,
//         itemBuilder: (context, index) {
//           final booking = vehicleBookings[index];
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: VehicleBookingCard(
//               vehicleName: booking['vehicleName'],
//               imageUrl: booking['imageUrl'],
//               pickUpDate: booking['pickUpDate'],
//               pickUpTime: booking['pickUpTime'],
//               dropOffDate: booking['dropOffDate'],
//               dropOffTime: booking['dropOffTime'],
//               totalCost: booking['totalCost']?.toDouble() ?? 0.0,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSectionCard(
//     BuildContext context, {
//     required int number,
//     required String title,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.28,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.shade700 : Colors.black,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 24,
//               height: 24,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   number.toString(),
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/all_bookings_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/vehicle_booking_card.dart';
import '../widgets/hotel_booking_card.dart';

class AllBookingsPage extends StatefulWidget {
  const AllBookingsPage({super.key});

  @override
  State<AllBookingsPage> createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  int _selectedSection = 0;
  final String email = "nadarnikson@gmail.com"; // Hardcoded email
  List<Map<String, dynamic>> vehicleBookings = [];
  List<Map<String, dynamic>> hotelBookings = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchVehicleBookings();
    _fetchHotelBookings();
  }

  Future<void> _fetchVehicleBookings() async {
    setState(() => isLoading = true);
    try {
      final bookingsQuery =
          await FirebaseFirestore.instance
              .collection('vehicle_bookings')
              .where('userEmail', isEqualTo: email)
              .get();

      final bookings = <Map<String, dynamic>>[];

      for (var doc in bookingsQuery.docs) {
        final bookingData = doc.data();
        final vehicleId = bookingData['vehicleId'] as String;

        final vehicleDoc =
            await FirebaseFirestore.instance
                .collection('vehicles')
                .doc(vehicleId)
                .get();

        if (vehicleDoc.exists) {
          final vehicleData = vehicleDoc.data() as Map<String, dynamic>;
          bookings.add({
            'name': vehicleData['name']?.toString() ?? 'Unknown Vehicle',
            'address': bookingData['address']?.toString() ?? 'No address',
            'pickUpDate': bookingData['pickUpDate']?.toString() ?? 'N/A',
            'pickUpTime': bookingData['pickUpTime']?.toString() ?? 'N/A',
            'dropOffDate': bookingData['dropOffDate']?.toString() ?? 'N/A',
            'dropOffTime': bookingData['dropOffTime']?.toString() ?? 'N/A',
            'totalCost': bookingData['totalCost']?.toDouble() ?? 0.0,
            'imageUrl': vehicleData['imageUrl']?.toString() ?? '',
          });
        }
      }

      setState(() {
        vehicleBookings = bookings;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching vehicle bookings: $e')),
      );
    }
  }

  Future<void> _fetchHotelBookings() async {
    setState(() => isLoading = true);
    try {
      final bookingsQuery =
          await FirebaseFirestore.instance
              .collection('hotel_bookings')
              .where('guestDetails.email', isEqualTo: email)
              .get();

      final bookings = <Map<String, dynamic>>[];

      for (var doc in bookingsQuery.docs) {
        final bookingData = doc.data();
        final hotelId = bookingData['hotelId'] as String;

        final hotelDoc =
            await FirebaseFirestore.instance
                .collection('hotels')
                .doc(hotelId)
                .get();

        if (hotelDoc.exists) {
          final hotelData = hotelDoc.data() as Map<String, dynamic>;
          final guestDetails =
              bookingData['guestDetails'] as Map<String, dynamic>;

          bookings.add({
            'hotelName': hotelData['name']?.toString() ?? 'Unknown Hotel',
            'imageUrl': hotelData['imageUrl']?.toString() ?? '',
            'firstName': guestDetails['firstName']?.toString() ?? 'N/A',
            'checkInDate': bookingData['checkInDate']?.toString() ?? 'N/A',
            'checkOutDate': bookingData['checkOutDate']?.toString() ?? 'N/A',
            'checkInTime': _formatTime(bookingData['checkInTime']),
            'checkOutTime': _formatTime(bookingData['checkOutTime']),
            'numberOfAdults': bookingData['numberOfAdults'] ?? 0,
            'numberOfChildren': bookingData['numberOfChildren'] ?? 0,
            'numberOfDays': bookingData['numberOfDays'] ?? 0,
            'numberOfRooms': bookingData['numberOfRooms'] ?? 0,
            'totalPrice': bookingData['totalPrice']?.toDouble() ?? 0.0,
          });
        }
      }

      setState(() {
        hotelBookings = bookings;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching hotel bookings: $e')),
      );
    }
  }

  String _formatTime(dynamic timeData) {
    if (timeData is Map<String, dynamic>) {
      final hour = timeData['hour']?.toString().padLeft(2, '0') ?? '00';
      final minute = timeData['minute']?.toString().padLeft(2, '0') ?? '00';
      return '$hour:$minute';
    }
    return timeData?.toString() ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section Selection Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSectionCard(
                    context,
                    number: 1,
                    title: "Vehicle",
                    isSelected: _selectedSection == 1,
                    onTap: () => setState(() => _selectedSection = 1),
                  ),
                  const SizedBox(width: 12),
                  _buildSectionCard(
                    context,
                    number: 2,
                    title: "Hotel",
                    isSelected: _selectedSection == 2,
                    onTap: () => setState(() => _selectedSection = 2),
                  ),
                  const SizedBox(width: 12),
                  _buildSectionCard(
                    context,
                    number: 3,
                    title: "Restaurant",
                    isSelected: _selectedSection == 3,
                    onTap: () => setState(() => _selectedSection = 3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Content Area
            Expanded(
              child:
                  _selectedSection == 1
                      ? _buildVehicleBookings()
                      : _selectedSection == 2
                      ? _buildHotelBookings()
                      : Center(
                        child: Text(
                          "Select a section to view bookings",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleBookings() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vehicleBookings.isEmpty) {
      return const Center(child: Text("No vehicle bookings found"));
    }

    return RefreshIndicator(
      onRefresh: _fetchVehicleBookings,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: vehicleBookings.length,
        itemBuilder: (context, index) {
          final booking = vehicleBookings[index];
          return VehicleBookingCard(
            name: booking['name'],
            address: booking['address'],
            pickUpDate: booking['pickUpDate'],
            pickUpTime: booking['pickUpTime'],
            dropOffDate: booking['dropOffDate'],
            dropOffTime: booking['dropOffTime'],
            totalCost: booking['totalCost'],
            imageUrl: booking['imageUrl'],
          );
        },
      ),
    );
  }

  Widget _buildHotelBookings() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hotelBookings.isEmpty) {
      return const Center(child: Text("No hotel bookings found"));
    }

    return RefreshIndicator(
      onRefresh: _fetchHotelBookings,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: hotelBookings.length,
        itemBuilder: (context, index) {
          final booking = hotelBookings[index];
          return HotelBookingCard(
            hotelName: booking['hotelName'],
            imageUrl: booking['imageUrl'],
            firstName: booking['firstName'],
            checkInDate: booking['checkInDate'],
            checkOutDate: booking['checkOutDate'],
            checkInTime: booking['checkInTime'],
            checkOutTime: booking['checkOutTime'],
            numberOfAdults: booking['numberOfAdults'],
            numberOfChildren: booking['numberOfChildren'],
            numberOfDays: booking['numberOfDays'],
            numberOfRooms: booking['numberOfRooms'],
            totalPrice: booking['totalPrice'],
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required int number,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade700 : Colors.black,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
