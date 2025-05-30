// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';

// class ConfirmBookingPage extends StatefulWidget {
//   const ConfirmBookingPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ConfirmBookingPageState createState() => _ConfirmBookingPageState();
// }

// class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
//   DateTime? selectedCheckInDate;
//   DateTime? selectedCheckOutDate;
//   String? selectedRoomType;
//   double basePrice = 1000.0; // Base price per day
//   double totalPrice = 0.0;

//   // New dropdowns with both adults and children default to 0
//   int numberOfAdults = 0;
//   int numberOfChildren = 0;
//   int numberOfRooms = 1;

//   // Calculate number of days between check-in and check-out
//   int calculateNumberOfDays() {
//     if (selectedCheckInDate == null || selectedCheckOutDate == null) {
//       return 0;
//     }
//     return selectedCheckOutDate!.difference(selectedCheckInDate!).inDays;
//   }

//   // Calculate total price based on number of days
//   void calculateTotalPrice() {
//     int numberOfDays = calculateNumberOfDays();
//     double pricePerDay = basePrice;

//     // Double the price for each additional day
//     for (int i = 1; i < numberOfDays; i++) {
//       pricePerDay *= 2;
//     }

//     // Multiply by number of rooms
//     setState(() {
//       totalPrice = pricePerDay * numberOfRooms;
//     });
//   }

//   Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
//     DateTime initialDate =
//         isCheckIn
//             ? (selectedCheckInDate ?? DateTime.now())
//             : (selectedCheckOutDate ??
//                 (selectedCheckInDate?.add(const Duration(days: 1)) ??
//                     DateTime.now().add(const Duration(days: 1))));

//     DateTime firstDate =
//         isCheckIn
//             ? DateTime.now()
//             : (selectedCheckInDate?.add(const Duration(days: 1)) ??
//                 DateTime.now().add(const Duration(days: 1)));

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isCheckIn) {
//           selectedCheckInDate = picked;
//           if (selectedCheckOutDate != null &&
//               selectedCheckOutDate!.isBefore(picked)) {
//             selectedCheckOutDate = null;
//           }
//         } else {
//           selectedCheckOutDate = picked;
//         }
//         calculateTotalPrice(); // Recalculate price when dates change
//       });
//     }
//   }

//   Future<void> _confirmBooking() async {
//     if (selectedRoomType == null ||
//         selectedCheckInDate == null ||
//         selectedCheckOutDate == null ||
//         numberOfAdults == 0) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all details")));
//       return;
//     }

//     String documentId = const Uuid().v4(); // Generate unique document ID

//     try {
//       await FirebaseFirestore.instance
//           .collection('hotel_bookings')
//           .doc(documentId)
//           .set({
//             'documentId': documentId,
//             'roomType': selectedRoomType,
//             'checkInDate': selectedCheckInDate,
//             'checkOutDate': selectedCheckOutDate,
//             'numberOfAdults': numberOfAdults,
//             'numberOfChildren': numberOfChildren,
//             'numberOfRooms': numberOfRooms,
//             'totalPrice': totalPrice,
//             'numberOfDays': calculateNumberOfDays(),
//           });

//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Booking Confirmed!")));

//       // Clear fields after booking
//       setState(() {
//         selectedRoomType = null;
//         selectedCheckInDate = null;
//         selectedCheckOutDate = null;
//         numberOfAdults = 0;
//         numberOfChildren = 0;
//         numberOfRooms = 1;
//         totalPrice = 0.0;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Book Hotel"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle("Choose Room Type:"),
//             _buildRoomTypeSelection(),
//             const SizedBox(height: 16),

//             _buildSectionTitle("Base Price per Day:"),
//             Text(
//               "₹${basePrice.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 16, color: Colors.green),
//             ),
//             const SizedBox(height: 16),

//             _buildSectionTitle("Select Check-in Date:"),
//             _buildDatePickerText(
//               "Click Here to select",
//               selectedCheckInDate,
//               true,
//             ),
//             const SizedBox(height: 16),

//             _buildSectionTitle("Select Check-out Date:"),
//             _buildDatePickerText(
//               "Click Here to select",
//               selectedCheckOutDate,
//               false,
//             ),
//             const SizedBox(height: 16),

//             if (calculateNumberOfDays() > 0) ...[
//               _buildSectionTitle("Number of Days:"),
//               Text(
//                 "${calculateNumberOfDays()} days",
//                 style: const TextStyle(fontSize: 16, color: Colors.blue),
//               ),
//               const SizedBox(height: 16),
//             ],

//             // Dropdowns with default 0 for adults and children
//             _buildDropdownField(
//               "Number of Adults",
//               numberOfAdults,
//               (newValue) => setState(() {
//                 numberOfAdults = newValue!;
//                 calculateTotalPrice();
//               }),
//               List.generate(10, (index) => index),
//             ),
//             const SizedBox(height: 16),

//             _buildDropdownField(
//               "Number of Children",
//               numberOfChildren,
//               (newValue) => setState(() {
//                 numberOfChildren = newValue!;
//                 calculateTotalPrice();
//               }),
//               List.generate(6, (index) => index),
//             ),
//             const SizedBox(height: 16),

//             _buildDropdownField(
//               "Number of Rooms",
//               numberOfRooms,
//               (newValue) => setState(() {
//                 numberOfRooms = newValue!;
//                 calculateTotalPrice();
//               }),
//               List.generate(5, (index) => index + 1),
//             ),
//             const SizedBox(height: 20),

//             if (totalPrice > 0) ...[
//               _buildSectionTitle("Total Price:"),
//               Text(
//                 "₹${totalPrice.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],

//             SizedBox(
//               width: screenWidth,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 onPressed: _confirmBooking,
//                 child: const Text(
//                   "Confirm Booking",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//confirm_booking_page.dart
// import 'package:city_wheels/hotels/booking_details_page.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';

// class ConfirmBookingPage extends StatefulWidget {
//   const ConfirmBookingPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ConfirmBookingPageState createState() => _ConfirmBookingPageState();
// }

// class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
//   // Define a map of room types with their base prices
//   final Map<String, double> roomTypePrices = {
//     'Single Room': 2000.0,
//     'Double Room': 3500.0,
//     'Suite': 6000.0,
//     'Deluxe': 4500.0,
//   };

//   DateTime? selectedCheckInDate;
//   DateTime? selectedCheckOutDate;
//   String? selectedRoomType;

//   // Add time variables
//   TimeOfDay? selectedCheckInTime;
//   TimeOfDay? selectedCheckOutTime;

//   // Initialize basePrice using the first room type in the map
//   late double basePrice = roomTypePrices.values.first;
//   double pricePerDay = 0.0;
//   double totalPrice = 0.0;

//   // New dropdowns with both adults and children default to 0
//   int numberOfAdults = 0;
//   int numberOfChildren = 0;
//   int numberOfRooms = 1;

//   @override
//   void initState() {
//     super.initState();
//     // Set initial price based on first room type
//     pricePerDay = basePrice;
//   }

//   // Calculate number of days between check-in and check-out
//   int calculateNumberOfDays() {
//     if (selectedCheckInDate == null || selectedCheckOutDate == null) {
//       return 0;
//     }
//     return selectedCheckOutDate!.difference(selectedCheckInDate!).inDays;
//   }

//   // Calculate total price based on number of people and days
//   void calculateTotalPrice() {
//     int numberOfDays = calculateNumberOfDays();
//     double calculatedPricePerDay = basePrice;

//     // For 1-2 adults, keep the original price
//     if (numberOfAdults > 2) {
//       // Calculate extra price for additional adults
//       int extraAdults = numberOfAdults - 2;
//       double extraPrice = calculatedPricePerDay / 2;

//       // Add extra price for each additional adult
//       calculatedPricePerDay += extraAdults * extraPrice;
//     }

//     // Add extra price for children
//     if (numberOfChildren > 0) {
//       double extraPrice = calculatedPricePerDay / 2;
//       calculatedPricePerDay += numberOfChildren * (0.7 * extraPrice);
//     }

//     setState(() {
//       pricePerDay = calculatedPricePerDay;
//       totalPrice = pricePerDay * numberOfRooms * numberOfDays;
//     });
//   }

//   // New method to select time
//   Future<void> _selectTime(BuildContext context, bool isCheckIn) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime:
//           isCheckIn
//               ? (selectedCheckInTime ?? TimeOfDay.now())
//               : (selectedCheckOutTime ?? TimeOfDay.now()),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isCheckIn) {
//           selectedCheckInTime = picked;
//         } else {
//           selectedCheckOutTime = picked;
//         }
//       });
//     }
//   }

//   Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
//     DateTime initialDate =
//         isCheckIn
//             ? (selectedCheckInDate ?? DateTime.now())
//             : (selectedCheckOutDate ??
//                 (selectedCheckInDate?.add(const Duration(days: 1)) ??
//                     DateTime.now().add(const Duration(days: 1))));

//     DateTime firstDate =
//         isCheckIn
//             ? DateTime.now()
//             : (selectedCheckInDate?.add(const Duration(days: 1)) ??
//                 DateTime.now().add(const Duration(days: 1)));

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isCheckIn) {
//           selectedCheckInDate = picked;
//           if (selectedCheckOutDate != null &&
//               selectedCheckOutDate!.isBefore(picked)) {
//             selectedCheckOutDate = null;
//           }
//         } else {
//           selectedCheckOutDate = picked;
//         }
//         calculateTotalPrice(); // Recalculate price when dates change
//       });
//     }
//   }

//   // Modify _confirmBooking method to include time in Firestore document
//   // Future<void> _confirmBooking() async {
//   //   if (selectedRoomType == null ||
//   //       selectedCheckInDate == null ||
//   //       selectedCheckOutDate == null ||
//   //       selectedCheckInTime == null ||
//   //       selectedCheckOutTime == null ||
//   //       numberOfAdults == 0) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text("Please fill all details")));
//   //     return;
//   //   }

//   //   String documentId = const Uuid().v4(); // Generate unique document ID

//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection('hotel_bookings')
//   //         .doc(documentId)
//   //         .set({
//   //           'documentId': documentId,
//   //           'roomType': selectedRoomType,
//   //           'checkInDate': selectedCheckInDate,
//   //           'checkInTime': {
//   //             'hour': selectedCheckInTime!.hour,
//   //             'minute': selectedCheckInTime!.minute,
//   //           },
//   //           'checkOutDate': selectedCheckOutDate,
//   //           'checkOutTime': {
//   //             'hour': selectedCheckOutTime!.hour,
//   //             'minute': selectedCheckOutTime!.minute,
//   //           },
//   //           'numberOfAdults': numberOfAdults,
//   //           'numberOfChildren': numberOfChildren,
//   //           'numberOfRooms': numberOfRooms,
//   //           'pricePerDay': pricePerDay,
//   //           'totalPrice': totalPrice,
//   //           'numberOfDays': calculateNumberOfDays(),
//   //         });

//   //     ScaffoldMessenger.of(
//   //       // ignore: use_build_context_synchronously
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text("Booking Confirmed!")));

//   //     // Navigate to BookingDetailsPage with the documentId
//   //     // ignore: use_build_context_synchronously
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => BookingDetailsPage(bookingId: documentId),
//   //       ),
//   //     );

//   //     // Clear fields after booking
//   //     setState(() {
//   //       selectedRoomType = null;
//   //       selectedCheckInDate = null;
//   //       selectedCheckOutDate = null;
//   //       selectedCheckInTime = null;
//   //       selectedCheckOutTime = null;
//   //       numberOfAdults = 0;
//   //       numberOfChildren = 0;
//   //       numberOfRooms = 1;
//   //       pricePerDay = basePrice;
//   //       totalPrice = 0.0;
//   //     });
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(
//   //       // ignore: use_build_context_synchronously
//   //       context,
//   //     ).showSnackBar(SnackBar(content: Text("Error: $e")));
//   //   }
//   // }

//   // Modify _confirmBooking method to include time in Firestore document
//   Future<void> _confirmBooking() async {
//     if (selectedRoomType == null ||
//         selectedCheckInDate == null ||
//         selectedCheckOutDate == null ||
//         selectedCheckInTime == null ||
//         selectedCheckOutTime == null ||
//         numberOfAdults == 0) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all details")));
//       return;
//     }

//     String documentId = const Uuid().v4(); // Generate unique document ID

//     try {
//       await FirebaseFirestore.instance
//           .collection('hotel_bookings')
//           .doc(documentId)
//           .set({
//             'documentId': documentId,
//             'roomType': selectedRoomType,
//             'checkInDate': selectedCheckInDate,
//             'checkInTime': {
//               'hour': selectedCheckInTime!.hour,
//               'minute': selectedCheckInTime!.minute,
//             },
//             'checkOutDate': selectedCheckOutDate,
//             'checkOutTime': {
//               'hour': selectedCheckOutTime!.hour,
//               'minute': selectedCheckOutTime!.minute,
//             },
//             'numberOfAdults': numberOfAdults,
//             'numberOfChildren': numberOfChildren,
//             'numberOfRooms': numberOfRooms,
//             'pricePerDay': pricePerDay,
//             'totalPrice': totalPrice,
//             'numberOfDays': calculateNumberOfDays(),
//           });

//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Booking Confirmed!")));

//       // Navigate to BookingDetailsPage with the documentId
//       // ignore: use_build_context_synchronously
//       Navigator.push(
//         // ignore: use_build_context_synchronously
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) =>
//                   BookingDetailsPage(bookingId: documentId, bookingData: {}),
//         ),
//       );

//       // Clear fields after booking
//       setState(() {
//         selectedRoomType = null;
//         selectedCheckInDate = null;
//         selectedCheckOutDate = null;
//         selectedCheckInTime = null;
//         selectedCheckOutTime = null;
//         numberOfAdults = 0;
//         numberOfChildren = 0;
//         numberOfRooms = 1;
//         pricePerDay = basePrice;
//         totalPrice = 0.0;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Book Hotel"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle("Choose Room Type:"),
//             _buildRoomTypeSelection(),
//             const SizedBox(height: 16),

//             _buildSectionTitle("Base Price per Day:"),
//             Text(
//               "₹${basePrice.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 16, color: Colors.green),
//             ),
//             const SizedBox(height: 16),

//             // Check-in Date and Time Row
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Check-in Date:"),
//                       _buildDatePickerText(
//                         "Select Check-in Date",
//                         selectedCheckInDate,
//                         true,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Check-in Time:"),
//                       _buildTimePickerText(
//                         "Select Check-in Time",
//                         selectedCheckInTime,
//                         true,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Check-out Date and Time Row
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Check-out Date:"),
//                       _buildDatePickerText(
//                         "Select Check-out Date",
//                         selectedCheckOutDate,
//                         false,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Check-out Time:"),
//                       _buildTimePickerText(
//                         "Select Check-out Time",
//                         selectedCheckOutTime,
//                         false,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             if (calculateNumberOfDays() > 0) ...[
//               _buildSectionTitle("Number of Days:"),
//               Text(
//                 "${calculateNumberOfDays()} days",
//                 style: const TextStyle(fontSize: 16, color: Colors.blue),
//               ),
//               const SizedBox(height: 16),

//               _buildSectionTitle("Price per Day:"),
//               Text(
//                 "₹${pricePerDay.toStringAsFixed(2)}",
//                 style: const TextStyle(fontSize: 16, color: Colors.green),
//               ),
//               const SizedBox(height: 16),
//             ],

//             // Dropdowns with default 0 for adults and children
//             _buildDropdownField(
//               "Number of Adults",
//               numberOfAdults,
//               (newValue) => setState(() {
//                 numberOfAdults = newValue!;
//                 calculateTotalPrice();
//               }),
//               List.generate(10, (index) => index),
//             ),
//             const SizedBox(height: 16),

//             _buildDropdownField(
//               "Number of Children",
//               numberOfChildren,
//               (newValue) => setState(() {
//                 numberOfChildren = newValue!;
//                 calculateTotalPrice();
//               }),
//               List.generate(6, (index) => index),
//             ),
//             const SizedBox(height: 16),

//             _buildDropdownField(
//               "Number of Rooms",
//               numberOfRooms,
//               (newValue) => setState(() {
//                 numberOfRooms = newValue!;
//                 calculateTotalPrice();
//               }),
//               List.generate(5, (index) => index + 1),
//             ),
//             const SizedBox(height: 20),

//             if (totalPrice > 0) ...[
//               _buildSectionTitle("Total Price:"),
//               Text(
//                 "₹${totalPrice.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],

//             SizedBox(
//               width: screenWidth,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 onPressed: _confirmBooking,
//                 child: const Text(
//                   "Confirm Booking",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // New method to build time picker text
//   Widget _buildTimePickerText(
//     String label,
//     TimeOfDay? selectedTime,
//     bool isCheckIn,
//   ) {
//     return GestureDetector(
//       onTap: () => _selectTime(context, isCheckIn),
//       child: Text(
//         selectedTime == null ? label : selectedTime.format(context),
//         style: const TextStyle(
//           fontSize: 16,
//           color: Colors.blue,
//           decoration: TextDecoration.underline,
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     );
//   }

//   Widget _buildRoomTypeSelection() {
//     return Wrap(
//       spacing: 10,
//       children:
//           roomTypePrices.keys.map((room) {
//             bool isSelected = selectedRoomType == room;

//             return ChoiceChip(
//               label: Text(
//                 room,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : Colors.black,
//                 ),
//               ),
//               selected: isSelected,
//               selectedColor: Colors.blue,
//               backgroundColor: Colors.grey[300],
//               onSelected: (selected) {
//                 setState(() {
//                   selectedRoomType = room;
//                   // Update basePrice when room type is selected
//                   basePrice = roomTypePrices[room]!;
//                   // Recalculate price with new base price
//                   pricePerDay = basePrice;
//                   calculateTotalPrice();
//                 });
//               },
//             );
//           }).toList(),
//     );
//   }

//   Widget _buildDatePickerText(
//     String label,
//     DateTime? selectedDate,
//     bool isCheckIn,
//   ) {
//     return GestureDetector(
//       onTap: () => _selectDate(context, isCheckIn),
//       child: Text(
//         selectedDate == null
//             ? label
//             : DateFormat('MMM dd, yyyy').format(selectedDate),
//         style: const TextStyle(
//           fontSize: 16,
//           color: Colors.blue,
//           decoration: TextDecoration.underline,
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownField(
//     String label,
//     int currentValue,
//     void Function(int?) onChanged,
//     List<int> options,
//   ) {
//     return DropdownButtonFormField<int>(
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//       value: currentValue,
//       items:
//           options.map((int value) {
//             return DropdownMenuItem<int>(
//               value: value,
//               child: Text(value.toString()),
//             );
//           }).toList(),
//       onChanged: onChanged,
//     );
//   }
// }
import 'package:city_wheels/hotels/booking_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ConfirmBookingPage extends StatefulWidget {
  final String hotelId;
  final String hotelName;
  const ConfirmBookingPage({
    super.key,
    required this.hotelId,
    required this.hotelName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmBookingPageState createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  // Define a map of room types with their base prices
  final Map<String, double> roomTypePrices = {
    'Single Room': 2000.0,
    'Double Room': 3500.0,
    'Suite': 6000.0,
    'Deluxe': 4500.0,
  };

  DateTime? selectedCheckInDate;
  DateTime? selectedCheckOutDate;
  String? selectedRoomType;

  // Add time variables
  TimeOfDay? selectedCheckInTime;
  TimeOfDay? selectedCheckOutTime;

  // Initialize basePrice using the first room type in the map
  late double basePrice = roomTypePrices.values.first;
  double pricePerDay = 0.0;
  double totalPrice = 0.0;

  // New dropdowns with both adults and children default to 0
  int numberOfAdults = 0;
  int numberOfChildren = 0;
  int numberOfRooms = 1;

  @override
  void initState() {
    super.initState();
    // Set initial price based on first room type
    pricePerDay = basePrice;
  }

  // Calculate number of days between check-in and check-out
  int calculateNumberOfDays() {
    if (selectedCheckInDate == null || selectedCheckOutDate == null) {
      return 0;
    }
    return selectedCheckOutDate!.difference(selectedCheckInDate!).inDays;
  }

  // Calculate total price based on number of people and days
  void calculateTotalPrice() {
    int numberOfDays = calculateNumberOfDays();
    double calculatedPricePerDay = basePrice;

    // For 1-2 adults, keep the original price
    if (numberOfAdults > 2) {
      // Calculate extra price for additional adults
      int extraAdults = numberOfAdults - 2;
      double extraPrice = calculatedPricePerDay / 2;

      // Add extra price for each additional adult
      calculatedPricePerDay += extraAdults * extraPrice;
    }

    // Add extra price for children
    if (numberOfChildren > 0) {
      double extraPrice = calculatedPricePerDay / 2;
      calculatedPricePerDay += numberOfChildren * (0.7 * extraPrice);
    }

    setState(() {
      pricePerDay = calculatedPricePerDay;
      totalPrice = pricePerDay * numberOfRooms * numberOfDays;
    });
  }

  // New method to select time
  Future<void> _selectTime(BuildContext context, bool isCheckIn) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isCheckIn
              ? (selectedCheckInTime ?? TimeOfDay.now())
              : (selectedCheckOutTime ?? TimeOfDay.now()),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          selectedCheckInTime = picked;
        } else {
          selectedCheckOutTime = picked;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate =
        isCheckIn
            ? (selectedCheckInDate ?? DateTime.now())
            : (selectedCheckOutDate ??
                (selectedCheckInDate?.add(const Duration(days: 1)) ??
                    DateTime.now().add(const Duration(days: 1))));

    DateTime firstDate =
        isCheckIn
            ? DateTime.now()
            : (selectedCheckInDate?.add(const Duration(days: 1)) ??
                DateTime.now().add(const Duration(days: 1)));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          selectedCheckInDate = picked;
          if (selectedCheckOutDate != null &&
              selectedCheckOutDate!.isBefore(picked)) {
            selectedCheckOutDate = null;
          }
        } else {
          selectedCheckOutDate = picked;
        }
        calculateTotalPrice(); // Recalculate price when dates change
      });
    }
  }

  // Modify _confirmBooking method to include time in Firestore document
  // Future<void> _confirmBooking() async {
  //   if (selectedRoomType == null ||
  //       selectedCheckInDate == null ||
  //       selectedCheckOutDate == null ||
  //       selectedCheckInTime == null ||
  //       selectedCheckOutTime == null ||
  //       numberOfAdults == 0) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Please fill all details")));
  //     return;
  //   }

  //   String documentId = const Uuid().v4(); // Generate unique document ID

  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('hotel_bookings')
  //         .doc(documentId)
  //         .set({
  //           'documentId': documentId,
  //           'roomType': selectedRoomType,
  //           'checkInDate': selectedCheckInDate,
  //           'checkInTime': {
  //             'hour': selectedCheckInTime!.hour,
  //             'minute': selectedCheckInTime!.minute,
  //           },
  //           'checkOutDate': selectedCheckOutDate,
  //           'checkOutTime': {
  //             'hour': selectedCheckOutTime!.hour,
  //             'minute': selectedCheckOutTime!.minute,
  //           },
  //           'numberOfAdults': numberOfAdults,
  //           'numberOfChildren': numberOfChildren,
  //           'numberOfRooms': numberOfRooms,
  //           'pricePerDay': pricePerDay,
  //           'totalPrice': totalPrice,
  //           'numberOfDays': calculateNumberOfDays(),
  //         });

  //     ScaffoldMessenger.of(
  //       // ignore: use_build_context_synchronously
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Booking Confirmed!")));

  //     // Navigate to BookingDetailsPage with the documentId
  //     // ignore: use_build_context_synchronously
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => BookingDetailsPage(bookingId: documentId),
  //       ),
  //     );

  //     // Clear fields after booking
  //     setState(() {
  //       selectedRoomType = null;
  //       selectedCheckInDate = null;
  //       selectedCheckOutDate = null;
  //       selectedCheckInTime = null;
  //       selectedCheckOutTime = null;
  //       numberOfAdults = 0;
  //       numberOfChildren = 0;
  //       numberOfRooms = 1;
  //       pricePerDay = basePrice;
  //       totalPrice = 0.0;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       // ignore: use_build_context_synchronously
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Error: $e")));
  //   }
  // }

  // Modify _confirmBooking method to include time in Firestore document
  Future<void> _confirmBooking() async {
    if (selectedRoomType == null ||
        selectedCheckInDate == null ||
        selectedCheckOutDate == null ||
        selectedCheckInTime == null ||
        selectedCheckOutTime == null ||
        numberOfAdults == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all details")));
      return;
    }

    String documentId = const Uuid().v4(); // Generate unique document ID

    try {
      await FirebaseFirestore.instance
          .collection('hotel_bookings')
          .doc(documentId)
          .set({
            'documentId': documentId,
            'hotelId': widget.hotelId, // Add hotel reference
            'hotelName': widget.hotelName, // Also store name for easier access
            'roomType': selectedRoomType,
            'checkInDate': selectedCheckInDate,
            'checkInTime': {
              'hour': selectedCheckInTime!.hour,
              'minute': selectedCheckInTime!.minute,
            },
            'checkOutDate': selectedCheckOutDate,
            'checkOutTime': {
              'hour': selectedCheckOutTime!.hour,
              'minute': selectedCheckOutTime!.minute,
            },
            'numberOfAdults': numberOfAdults,
            'numberOfChildren': numberOfChildren,
            'numberOfRooms': numberOfRooms,
            'pricePerDay': pricePerDay,
            'totalPrice': totalPrice,
            'numberOfDays': calculateNumberOfDays(),
          });

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text("Booking Confirmed!")));

      // Navigate to BookingDetailsPage with the documentId
      // ignore: use_build_context_synchronously
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder:
              (context) => BookingDetailsPage(
                bookingId: documentId,
                bookingData: {}, // You can pass initial data if needed
              ),
        ),
      );

      // Clear fields after booking
      setState(() {
        selectedRoomType = null;
        selectedCheckInDate = null;
        selectedCheckOutDate = null;
        selectedCheckInTime = null;
        selectedCheckOutTime = null;
        numberOfAdults = 0;
        numberOfChildren = 0;
        numberOfRooms = 1;
        pricePerDay = basePrice;
        totalPrice = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Hotel"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Choose Room Type:"),
            _buildRoomTypeSelection(),
            const SizedBox(height: 16),

            _buildSectionTitle("Base Price per Day:"),
            Text(
              "₹${basePrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 16),

            // Check-in Date and Time Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Check-in Date:"),
                      _buildDatePickerText(
                        "Select Check-in Date",
                        selectedCheckInDate,
                        true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Check-in Time:"),
                      _buildTimePickerText(
                        "Select Check-in Time",
                        selectedCheckInTime,
                        true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Check-out Date and Time Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Check-out Date:"),
                      _buildDatePickerText(
                        "Select Check-out Date",
                        selectedCheckOutDate,
                        false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Check-out Time:"),
                      _buildTimePickerText(
                        "Select Check-out Time",
                        selectedCheckOutTime,
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (calculateNumberOfDays() > 0) ...[
              _buildSectionTitle("Number of Days:"),
              Text(
                "${calculateNumberOfDays()} days",
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
              const SizedBox(height: 16),

              _buildSectionTitle("Price per Day:"),
              Text(
                "₹${pricePerDay.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 16),
            ],

            // Dropdowns with default 0 for adults and children
            _buildDropdownField(
              "Number of Adults",
              numberOfAdults,
              (newValue) => setState(() {
                numberOfAdults = newValue!;
                calculateTotalPrice();
              }),
              List.generate(10, (index) => index),
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              "Number of Children",
              numberOfChildren,
              (newValue) => setState(() {
                numberOfChildren = newValue!;
                calculateTotalPrice();
              }),
              List.generate(6, (index) => index),
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              "Number of Rooms",
              numberOfRooms,
              (newValue) => setState(() {
                numberOfRooms = newValue!;
                calculateTotalPrice();
              }),
              List.generate(5, (index) => index + 1),
            ),
            const SizedBox(height: 20),

            if (totalPrice > 0) ...[
              _buildSectionTitle("Total Price:"),
              Text(
                "₹${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
            ],

            SizedBox(
              width: screenWidth,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: _confirmBooking,
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New method to build time picker text
  Widget _buildTimePickerText(
    String label,
    TimeOfDay? selectedTime,
    bool isCheckIn,
  ) {
    return GestureDetector(
      onTap: () => _selectTime(context, isCheckIn),
      child: Text(
        selectedTime == null ? label : selectedTime.format(context),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRoomTypeSelection() {
    return Wrap(
      spacing: 10,
      children:
          roomTypePrices.keys.map((room) {
            bool isSelected = selectedRoomType == room;

            return ChoiceChip(
              label: Text(
                room,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelected,
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[300],
              onSelected: (selected) {
                setState(() {
                  selectedRoomType = room;
                  // Update basePrice when room type is selected
                  basePrice = roomTypePrices[room]!;
                  // Recalculate price with new base price
                  pricePerDay = basePrice;
                  calculateTotalPrice();
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildDatePickerText(
    String label,
    DateTime? selectedDate,
    bool isCheckIn,
  ) {
    return GestureDetector(
      onTap: () => _selectDate(context, isCheckIn),
      child: Text(
        selectedDate == null
            ? label
            : DateFormat('MMM dd, yyyy').format(selectedDate),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    int currentValue,
    void Function(int?) onChanged,
    List<int> options,
  ) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: currentValue,
      items:
          options.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }
}
