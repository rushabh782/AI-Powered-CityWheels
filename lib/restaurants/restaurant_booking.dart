// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // ignore: use_key_in_widget_constructors
// class RestaurantBookingPage extends StatefulWidget {
//   @override
//   // ignore: library_private_types_in_public_api
//   _RestaurantBookingPageState createState() => _RestaurantBookingPageState();
// }

// class _RestaurantBookingPageState extends State<RestaurantBookingPage> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   int guests = 1;
//   final _formKey = GlobalKey<FormState>();

//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController specialRequestsController = TextEditingController();

//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null && picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }

//   void _confirmBooking() async {
//     if (_formKey.currentState!.validate() &&
//         selectedDate != null &&
//         selectedTime != null) {
//       try {
//         // Add a new document without specifying an ID (Firestore auto-generates it)
//         DocumentReference docRef = await FirebaseFirestore.instance
//             .collection('restaurant_bookings')
//             .add({
//               'selectedDate': Timestamp.fromDate(selectedDate!),
//               'selectedTime': selectedTime!.format(
//                 context,
//               ), // Storing as String
//               'guests': guests,
//               'fullName': nameController.text.trim(),
//               'phoneNumber': int.parse(phoneController.text.trim()),
//               'email': emailController.text.trim(),
//               'specialRequests': specialRequestsController.text.trim(),
//               // 'timestamp': FieldValue.serverTimestamp(), // Auto-generated timestamp
//             });

//         // Update the document to store its own ID
//         await docRef.update({'documentId': docRef.id});

//         ScaffoldMessenger.of(
//           // ignore: use_build_context_synchronously
//           context,
//         ).showSnackBar(SnackBar(content: Text("Booking Confirmed")));

//         // // ✅ Clear the form fields
//         // _formKey.currentState!.reset();
//         // nameController.clear();
//         // phoneController.clear();
//         // emailController.clear();
//         // specialRequestsController.clear();

//         // Optionally clear the form after submission
//         _formKey.currentState!.reset();
//         setState(() {
//           selectedDate = null;
//           selectedTime = null;
//           guests = 1;
//           nameController.clear();
//           phoneController.clear();
//           emailController.clear();
//           specialRequestsController.clear();
//         });
//       } catch (e) {
//         ScaffoldMessenger.of(
//           // ignore: use_build_context_synchronously
//           context,
//         ).showSnackBar(SnackBar(content: Text("Error: $e")));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please fill all required fields!")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(title: Text("Confirm Booking")),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Select Date:"),
//                 TextButton(
//                   onPressed: () => _selectDate(context),
//                   child: Text(
//                     selectedDate == null
//                         ? "Select Date"
//                         : DateFormat('yyyy-MM-dd').format(selectedDate!),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text("Select Time:"),
//                 TextButton(
//                   onPressed: () => _selectTime(context),
//                   child: Text(
//                     selectedTime == null
//                         ? "Select Time"
//                         : selectedTime!.format(context),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text("Number of Guests:"),
//                 DropdownButton<int>(
//                   value: guests,
//                   items:
//                       List.generate(10, (index) => index + 1)
//                           .map(
//                             (e) => DropdownMenuItem(
//                               // ignore: sort_child_properties_last
//                               child: Text(e.toString()),
//                               value: e,
//                             ),
//                           )
//                           .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       guests = value!;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: nameController,
//                   decoration: InputDecoration(labelText: "Full Name"),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Name is required";
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: phoneController,
//                   decoration: InputDecoration(labelText: "Phone Number"),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Phone number is required";
//                     } else if (!RegExp(r'^[1-9][0-9]{9}$').hasMatch(value)) {
//                       return "Enter a valid 10-digit phone number without leading zeros";
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(labelText: "Email (Optional)"),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value != null && value.isNotEmpty) {
//                       if (!RegExp(
//                         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//                       ).hasMatch(value)) {
//                         return "Enter a valid email address";
//                       }
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: specialRequestsController,
//                   decoration: InputDecoration(labelText: "Special Requests"),
//                 ),
//                 SizedBox(height: screenHeight * 0.03),
//                 ElevatedButton(
//                   onPressed: _confirmBooking,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Confirm Booking",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//restaurant_booking.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RestaurantBookingPage extends StatefulWidget {
//   final String restaurantId;
//   final String restaurantName;
//   final String? standardTablePrice;

//   const RestaurantBookingPage({
//     super.key,
//     required this.restaurantId,
//     required this.restaurantName,
//     required this.standardTablePrice,
//   });

//   @override
//   State<RestaurantBookingPage> createState() => _RestaurantBookingPageState();
// }

// class _RestaurantBookingPageState extends State<RestaurantBookingPage> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   int guests = 1;
//   String? selectedMealType;
//   bool useOffer = false;
//   Map<String, Map<String, String>>? operatingHours;
//   Map<String, List<String>> timeSlots = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchOperatingHours();
//   }

//   Future<void> _fetchOperatingHours() async {
//     try {
//       final doc =
//           await FirebaseFirestore.instance
//               .collection('restaurant_details')
//               .doc(widget.restaurantId)
//               .get();

//       if (doc.exists) {
//         final data = doc.data();
//         if (data != null && data['operatingHours'] != null) {
//           setState(() {
//             operatingHours = Map<String, Map<String, String>>.from(
//               data['operatingHours'],
//             );
//             _generateTimeSlots();
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Error fetching operating hours: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   void _generateTimeSlots() {
//     if (operatingHours == null) return;

//     timeSlots.clear();

//     operatingHours!.forEach((mealType, hours) {
//       final startTime = hours['start']!.split(':');
//       final endTime = hours['end']!.split(':');

//       final startHour = int.parse(startTime[0]);
//       final startMinute = int.parse(startTime[1]);
//       final endHour = int.parse(endTime[0]);
//       final endMinute = int.parse(endTime[1]);

//       final slots = <String>[];
//       DateTime currentTime = DateTime(2023, 1, 1, startHour, startMinute);
//       final endDateTime = DateTime(2023, 1, 1, endHour, endMinute);

//       while (currentTime.isBefore(endDateTime)) {
//         slots.add(DateFormat('h:mm a').format(currentTime));
//         currentTime = currentTime.add(const Duration(minutes: 15));
//       }

//       timeSlots[mealType] = slots;
//     });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         selectedTime = null;
//         selectedMealType = null;
//       });
//     }
//   }

//   double calculateCoverCharge() {
//     if (widget.standardTablePrice == null) return 0;
//     final numericValue = double.tryParse(
//       widget.standardTablePrice!.replaceAll('₹', '').replaceAll(',', ''),
//     );
//     return (numericValue ?? 0) / 20 * guests;
//   }

//   Future<void> _confirmBooking() async {
//     if (selectedDate == null ||
//         selectedMealType == null ||
//         selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select date, meal type and time')),
//       );
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance.collection('restaurant_bookings').add({
//         'restaurantId': widget.restaurantId,
//         'restaurantName': widget.restaurantName,
//         'date': Timestamp.fromDate(selectedDate!),
//         'time': selectedTime!.format(context),
//         'mealType': selectedMealType,
//         'guests': guests,
//         'useOffer': useOffer,
//         'coverCharge': calculateCoverCharge(),
//         'standardTablePrice': widget.standardTablePrice,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Booking confirmed!')));
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     final coverCharge = calculateCoverCharge();
//     final formattedDate =
//         selectedDate == null
//             ? 'Select Date'
//             : DateFormat('EEE, MMM d').format(selectedDate!);

//     return Scaffold(
//       appBar: AppBar(title: Text('Book Table - ${widget.restaurantName}')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Number of Guests
//             const Text(
//               'Number of guest(s)',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: List.generate(20, (index) {
//                 final count = index + 1;
//                 return ChoiceChip(
//                   label: Text(count.toString()),
//                   selected: guests == count,
//                   onSelected: (selected) => setState(() => guests = count),
//                 );
//               }),
//             ),
//             const SizedBox(height: 24),

//             // Date Selection
//             const Text(
//               'When are you visiting?',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => _selectDate(context),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: Text(formattedDate, style: const TextStyle(fontSize: 16)),
//             ),
//             const SizedBox(height: 24),

//             // Meal Type Selection
//             if (selectedDate != null) ...[
//               const Text(
//                 'Select Time of Day',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               if (operatingHours != null)
//                 Row(
//                   children:
//                       operatingHours!.keys.map((type) {
//                         return Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4),
//                             child: ChoiceChip(
//                               label: Text(type),
//                               selected: selectedMealType == type,
//                               onSelected:
//                                   (selected) => setState(() {
//                                     selectedMealType = type;
//                                     selectedTime = null;
//                                   }),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               const SizedBox(height: 16),

//               // Time Slots with Offers
//               if (selectedMealType != null &&
//                   timeSlots[selectedMealType] != null) ...[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       selectedMealType!,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${operatingHours![selectedMealType]!['start']} to ${operatingHours![selectedMealType]!['end']}',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Select the time of day to see the offers',
//                       style: TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 8),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             childAspectRatio: 2.5,
//                             mainAxisSpacing: 8,
//                             crossAxisSpacing: 8,
//                           ),
//                       itemCount: timeSlots[selectedMealType]!.length,
//                       itemBuilder: (context, index) {
//                         final time = timeSlots[selectedMealType]![index];
//                         return Card(
//                           elevation: 2,
//                           child: InkWell(
//                             onTap: () {
//                               final parts = time.split(':');
//                               final hour = int.parse(parts[0]);
//                               final minute = int.parse(parts[1].split(' ')[0]);
//                               setState(() {
//                                 selectedTime = TimeOfDay(
//                                   hour: hour,
//                                   minute: minute,
//                                 );
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color:
//                                     selectedTime != null &&
//                                             selectedTime!.format(context) ==
//                                                 time
//                                         ? Colors.orangeAccent.withOpacity(0.2)
//                                         : Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     time,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const Text(
//                                     '10% off',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ],

//             // Offers Section
//             const Text(
//               'Choose an offer',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Card(
//               child: RadioListTile<bool>(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'FLAT 10% OFF',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       '₹${coverCharge.toStringAsFixed(0)} cover charge required',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//                 value: true,
//                 groupValue: useOffer,
//                 onChanged: (value) => setState(() => useOffer = value ?? false),
//               ),
//             ),
//             Card(
//               child: RadioListTile<bool>(
//                 title: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'NO OFFER',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       'Regular table reservation',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 value: false,
//                 groupValue: useOffer,
//                 onChanged: (value) => setState(() => useOffer = value ?? false),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Confirm Button
//             ElevatedButton(
//               onPressed: _confirmBooking,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text(
//                 'Confirm Booking',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//restaurant_booking.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RestaurantBookingPage extends StatefulWidget {
//   final String restaurantId;
//   final String? standardTablePrice;

//   const RestaurantBookingPage({
//     super.key,
//     required this.restaurantId,
//     required this.standardTablePrice,
//   });

//   @override
//   State<RestaurantBookingPage> createState() => _RestaurantBookingPageState();
// }

// class _RestaurantBookingPageState extends State<RestaurantBookingPage> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   int guests = 1;
//   String? selectedMealType;
//   bool useOffer = false;
//   Map<String, Map<String, String>>? operatingHours;
//   Map<String, List<String>> timeSlots = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchOperatingHours();
//   }

//   // Future<void> _fetchOperatingHours() async {
//   //   try {
//   //     final doc = await FirebaseFirestore.instance
//   //         .collection('restaurant_bookings') // Note: 3 'a's
//   //         .doc(widget.restaurantId)
//   //         .get()
//   //         .timeout(const Duration(seconds: 10));

//   //     if (!mounted) return;

//   //     if (!doc.exists) {
//   //       throw Exception(
//   //         "Document for restaurant ${widget.restaurantId} not found",
//   //       );
//   //     }

//   //     final data = doc.data();
//   //     if (data == null || data['operatingHours'] == null) {
//   //       throw Exception("Operating hours data is missing");
//   //     }

//   //     // Convert all time values to HH:MM format
//   //     final Map<String, dynamic> convertedHours = {};
//   //     final Map<String, dynamic> hours = data['operatingHours'];

//   //     hours.forEach((mealType, times) {
//   //       convertedHours[mealType] = {
//   //         'start': _formatTime(times['start']),
//   //         'end': _formatTime(times['end']),
//   //       };
//   //     });

//   //     setState(() {
//   //       operatingHours = Map<String, Map<String, String>>.from(convertedHours);
//   //       _generateTimeSlots();
//   //       isLoading = false;
//   //     });
//   //   } catch (e) {
//   //     if (!mounted) return;
//   //     setState(() => isLoading = false);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text('Error: ${e.toString()}'),
//   //         action: SnackBarAction(
//   //           label: 'Retry',
//   //           onPressed: _fetchOperatingHours,
//   //         ),
//   //       ),
//   //     );
//   //     debugPrint('Error fetching operating hours: $e');
//   //   }
//   // }
//   Future<void> _fetchOperatingHours() async {
//     try {
//       // First try to get from restaurant_details (primary source)
//       final detailsDoc = await FirebaseFirestore.instance
//           .collection('restaurant_details')
//           .doc(widget.restaurantId)
//           .get()
//           .timeout(const Duration(seconds: 10));

//       if (!mounted) return;

//       Map<String, dynamic>? operatingHoursData;

//       if (detailsDoc.exists && detailsDoc.data()?['operatingHours'] != null) {
//         operatingHoursData = detailsDoc.data()?['operatingHours'];
//         debugPrint('Found operating hours in restaurant_details');
//       } else {
//         // Fallback to restaurant_bookings (legacy/backup)
//         final bookingsDoc = await FirebaseFirestore.instance
//             .collection('restaurant_bookings')
//             .doc(widget.restaurantId)
//             .get()
//             .timeout(const Duration(seconds: 5));

//         if (bookingsDoc.exists &&
//             bookingsDoc.data()?['operatingHours'] != null) {
//           operatingHoursData = bookingsDoc.data()?['operatingHours'];
//           debugPrint('Found operating hours in restaurant_bookings (fallback)');

//           // Migrate to restaurant_details if missing
//           if (detailsDoc.exists) {
//             await FirebaseFirestore.instance
//                 .collection('restaurant_details')
//                 .doc(widget.restaurantId)
//                 .set({
//                   'operatingHours': operatingHoursData,
//                 }, SetOptions(merge: true));
//           }
//         }
//       }

//       if (operatingHoursData == null) {
//         throw Exception("Operating hours data not found in either collection");
//       }

//       // Convert all time values to HH:MM format
//       final Map<String, dynamic> convertedHours = {};

//       operatingHoursData.forEach((mealType, times) {
//         convertedHours[mealType] = {
//           'start': _formatTime(times['start']),
//           'end': _formatTime(times['end']),
//         };
//       });

//       setState(() {
//         operatingHours = Map<String, Map<String, String>>.from(convertedHours);
//         _generateTimeSlots();
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           action: SnackBarAction(
//             label: 'Retry',
//             onPressed: _fetchOperatingHours,
//           ),
//         ),
//       );
//       debugPrint('Error fetching operating hours: $e');
//     }
//   }

//   String _formatTime(String time) {
//     if (time.contains(':')) return time;
//     if (time.length == 4) {
//       return '${time.substring(0, 2)}:${time.substring(2)}';
//     }
//     return time; // fallback
//   }

//   // Future<void> _updateOperatingHours() async {
//   //   if (operatingHours == null) return;

//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection('restaurant_bookings')
//   //         .doc(widget.restaurantId)
//   //         .set({
//   //           'operatingHours': operatingHours,
//   //           'mealType': selectedMealType,
//   //           'guests': guests,
//   //         }, SetOptions(merge: true));
//   //   } catch (e) {
//   //     debugPrint('Error updating operating hours: $e');
//   //   }
//   // }
//   Future<void> _updateOperatingHours() async {
//     if (operatingHours == null) return;

//     try {
//       // Update both collections
//       final batch = FirebaseFirestore.instance.batch();

//       // Primary update to restaurant_details
//       final detailsRef = FirebaseFirestore.instance
//           .collection('restaurant_details')
//           .doc(widget.restaurantId);

//       batch.set(detailsRef, {
//         'operatingHours': operatingHours,
//       }, SetOptions(merge: true));

//       // Secondary update to restaurant_bookings (for backward compatibility)
//       final bookingsRef = FirebaseFirestore.instance
//           .collection('restaurant_bookings')
//           .doc(widget.restaurantId);

//       batch.set(bookingsRef, {
//         'operatingHours': operatingHours,
//         'mealType': selectedMealType,
//         'guests': guests,
//       }, SetOptions(merge: true));

//       await batch.commit();
//     } catch (e) {
//       debugPrint('Error updating operating hours: $e');
//     }
//   }
//   // void _generateTimeSlots() {
//   //   if (operatingHours == null) return;

//   //   timeSlots.clear();

//   //   operatingHours!.forEach((mealType, hours) {
//   //     final startTime = hours['start']!.split(':');
//   //     final endTime = hours['end']!.split(':');

//   //     final startHour = int.parse(startTime[0]);
//   //     final startMinute = int.parse(startTime[1]);
//   //     final endHour = int.parse(endTime[0]);
//   //     final endMinute = int.parse(endTime[1]);

//   //     final slots = <String>[];
//   //     DateTime currentTime = DateTime(2023, 1, 1, startHour, startMinute);
//   //     final endDateTime = DateTime(2023, 1, 1, endHour, endMinute);

//   //     while (currentTime.isBefore(endDateTime)) {
//   //       slots.add(DateFormat('h:mm a').format(currentTime));
//   //       currentTime = currentTime.add(const Duration(minutes: 15));
//   //     }

//   //     timeSlots[mealType] = slots;
//   //   });
//   // }
//   // void _generateTimeSlots() {
//   //   if (operatingHours == null) return;

//   //   timeSlots.clear();

//   //   operatingHours!.forEach((mealType, hours) {
//   //     try {
//   //       // Handle both '1130' and '11:30' formats
//   //       String formatTime(String time) {
//   //         if (time.contains(':')) return time;
//   //         if (time.length == 4) {
//   //           return '${time.substring(0, 2)}:${time.substring(2)}';
//   //         }
//   //         return time;
//   //       }

//   //       final startStr = formatTime(hours['start']!);
//   //       final endStr = formatTime(hours['end']!);

//   //       final startTime = startStr.split(':');
//   //       final endTime = endStr.split(':');

//   //       final startHour = int.parse(startTime[0]);
//   //       final startMinute = int.parse(startTime[1]);
//   //       final endHour = int.parse(endTime[0]);
//   //       final endMinute = int.parse(endTime[1]);

//   //       final slots = <String>[];
//   //       DateTime currentTime = DateTime(2023, 1, 1, startHour, startMinute);
//   //       final endDateTime = DateTime(2023, 1, 1, endHour, endMinute);

//   //       while (currentTime.isBefore(endDateTime)) {
//   //         slots.add(DateFormat('h:mm a').format(currentTime));
//   //         currentTime = currentTime.add(const Duration(minutes: 15));
//   //       }

//   //       timeSlots[mealType] = slots;
//   //     } catch (e) {
//   //       debugPrint('Error generating slots for $mealType: $e');
//   //     }
//   //   });
//   // }
//   void _generateTimeSlots() {
//     if (operatingHours == null) return;

//     timeSlots.clear();

//     operatingHours!.forEach((mealType, hours) {
//       try {
//         final start = hours['start']!;
//         final end = hours['end']!;

//         final startParts = start.split(':');
//         final endParts = end.split(':');

//         final startHour = int.parse(startParts[0]);
//         final startMinute = int.parse(startParts[1]);
//         final endHour = int.parse(endParts[0]);
//         final endMinute = int.parse(endParts[1]);

//         final slots = <String>[];
//         DateTime currentTime = DateTime(2023, 1, 1, startHour, startMinute);
//         final endDateTime = DateTime(2023, 1, 1, endHour, endMinute);

//         while (currentTime.isBefore(endDateTime)) {
//           slots.add(DateFormat('h:mm a').format(currentTime));
//           currentTime = currentTime.add(const Duration(minutes: 15));
//         }

//         timeSlots[mealType] = slots;
//       } catch (e) {
//         debugPrint('Error generating slots for $mealType: $e');
//       }
//     });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         selectedTime = null;
//         selectedMealType = null;
//       });
//       await _updateOperatingHours();
//     }
//   }

//   double calculateCoverCharge() {
//     if (widget.standardTablePrice == null) return 0;
//     final numericValue = double.tryParse(
//       widget.standardTablePrice!.replaceAll('₹', '').replaceAll(',', ''),
//     );
//     return (numericValue ?? 0) / 20 * guests;
//   }

//   Future<void> _confirmBooking() async {
//     if (selectedDate == null ||
//         selectedMealType == null ||
//         selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select date, meal type and time')),
//       );
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance.collection('restaurant_bookings').add({
//         'restaurantId': widget.restaurantId,
//         'date': Timestamp.fromDate(selectedDate!),
//         'time': selectedTime!.format(context),
//         'mealType': selectedMealType,
//         'guests': guests,
//         'useOffer': useOffer,
//         'coverCharge': calculateCoverCharge(),
//         'standardTablePrice': widget.standardTablePrice,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       // Update the operating hours in restaurant_bookings
//       await _updateOperatingHours();

//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Booking confirmed!')));
//       // ignore: use_build_context_synchronously
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (selectedDate != null) {
//       debugPrint('Operating Hours: $operatingHours');
//       debugPrint('Generated Time Slots: $timeSlots');
//       debugPrint('Selected Meal Type: $selectedMealType');
//     }

//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     final coverCharge = calculateCoverCharge();
//     final formattedDate =
//         selectedDate == null
//             ? 'Select Date'
//             : DateFormat('EEE, MMM d').format(selectedDate!);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Book Table')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Number of Guests
//             const Text(
//               'Number of guest(s)',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: List.generate(20, (index) {
//                 final count = index + 1;
//                 return ChoiceChip(
//                   label: Text(count.toString()),
//                   selected: guests == count,
//                   onSelected: (selected) {
//                     setState(() => guests = count);
//                     _updateOperatingHours();
//                   },
//                 );
//               }),
//             ),
//             const SizedBox(height: 24),

//             // Date Selection
//             const Text(
//               'When are you visiting?',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => _selectDate(context),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: Text(formattedDate, style: const TextStyle(fontSize: 16)),
//             ),
//             const SizedBox(height: 24),

//             // Meal Type Selection
//             if (selectedDate != null) ...[
//               const Text(
//                 'Select Time of Day',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               if (operatingHours != null)
//                 Row(
//                   children:
//                       operatingHours!.keys.map((type) {
//                         return Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4),
//                             child: ChoiceChip(
//                               label: Text(type),
//                               selected: selectedMealType == type,
//                               onSelected: (selected) async {
//                                 setState(() {
//                                   selectedMealType = type;
//                                   selectedTime = null;
//                                 });
//                                 await _updateOperatingHours();
//                               },
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               const SizedBox(height: 16),

//               // Time Slots with Offers
//               if (selectedMealType != null &&
//                   timeSlots[selectedMealType] != null) ...[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       selectedMealType!,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${operatingHours![selectedMealType]!['start']} to ${operatingHours![selectedMealType]!['end']}',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Select the time of day to see the offers',
//                       style: TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 8),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             childAspectRatio: 2.5,
//                             mainAxisSpacing: 8,
//                             crossAxisSpacing: 8,
//                           ),
//                       itemCount: timeSlots[selectedMealType]!.length,
//                       itemBuilder: (context, index) {
//                         final time = timeSlots[selectedMealType]![index];
//                         return Card(
//                           elevation: 2,
//                           child: InkWell(
//                             onTap: () {
//                               final parts = time.split(':');
//                               final hour = int.parse(parts[0]);
//                               final minute = int.parse(parts[1].split(' ')[0]);
//                               setState(() {
//                                 selectedTime = TimeOfDay(
//                                   hour: hour,
//                                   minute: minute,
//                                 );
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color:
//                                     selectedTime != null &&
//                                             selectedTime!.format(context) ==
//                                                 time
//                                         ? Colors.orangeAccent.withOpacity(0.2)
//                                         : Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     time,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const Text(
//                                     '10% off',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ],

//             // Offers Section
//             const Text(
//               'Choose an offer',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Card(
//               child: RadioListTile<bool>(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'FLAT 10% OFF',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       '₹${coverCharge.toStringAsFixed(0)} cover charge required',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//                 value: true,
//                 groupValue: useOffer,
//                 onChanged: (value) => setState(() => useOffer = value ?? false),
//               ),
//             ),
//             Card(
//               child: RadioListTile<bool>(
//                 title: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'NO OFFER',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       'Regular table reservation',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 value: false,
//                 groupValue: useOffer,
//                 onChanged: (value) => setState(() => useOffer = value ?? false),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Confirm Button
//             ElevatedButton(
//               onPressed: _confirmBooking,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text(
//                 'Confirm Booking',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//restaurant_booking.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RestaurantBookingPage extends StatefulWidget {
//   final String restaurantId;
//   final String? standardTablePrice;

//   const RestaurantBookingPage({
//     super.key,
//     required this.restaurantId,
//     required this.standardTablePrice,
//   });

//   @override
//   State<RestaurantBookingPage> createState() => _RestaurantBookingPageState();
// }

// class _RestaurantBookingPageState extends State<RestaurantBookingPage> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   int guests = 1;
//   String? selectedMealType;
//   bool useOffer = false;
//   Map<String, Map<String, String>>? operatingHours;
//   Map<String, List<String>> timeSlots = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchOperatingHours();
//   }

//   Future<void> _fetchOperatingHours() async {
//     try {
//       // First try to get from restaurant_details (primary source)
//       final detailsDoc = await FirebaseFirestore.instance
//           .collection('restaurant_details')
//           .doc(widget.restaurantId)
//           .get()
//           .timeout(const Duration(seconds: 10));

//       if (!mounted) return;

//       Map<String, dynamic>? operatingHoursData;

//       if (detailsDoc.exists && detailsDoc.data()?['operatingHours'] != null) {
//         operatingHoursData = detailsDoc.data()?['operatingHours'];
//         debugPrint('Found operating hours in restaurant_details');
//       } else {
//         // Fallback to restaurant_bookings (legacy/backup)
//         final bookingsDoc = await FirebaseFirestore.instance
//             .collection('restaurant_bookings')
//             .doc(widget.restaurantId)
//             .get()
//             .timeout(const Duration(seconds: 5));

//         if (bookingsDoc.exists &&
//             bookingsDoc.data()?['operatingHours'] != null) {
//           operatingHoursData = bookingsDoc.data()?['operatingHours'];
//           debugPrint('Found operating hours in restaurant_bookings (fallback)');

//           // Migrate to restaurant_details if missing
//           if (detailsDoc.exists) {
//             await FirebaseFirestore.instance
//                 .collection('restaurant_details')
//                 .doc(widget.restaurantId)
//                 .set({
//                   'operatingHours': operatingHoursData,
//                 }, SetOptions(merge: true));
//           }
//         }
//       }

//       if (operatingHoursData == null) {
//         throw Exception("Operating hours data not found in either collection");
//       }

//       // Convert all time values to HH:MM format
//       final Map<String, dynamic> convertedHours = {};

//       operatingHoursData.forEach((mealType, times) {
//         convertedHours[mealType] = {
//           'start': _formatTime(times['start']),
//           'end': _formatTime(times['end']),
//         };
//       });

//       setState(() {
//         operatingHours = Map<String, Map<String, String>>.from(convertedHours);
//         _generateTimeSlots();
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           action: SnackBarAction(
//             label: 'Retry',
//             onPressed: _fetchOperatingHours,
//           ),
//         ),
//       );
//       debugPrint('Error fetching operating hours: $e');
//     }
//   }

//   String _formatTime(String time) {
//     if (time.contains(':')) return time;
//     if (time.length == 4) {
//       return '${time.substring(0, 2)}:${time.substring(2)}';
//     }
//     return time; // fallback
//   }

//   // Future<void> _updateOperatingHours() async {
//   //   if (operatingHours == null) return;

//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection('restaurant_bookings')
//   //         .doc(widget.restaurantId)
//   //         .set({
//   //           'operatingHours': operatingHours,
//   //           'mealType': selectedMealType,
//   //           'guests': guests,
//   //         }, SetOptions(merge: true));
//   //   } catch (e) {
//   //     debugPrint('Error updating operating hours: $e');
//   //   }
//   // }
//   Future<void> _updateOperatingHours() async {
//     if (operatingHours == null) return;

//     try {
//       // Update both collections
//       final batch = FirebaseFirestore.instance.batch();

//       // Primary update to restaurant_details
//       final detailsRef = FirebaseFirestore.instance
//           .collection('restaurant_details')
//           .doc(widget.restaurantId);

//       batch.set(detailsRef, {
//         'operatingHours': operatingHours,
//       }, SetOptions(merge: true));

//       // Secondary update to restaurant_bookings (for backward compatibility)
//       final bookingsRef = FirebaseFirestore.instance
//           .collection('restaurant_bookings')
//           .doc(widget.restaurantId);

//       batch.set(bookingsRef, {
//         'operatingHours': operatingHours,
//         'mealType': selectedMealType,
//         'guests': guests,
//       }, SetOptions(merge: true));

//       await batch.commit();
//     } catch (e) {
//       debugPrint('Error updating operating hours: $e');
//     }
//   }

//   void _generateTimeSlots() {
//     if (operatingHours == null) return;

//     timeSlots.clear();

//     operatingHours!.forEach((mealType, hours) {
//       try {
//         final start = hours['start']!;
//         final end = hours['end']!;

//         final startParts = start.split(':');
//         final endParts = end.split(':');

//         final startHour = int.parse(startParts[0]);
//         final startMinute = int.parse(startParts[1]);
//         final endHour = int.parse(endParts[0]);
//         final endMinute = int.parse(endParts[1]);

//         final slots = <String>[];
//         DateTime currentTime = DateTime(2023, 1, 1, startHour, startMinute);
//         final endDateTime = DateTime(2023, 1, 1, endHour, endMinute);

//         while (currentTime.isBefore(endDateTime)) {
//           slots.add(DateFormat('h:mm a').format(currentTime));
//           currentTime = currentTime.add(const Duration(minutes: 15));
//         }

//         timeSlots[mealType] = slots;
//       } catch (e) {
//         debugPrint('Error generating slots for $mealType: $e');
//       }
//     });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         selectedTime = null;
//         selectedMealType = null;
//       });
//       await _updateOperatingHours();
//     }
//   }

//   double calculateCoverCharge() {
//     if (widget.standardTablePrice == null) return 0.0;

//     try {
//       // Remove any currency symbols and commas
//       final numericString =
//           widget.standardTablePrice!
//               .replaceAll('₹', '')
//               .replaceAll(',', '')
//               .trim();

//       final numericValue = double.tryParse(numericString) ?? 0.0;
//       return (numericValue / 20) * guests;
//     } catch (e) {
//       debugPrint('Error calculating cover charge: $e');
//       return 0.0;
//     }
//   }

//   Future<void> _confirmBooking() async {
//     if (selectedDate == null ||
//         selectedMealType == null ||
//         selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select date, meal type and time')),
//       );
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance.collection('restaurant_bookings').add({
//         'restaurantId': widget.restaurantId,
//         'date': Timestamp.fromDate(selectedDate!),
//         'time': selectedTime!.format(context),
//         'mealType': selectedMealType,
//         'guests': guests,
//         'useOffer': useOffer,
//         'coverCharge': calculateCoverCharge(),
//         'standardTablePrice': widget.standardTablePrice,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       // Update the operating hours in restaurant_bookings
//       await _updateOperatingHours();

//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Booking confirmed!')));
//       // ignore: use_build_context_synchronously
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (selectedDate != null) {
//       debugPrint('Operating Hours: $operatingHours');
//       debugPrint('Generated Time Slots: $timeSlots');
//       debugPrint('Selected Meal Type: $selectedMealType');
//     }

//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     // Calculate cover charge based on standardTablePrice
//     final coverCharge = calculateCoverCharge();
//     final formattedDate =
//         selectedDate == null
//             ? 'Select Date'
//             : DateFormat('EEE, MMM d').format(selectedDate!);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Book Table')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Number of Guests
//             const Text(
//               'Number of guest(s)',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: List.generate(20, (index) {
//                 final count = index + 1;
//                 return ChoiceChip(
//                   label: Text(count.toString()),
//                   selected: guests == count,
//                   onSelected: (selected) {
//                     setState(() => guests = count);
//                     _updateOperatingHours();
//                   },
//                 );
//               }),
//             ),
//             const SizedBox(height: 24),

//             // Date Selection
//             const Text(
//               'When are you visiting?',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => _selectDate(context),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: Text(formattedDate, style: const TextStyle(fontSize: 16)),
//             ),
//             const SizedBox(height: 24),

//             // Meal Type Selection
//             if (selectedDate != null) ...[
//               const Text(
//                 'Select Time of Day',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               if (operatingHours != null)
//                 SizedBox(
//                   height: 50, // Fixed height for the scrollable row
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children:
//                           operatingHours!.keys.map((type) {
//                             return Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 4),
//                               child: ChoiceChip(
//                                 label: Text(type),
//                                 selected: selectedMealType == type,
//                                 onSelected: (selected) async {
//                                   setState(() {
//                                     selectedMealType = type;
//                                     selectedTime = null;
//                                   });
//                                   await _updateOperatingHours();
//                                 },
//                               ),
//                             );
//                           }).toList(),
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 16),

//               // Time Slots with Offers
//               if (selectedMealType != null &&
//                   timeSlots[selectedMealType] != null) ...[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       selectedMealType!,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${operatingHours![selectedMealType]!['start']} to ${operatingHours![selectedMealType]!['end']}',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                     const SizedBox(height: 8),
//                     // In the GridView.builder for time slots (inside the build method)
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             childAspectRatio:
//                                 2.2, // Adjusted for better text visibility
//                             mainAxisSpacing: 8,
//                             crossAxisSpacing: 8,
//                           ),
//                       itemCount: timeSlots[selectedMealType]!.length,
//                       itemBuilder: (context, index) {
//                         final time = timeSlots[selectedMealType]![index];
//                         final timeParts = time.split(' ');
//                         final hourMinute = timeParts[0].split(':');
//                         final period = timeParts[1];

//                         // Convert to 24-hour format for comparison
//                         var hour = int.parse(hourMinute[0]);
//                         final minute = int.parse(hourMinute[1]);
//                         if (period == 'PM' && hour != 12) hour += 12;
//                         if (period == 'AM' && hour == 12) hour = 0;

//                         final isSelected =
//                             selectedTime != null &&
//                             selectedTime!.hour == hour &&
//                             selectedTime!.minute == minute;

//                         return Card(
//                           elevation: 2,
//                           margin: EdgeInsets.zero, // Remove default card margin
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(
//                               8,
//                             ), // Match card radius
//                             onTap: () {
//                               setState(() {
//                                 selectedTime = TimeOfDay(
//                                   hour: hour,
//                                   minute: minute,
//                                 );
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 12,
//                               ), // More vertical padding
//                               decoration: BoxDecoration(
//                                 color:
//                                     isSelected
//                                         // ignore: deprecated_member_use
//                                         ? Colors.orangeAccent.withOpacity(0.2)
//                                         : Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border:
//                                     isSelected
//                                         ? Border.all(
//                                           color: Colors.orangeAccent,
//                                           width: 2,
//                                         )
//                                         : null,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   time,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14, // Slightly smaller font
//                                     color:
//                                         isSelected
//                                             ? Colors.orange[800]
//                                             : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ],

//             // Offers Section
//             const Text(
//               'Choose an offer',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Card(
//               child: RadioListTile<bool>(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'FLAT 10% OFF',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       '₹${coverCharge.toStringAsFixed(0)} cover charge required',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//                 value: true,
//                 groupValue: useOffer,
//                 onChanged: (value) => setState(() => useOffer = value ?? false),
//               ),
//             ),
//             Card(
//               child: RadioListTile<bool>(
//                 title: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'NO OFFER',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       'Regular table reservation',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 value: false,
//                 groupValue: useOffer,
//                 onChanged: (value) => setState(() => useOffer = value ?? false),
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Confirm Button
//             ElevatedButton(
//               onPressed: _confirmBooking,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text(
//                 'Confirm Booking',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //restaurant_booking.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RestaurantBookingPage extends StatefulWidget {
//   final String restaurantId;
//   final String? standardTablePrice;

//   const RestaurantBookingPage({
//     super.key,
//     required this.restaurantId,
//     required this.standardTablePrice,
//   });

//   @override
//   State<RestaurantBookingPage> createState() => _RestaurantBookingPageState();
// }

// class _RestaurantBookingPageState extends State<RestaurantBookingPage> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   int guests = 1;
//   String? selectedMealType;
//   bool useOffer = false;
//   Map<String, Map<String, String>>? operatingHours;
//   Map<String, List<String>> timeSlots = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     debugPrint('Initial standardTablePrice: ${widget.standardTablePrice}');
//     _fetchOperatingHours();
//   }

//   Future<void> _fetchOperatingHours() async {
//     try {
//       // First try to get from restaurant_details (primary source)
//       final detailsDoc = await FirebaseFirestore.instance
//           .collection('restaurant_details')
//           .doc(widget.restaurantId)
//           .get()
//           .timeout(const Duration(seconds: 10));

//       if (!mounted) return;

//       Map<String, dynamic>? operatingHoursData;

//       if (detailsDoc.exists && detailsDoc.data()?['operatingHours'] != null) {
//         operatingHoursData = detailsDoc.data()?['operatingHours'];
//         debugPrint('Found operating hours in restaurant_details');
//       } else {
//         // Fallback to restaurant_bookings (legacy/backup)
//         final bookingsDoc = await FirebaseFirestore.instance
//             .collection('restaurant_bookings')
//             .doc(widget.restaurantId)
//             .get()
//             .timeout(const Duration(seconds: 5));

//         if (bookingsDoc.exists &&
//             bookingsDoc.data()?['operatingHours'] != null) {
//           operatingHoursData = bookingsDoc.data()?['operatingHours'];
//           debugPrint('Found operating hours in restaurant_bookings (fallback)');

//           // Migrate to restaurant_details if missing
//           if (detailsDoc.exists) {
//             await FirebaseFirestore.instance
//                 .collection('restaurant_details')
//                 .doc(widget.restaurantId)
//                 .set({
//                   'operatingHours': operatingHoursData,
//                 }, SetOptions(merge: true));
//           }
//         }
//       }

//       if (operatingHoursData == null) {
//         throw Exception("Operating hours data not found in either collection");
//       }

//       // Convert all time values to HH:MM format
//       final Map<String, dynamic> convertedHours = {};

//       operatingHoursData.forEach((mealType, times) {
//         convertedHours[mealType] = {
//           'start': _formatTime(times['start']),
//           'end': _formatTime(times['end']),
//         };
//       });

//       setState(() {
//         operatingHours = Map<String, Map<String, String>>.from(convertedHours);
//         _generateTimeSlots();
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           action: SnackBarAction(
//             label: 'Retry',
//             onPressed: _fetchOperatingHours,
//           ),
//         ),
//       );
//       debugPrint('Error fetching operating hours: $e');
//     }
//   }

//   String _formatTime(String time) {
//     if (time.contains(':')) return time;
//     if (time.length == 4) {
//       return '${time.substring(0, 2)}:${time.substring(2)}';
//     }
//     return time; // fallback
//   }

//   Future<void> _updateOperatingHours() async {
//     if (operatingHours == null) return;

//     try {
//       // Update both collections
//       final batch = FirebaseFirestore.instance.batch();

//       // Primary update to restaurant_details
//       final detailsRef = FirebaseFirestore.instance
//           .collection('restaurant_details')
//           .doc(widget.restaurantId);

//       batch.set(detailsRef, {
//         'operatingHours': operatingHours,
//       }, SetOptions(merge: true));

//       // Secondary update to restaurant_bookings (for backward compatibility)
//       final bookingsRef = FirebaseFirestore.instance
//           .collection('restaurant_bookings')
//           .doc(widget.restaurantId);

//       batch.set(bookingsRef, {
//         'operatingHours': operatingHours,
//         'mealType': selectedMealType,
//         'guests': guests,
//       }, SetOptions(merge: true));

//       await batch.commit();
//     } catch (e) {
//       debugPrint('Error updating operating hours: $e');
//     }
//   }

//   void _generateTimeSlots() {
//     if (operatingHours == null) return;

//     timeSlots.clear();

//     operatingHours!.forEach((mealType, hours) {
//       try {
//         final start = hours['start']!;
//         final end = hours['end']!;

//         final startParts = start.split(':');
//         final endParts = end.split(':');

//         final startHour = int.parse(startParts[0]);
//         final startMinute = int.parse(startParts[1]);
//         final endHour = int.parse(endParts[0]);
//         final endMinute = int.parse(endParts[1]);

//         final slots = <String>[];
//         DateTime currentTime = DateTime(2023, 1, 1, startHour, startMinute);
//         final endDateTime = DateTime(2023, 1, 1, endHour, endMinute);

//         while (currentTime.isBefore(endDateTime)) {
//           slots.add(DateFormat('h:mm a').format(currentTime));
//           currentTime = currentTime.add(const Duration(minutes: 15));
//         }

//         timeSlots[mealType] = slots;
//       } catch (e) {
//         debugPrint('Error generating slots for $mealType: $e');
//       }
//     });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         selectedTime = null;
//         selectedMealType = null;
//       });
//       await _updateOperatingHours();
//     }
//   }

//   double calculateCoverCharge() {
//     if (widget.standardTablePrice == null) {
//       debugPrint('Standard table price is null in booking page');
//       return 0.0;
//     }

//     try {
//       // Extract just the numeric part from "1000 for 2"
//       final numericString =
//           widget.standardTablePrice!
//               .split(' ')[0] // Takes the first part before space
//               .replaceAll('₹', '')
//               .replaceAll(',', '')
//               .trim();

//       debugPrint('Extracted numeric value: $numericString');

//       final numericValue = double.tryParse(numericString) ?? 0.0;
//       debugPrint('Parsed numeric value: $numericValue');

//       // Calculate base charge per person (1000/20 = 50)
//       final baseCharge = numericValue / 20;
//       // Apply to number of guests
//       final charge = baseCharge * guests;
//       debugPrint('Calculated cover charge: $charge');
//       return charge;
//     } catch (e) {
//       debugPrint('Error calculating cover charge: $e');
//       return 0.0;
//     }
//   }

//   Future<void> _confirmBooking() async {
//     if (selectedDate == null ||
//         selectedMealType == null ||
//         selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select date, meal type and time')),
//       );
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance.collection('restaurant_bookings').add({
//         'restaurantId': widget.restaurantId,
//         'date': Timestamp.fromDate(selectedDate!),
//         'time': selectedTime!.format(context),
//         'mealType': selectedMealType,
//         'guests': guests,
//         'useOffer': useOffer,
//         'coverCharge': calculateCoverCharge(),
//         'standardTablePrice': 1000,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       // Update the operating hours in restaurant_bookings
//       await _updateOperatingHours();

//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Booking confirmed!')));
//       // ignore: use_build_context_synchronously
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (selectedDate != null) {
//       debugPrint('Operating Hours: $operatingHours');
//       debugPrint('Generated Time Slots: $timeSlots');
//       debugPrint('Selected Meal Type: $selectedMealType');
//     }

//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     // Calculate cover charge based on standardTablePrice and number of guests
//     // final coverCharge = calculateCoverCharge();
//     final formattedDate =
//         selectedDate == null
//             ? 'Select Date'
//             : DateFormat('EEE, MMM d').format(selectedDate!);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Book Table')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Number of Guests
//             const Text(
//               'Number of guest(s)',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),

//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: List.generate(20, (index) {
//                 final count = index + 1;
//                 return ChoiceChip(
//                   label: Text(count.toString()),
//                   selected: guests == count,
//                   onSelected: (selected) {
//                     setState(() {
//                       guests = count;
//                       _updateOperatingHours();
//                     });
//                     debugPrint('Guests changed to: $guests');
//                   },
//                 );
//               }),
//             ),
//             const SizedBox(height: 24),

//             // Date Selection
//             const Text(
//               'When are you visiting?',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => _selectDate(context),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: Text(formattedDate, style: const TextStyle(fontSize: 16)),
//             ),
//             const SizedBox(height: 24),

//             // Meal Type Selection
//             if (selectedDate != null) ...[
//               const Text(
//                 'Select Time of Day',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               if (operatingHours != null)
//                 SizedBox(
//                   height: 50, // Fixed height for the scrollable row
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children:
//                           operatingHours!.keys.map((type) {
//                             return Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 4),
//                               child: ChoiceChip(
//                                 label: Text(type),
//                                 selected: selectedMealType == type,
//                                 onSelected: (selected) async {
//                                   setState(() {
//                                     selectedMealType = type;
//                                     selectedTime = null;
//                                   });
//                                   await _updateOperatingHours();
//                                 },
//                               ),
//                             );
//                           }).toList(),
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 16),

//               // Time Slots with Offers
//               if (selectedMealType != null &&
//                   timeSlots[selectedMealType] != null) ...[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       selectedMealType!,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${operatingHours![selectedMealType]!['start']} to ${operatingHours![selectedMealType]!['end']}',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                     const SizedBox(height: 8),
//                     // In the GridView.builder for time slots (inside the build method)
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             childAspectRatio:
//                                 2.2, // Adjusted for better text visibility
//                             mainAxisSpacing: 8,
//                             crossAxisSpacing: 8,
//                           ),
//                       itemCount: timeSlots[selectedMealType]!.length,
//                       itemBuilder: (context, index) {
//                         final time = timeSlots[selectedMealType]![index];
//                         final timeParts = time.split(' ');
//                         final hourMinute = timeParts[0].split(':');
//                         final period = timeParts[1];

//                         // Convert to 24-hour format for comparison
//                         var hour = int.parse(hourMinute[0]);
//                         final minute = int.parse(hourMinute[1]);
//                         if (period == 'PM' && hour != 12) hour += 12;
//                         if (period == 'AM' && hour == 12) hour = 0;

//                         final isSelected =
//                             selectedTime != null &&
//                             selectedTime!.hour == hour &&
//                             selectedTime!.minute == minute;

//                         return Card(
//                           elevation: 2,
//                           margin: EdgeInsets.zero, // Remove default card margin
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(
//                               8,
//                             ), // Match card radius
//                             onTap: () {
//                               setState(() {
//                                 selectedTime = TimeOfDay(
//                                   hour: hour,
//                                   minute: minute,
//                                 );
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 12,
//                               ), // More vertical padding
//                               decoration: BoxDecoration(
//                                 color:
//                                     isSelected
//                                         // ignore: deprecated_member_use
//                                         ? Colors.orangeAccent.withOpacity(0.2)
//                                         : Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border:
//                                     isSelected
//                                         ? Border.all(
//                                           color: Colors.orangeAccent,
//                                           width: 2,
//                                         )
//                                         : null,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   time,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14, // Slightly smaller font
//                                     color:
//                                         isSelected
//                                             ? Colors.orange[800]
//                                             : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ],

//             // Offers Section
//             const Text(
//               'Choose an offer',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),

//             Card(
//               child: RadioListTile<bool>(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'FLAT 10% OFF',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       '₹${calculateCoverCharge().toStringAsFixed(0)} cover charge (₹${(calculateCoverCharge() / guests).toStringAsFixed(0)} per person × $guests guest${guests > 1 ? 's' : ''})',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//                 value: true,
//                 groupValue: useOffer,
//                 onChanged: (value) => setState(() => useOffer = value ?? false),
//               ),
//             ),
//             Card(
//               child: RadioListTile<bool>(
//                 title: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'NO OFFER',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       'Regular table reservation',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 value: false,
//                 groupValue: useOffer,
//                 onChanged: (value) => setState(() => useOffer = value ?? false),
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Confirm Button
//             ElevatedButton(
//               onPressed: _confirmBooking,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text(
//                 'Confirm Booking',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//restaurant_booking.dart
import 'package:city_wheels/restaurants/payment_page.dart';
import 'package:city_wheels/restaurants/booking_confirmation_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantBookingPage extends StatefulWidget {
  final String restaurantId;
  final String? standardTablePrice;

  const RestaurantBookingPage({
    super.key,
    required this.restaurantId,
    required this.standardTablePrice,
    required Map<String, dynamic> restaurant,
  });

  @override
  State<RestaurantBookingPage> createState() => _RestaurantBookingPageState();
}

class _RestaurantBookingPageState extends State<RestaurantBookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int guests = 1;
  String? selectedMealType;
  bool useOffer = false;
  Map<String, Map<String, String>>? operatingHours;
  Map<String, List<String>> timeSlots = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    debugPrint('Initial standardTablePrice: ${widget.standardTablePrice}');
    _fetchOperatingHours();
  }

  Future<void> _fetchOperatingHours() async {
    try {
      // First try to get from restaurant_details (primary source)
      final detailsDoc = await FirebaseFirestore.instance
          .collection('restaurant_details')
          .doc(widget.restaurantId)
          .get()
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      Map<String, dynamic>? operatingHoursData;

      if (detailsDoc.exists && detailsDoc.data()?['operatingHours'] != null) {
        operatingHoursData = detailsDoc.data()?['operatingHours'];
        debugPrint('Found operating hours in restaurant_details');
      } else {
        // Fallback to restaurant_bookings (legacy/backup)
        final bookingsDoc = await FirebaseFirestore.instance
            .collection('restaurant_bookings')
            .doc(widget.restaurantId)
            .get()
            .timeout(const Duration(seconds: 5));

        if (bookingsDoc.exists &&
            bookingsDoc.data()?['operatingHours'] != null) {
          operatingHoursData = bookingsDoc.data()?['operatingHours'];
          debugPrint('Found operating hours in restaurant_bookings (fallback)');

          // Migrate to restaurant_details if missing
          if (detailsDoc.exists) {
            await FirebaseFirestore.instance
                .collection('restaurant_details')
                .doc(widget.restaurantId)
                .set({
                  'operatingHours': operatingHoursData,
                }, SetOptions(merge: true));
          }
        }
      }

      if (operatingHoursData == null) {
        throw Exception("Operating hours data not found in either collection");
      }

      // Convert all time values to HH:MM format
      final Map<String, dynamic> convertedHours = {};

      operatingHoursData.forEach((mealType, times) {
        convertedHours[mealType] = {
          'start': _formatTime(times['start']),
          'end': _formatTime(times['end']),
        };
      });

      setState(() {
        operatingHours = Map<String, Map<String, String>>.from(convertedHours);
        _generateTimeSlots();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _fetchOperatingHours,
          ),
        ),
      );
      debugPrint('Error fetching operating hours: $e');
    }
  }

  String _formatTime(String time) {
    if (time.contains(':')) return time;
    if (time.length == 4) {
      return '${time.substring(0, 2)}:${time.substring(2)}';
    }
    return time; // fallback
  }

  Future<void> _updateOperatingHours() async {
    if (operatingHours == null) return;

    try {
      // Update both collections
      final batch = FirebaseFirestore.instance.batch();

      // Primary update to restaurant_details
      final detailsRef = FirebaseFirestore.instance
          .collection('restaurant_details')
          .doc(widget.restaurantId);

      batch.set(detailsRef, {
        'operatingHours': operatingHours,
      }, SetOptions(merge: true));

      // Secondary update to restaurant_bookings (for backward compatibility)
      final bookingsRef = FirebaseFirestore.instance
          .collection('restaurant_bookings')
          .doc(widget.restaurantId);

      batch.set(bookingsRef, {
        'operatingHours': operatingHours,
        'mealType': selectedMealType,
        'guests': guests,
      }, SetOptions(merge: true));

      await batch.commit();
    } catch (e) {
      debugPrint('Error updating operating hours: $e');
    }
  }

  void _generateTimeSlots() {
    if (operatingHours == null) return;

    timeSlots.clear();

    operatingHours!.forEach((mealType, hours) {
      try {
        final start = hours['start']!;
        final end = hours['end']!;

        final startParts = start.split(':');
        final endParts = end.split(':');

        final startHour = int.parse(startParts[0]);
        final startMinute = int.parse(startParts[1]);
        final endHour = int.parse(endParts[0]);
        final endMinute = int.parse(endParts[1]);

        final slots = <String>[];
        DateTime currentTime = DateTime(2023, 1, 1, startHour, startMinute);
        final endDateTime = DateTime(2023, 1, 1, endHour, endMinute);

        while (currentTime.isBefore(endDateTime)) {
          slots.add(DateFormat('h:mm a').format(currentTime));
          currentTime = currentTime.add(const Duration(minutes: 15));
        }

        timeSlots[mealType] = slots;
      } catch (e) {
        debugPrint('Error generating slots for $mealType: $e');
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTime = null;
        selectedMealType = null;
      });
      await _updateOperatingHours();
    }
  }

  double calculateCoverCharge() {
    if (widget.standardTablePrice == null) {
      debugPrint('Standard table price is null in booking page');
      return 0.0;
    }

    try {
      // Extract just the numeric part from "1000 for 2"
      final numericString =
          widget.standardTablePrice!
              .split(' ')[0] // Takes the first part before space
              .replaceAll('₹', '')
              .replaceAll(',', '')
              .trim();

      debugPrint('Extracted numeric value: $numericString');

      final numericValue = double.tryParse(numericString) ?? 0.0;
      debugPrint('Parsed numeric value: $numericValue');

      // Calculate base charge per person (1000/20 = 50)
      final baseCharge = numericValue / 20;
      // Apply to number of guests
      final charge = baseCharge * guests;
      debugPrint('Calculated cover charge: $charge');
      return charge;
    } catch (e) {
      debugPrint('Error calculating cover charge: $e');
      return 0.0;
    }
  }

  // Future<void> _confirmBooking() async {
  //   if (selectedDate == null ||
  //       selectedMealType == null ||
  //       selectedTime == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please select date, meal type and time')),
  //     );
  //     return;
  //   }

  //   try {
  //     await FirebaseFirestore.instance.collection('restaurant_bookings').add({
  //       'restaurantId': widget.restaurantId,
  //       'date': Timestamp.fromDate(selectedDate!),
  //       'time': selectedTime!.format(context),
  //       'mealType': selectedMealType,
  //       'guests': guests,
  //       'useOffer': useOffer,
  //       'coverCharge': calculateCoverCharge(),
  //       'standardTablePrice': 1000,
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });

  //     // Update the operating hours in restaurant_bookings
  //     await _updateOperatingHours();

  //     ScaffoldMessenger.of(
  //       // ignore: use_build_context_synchronously
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Booking confirmed!')));
  //     // ignore: use_build_context_synchronously
  //     Navigator.pop(context);
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       // ignore: use_build_context_synchronously
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Error: $e')));
  //   }
  // }
  Future<void> _confirmBooking() async {
    if (selectedDate == null ||
        selectedMealType == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date, meal type and time')),
      );
      return;
    }

    try {
      // First save the booking details to Firestore
      final bookingRef = await FirebaseFirestore.instance
          .collection('restaurant_bookings')
          .add({
            'restaurantId': widget.restaurantId,
            'date': Timestamp.fromDate(selectedDate!),
            'time': selectedTime!.format(context),
            'mealType': selectedMealType,
            'guests': guests,
            'useOffer': useOffer,
            'coverCharge': useOffer ? calculateCoverCharge() : 0,
            'standardTablePrice': 1000,
            'createdAt': FieldValue.serverTimestamp(),
            'paymentStatus':
                useOffer ? 'pending' : 'not_required', // Add payment status
          });

      // Update the operating hours
      await _updateOperatingHours();

      if (useOffer) {
        // For offers, navigate to payment page
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder:
                (context) => PaymentPage(
                  coverCharge: calculateCoverCharge(),
                  restaurantId: widget.restaurantId,
                  selectedDate: selectedDate!,
                  selectedTime: selectedTime!,
                  guests: guests,
                  selectedMealType: selectedMealType!,
                ),
          ),
        ).then((paymentSuccess) {
          if (paymentSuccess == true) {
            // Update booking status if payment was successful
            bookingRef.update({'paymentStatus': 'completed'});
          }
        });
      } else {
        // For regular booking, go straight to confirmation
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder:
                (context) => BookingConfirmationPage(
                  restaurantId: widget.restaurantId,
                  date: selectedDate!,
                  time: selectedTime!,
                  guests: guests,
                  mealType: selectedMealType!,
                  coverCharge: 0,
                ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDate != null) {
      debugPrint('Operating Hours: $operatingHours');
      debugPrint('Generated Time Slots: $timeSlots');
      debugPrint('Selected Meal Type: $selectedMealType');
    }

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Calculate cover charge based on standardTablePrice and number of guests
    // final coverCharge = calculateCoverCharge();
    final formattedDate =
        selectedDate == null
            ? 'Select Date'
            : DateFormat('EEE, MMM d').format(selectedDate!);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Table')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number of Guests
            const Text(
              'Number of guest(s)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(20, (index) {
                final count = index + 1;
                return ChoiceChip(
                  label: Text(count.toString()),
                  selected: guests == count,
                  onSelected: (selected) {
                    setState(() {
                      guests = count;
                      _updateOperatingHours();
                    });
                    debugPrint('Guests changed to: $guests');
                  },
                );
              }),
            ),
            const SizedBox(height: 24),

            // Date Selection
            const Text(
              'When are you visiting?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(formattedDate, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),

            // Meal Type Selection
            if (selectedDate != null) ...[
              const Text(
                'Select Time of Day',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (operatingHours != null)
                SizedBox(
                  height: 50, // Fixed height for the scrollable row
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          operatingHours!.keys.map((type) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(type),
                                selected: selectedMealType == type,
                                onSelected: (selected) async {
                                  setState(() {
                                    selectedMealType = type;
                                    selectedTime = null;
                                  });
                                  await _updateOperatingHours();
                                },
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Time Slots with Offers
              if (selectedMealType != null &&
                  timeSlots[selectedMealType] != null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedMealType!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${operatingHours![selectedMealType]!['start']} to ${operatingHours![selectedMealType]!['end']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    // In the GridView.builder for time slots (inside the build method)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio:
                                2.2, // Adjusted for better text visibility
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                      itemCount: timeSlots[selectedMealType]!.length,
                      itemBuilder: (context, index) {
                        final time = timeSlots[selectedMealType]![index];
                        final timeParts = time.split(' ');
                        final hourMinute = timeParts[0].split(':');
                        final period = timeParts[1];

                        // Convert to 24-hour format for comparison
                        var hour = int.parse(hourMinute[0]);
                        final minute = int.parse(hourMinute[1]);
                        if (period == 'PM' && hour != 12) hour += 12;
                        if (period == 'AM' && hour == 12) hour = 0;

                        final isSelected =
                            selectedTime != null &&
                            selectedTime!.hour == hour &&
                            selectedTime!.minute == minute;

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.zero, // Remove default card margin
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Match card radius
                            onTap: () {
                              setState(() {
                                selectedTime = TimeOfDay(
                                  hour: hour,
                                  minute: minute,
                                );
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ), // More vertical padding
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        // ignore: deprecated_member_use
                                        ? Colors.orangeAccent.withOpacity(0.2)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    isSelected
                                        ? Border.all(
                                          color: Colors.orangeAccent,
                                          width: 2,
                                        )
                                        : null,
                              ),
                              child: Center(
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14, // Slightly smaller font
                                    color:
                                        isSelected
                                            ? Colors.orange[800]
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ],

            // Offers Section
            const Text(
              'Choose an offer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Card(
              child: RadioListTile<bool>(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FLAT 10% OFF',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹${calculateCoverCharge().toStringAsFixed(0)} cover charge (₹${(calculateCoverCharge() / guests).toStringAsFixed(0)} per person × $guests guest${guests > 1 ? 's' : ''})',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                value: true,
                groupValue: useOffer,
                onChanged: (value) => setState(() => useOffer = value ?? false),
              ),
            ),
            Card(
              child: RadioListTile<bool>(
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NO OFFER',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Regular table reservation',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                value: false,
                groupValue: useOffer,
                onChanged: (value) => setState(() => useOffer = value ?? false),
              ),
            ),
            const SizedBox(height: 24),
            // Confirm Button
            ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
