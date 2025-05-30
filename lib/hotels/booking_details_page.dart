// booking_details_page.dart
import 'package:city_wheels/hotels/payment_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:city_wheels/hotels/models.dart';

class HotelMapView extends StatelessWidget {
  final String hotelName;
  final LatLng location;

  const HotelMapView({
    super.key,
    required this.hotelName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotelName),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(center: location, zoom: 15.0),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: location,
                builder:
                    (ctx) => const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;
  final Map<String, dynamic> bookingData;

  // ignore: use_super_parameters
  const BookingDetailsPage({
    Key? key,
    required this.bookingId,
    required this.bookingData,
  }) : super(key: key);

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  // ignore: unused_field
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Mr');
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';

  @override
  void dispose() {
    _titleController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveGuestDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        final doc =
            await FirebaseFirestore.instance
                .collection('hotel_bookings')
                .doc(widget.bookingId)
                .get();

        if (!doc.exists) {
          throw Exception('Booking document does not exist');
        }
        await doc.reference.update({
          'guestDetails': {
            'title': _titleController.text,
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': _emailController.text,
            'phone': '$_selectedCountryCode ${_phoneController.text}',
          },
        });

        final bookingData = doc.data() as Map<String, dynamic>;
        debugPrint('Current bookingData: $bookingData');

        final totalPrice = (bookingData['totalPrice'] ?? 0.0).toDouble();
        debugPrint('Using totalPrice: $totalPrice');

        final guestDetails = GuestDetails(
          totalPrice: totalPrice,
          title: _titleController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          countryCode: _selectedCountryCode,
          phoneNumber: _phoneController.text,
        );

        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => PaymentDetailsPage(
                  guestDetails: guestDetails,
                  bookingId: widget.bookingId,
                  bookingData: bookingData,
                ),
          ),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
        debugPrint('Full error details: $e');
      }
    }
  }

  // void _openMapView(Map<String, dynamic> bookingData) {
  //   if (bookingData.containsKey('location') &&
  //       bookingData['location'] is Map<String, dynamic>) {
  //     final locationData = bookingData['location'] as Map<String, dynamic>;

  //     if (locationData.containsKey('latitude') &&
  //         locationData.containsKey('longitude')) {
  //       final latitude = locationData['latitude'] as double;
  //       final longitude = locationData['longitude'] as double;
  //       final hotelName = bookingData['hotelName'] ?? 'Stay Hotel';

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder:
  //               (context) => HotelMapView(
  //                 hotelName: hotelName,
  //                 location: LatLng(latitude, longitude),
  //               ),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Location data is incomplete")),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("No location data available for this hotel"),
  //       ),
  //     );
  //   }
  // }
  void _openMapView(Map<String, dynamic> bookingData) async {
    try {
      if (bookingData.containsKey('hotelId')) {
        final hotelDoc =
            await FirebaseFirestore.instance
                .collection('hotels')
                .doc(bookingData['hotelId'])
                .get();

        if (hotelDoc.exists) {
          final hotelData = hotelDoc.data() as Map<String, dynamic>;
          if (hotelData.containsKey('latitude') &&
              hotelData.containsKey('longitude')) {
            final latitude = hotelData['latitude'] as double;
            final longitude = hotelData['longitude'] as double;
            final hotelName = hotelData['name'] ?? 'Hotel';

            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder:
                    (context) => HotelMapView(
                      hotelName: hotelName,
                      location: LatLng(latitude, longitude),
                    ),
              ),
            );
            return;
          }
        }
      }

      // Fallback if any data is missing
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No location data available for this hotel"),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading map: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('hotel_bookings')
                .doc(widget.bookingId)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Booking not found"));
          }

          final bookingData = snapshot.data!.data() as Map<String, dynamic>;
          if (bookingData.isEmpty) {
            return const Center(child: Text("Booking data is empty"));
          }

          return FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection('hotels')
                    .doc(bookingData['hotelId'])
                    .get(),
            builder: (context, hotelSnapshot) {
              if (hotelSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (hotelSnapshot.hasError) {
                return Center(
                  child: Text("Error loading hotel: ${hotelSnapshot.error}"),
                );
              }

              Map<String, dynamic> hotelData = {};
              if (hotelSnapshot.hasData && hotelSnapshot.data!.exists) {
                hotelData = hotelSnapshot.data!.data() as Map<String, dynamic>;
              }

              debugPrint('Fetched bookingData: $bookingData');
              DateTime checkInDate =
                  (bookingData['checkInDate'] as Timestamp).toDate();
              DateTime checkOutDate =
                  (bookingData['checkOutDate'] as Timestamp).toDate();

              Map<String, dynamic> checkInTimeMap =
                  bookingData['checkInTime'] as Map<String, dynamic>;
              Map<String, dynamic> checkOutTimeMap =
                  bookingData['checkOutTime'] as Map<String, dynamic>;

              TimeOfDay checkInTime = TimeOfDay(
                hour: checkInTimeMap['hour'],
                minute: checkInTimeMap['minute'],
              );

              TimeOfDay checkOutTime = TimeOfDay(
                hour: checkOutTimeMap['hour'],
                minute: checkOutTimeMap['minute'],
              );

              if (bookingData.containsKey('guestDetails')) {
                final guestDetails =
                    bookingData['guestDetails'] as Map<String, dynamic>;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _titleController.text = guestDetails['title'] ?? 'Mr';
                  _firstNameController.text = guestDetails['firstName'] ?? '';
                  _lastNameController.text = guestDetails['lastName'] ?? '';
                  _emailController.text = guestDetails['email'] ?? '';

                  final phoneNumber = guestDetails['phone'] ?? '';
                  if (phoneNumber.length > 3) {
                    final parts = phoneNumber.split(' ');
                    if (parts.length >= 2) {
                      _selectedCountryCode = parts[0];
                      _phoneController.text = parts[1];
                    }
                  }
                });
              }

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card(
                      //   elevation: 3,
                      //   margin: const EdgeInsets.only(bottom: 20),
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(15),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           children: [
                      //             const Icon(
                      //               Icons.hotel,
                      //               size: 24,
                      //               color: Colors.blue,
                      //             ),
                      //             const SizedBox(width: 8),
                      //             Text(
                      //               hotelData['name'] ?? "Stay Hotel",
                      //               style: const TextStyle(
                      //                 fontSize: 22,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             const Spacer(),
                      //             Row(
                      //               children: List.generate(
                      //                 (hotelData['rating'] ?? 3).floor(),
                      //                 (index) => const Icon(
                      //                   Icons.star,
                      //                   color: Colors.amber,
                      //                   size: 20,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         const SizedBox(height: 8),
                      //         Row(
                      //           children: [
                      //             const Icon(
                      //               Icons.location_on,
                      //               size: 16,
                      //               color: Colors.grey,
                      //             ),
                      //             const SizedBox(width: 4),
                      //             Text(
                      //               hotelData['location'] ?? "City Center",
                      //               style: const TextStyle(color: Colors.grey),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.hotel,
                                    size: 24,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Modified hotel name section
                                        SizedBox(
                                          width:
                                              double
                                                  .infinity, // Take full available width
                                          child: Text(
                                            hotelData['name'] ?? "Stay Hotel",
                                            style: const TextStyle(
                                              fontSize:
                                                  20, // Slightly reduced font size
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1, // Single line
                                            overflow:
                                                TextOverflow
                                                    .fade, // Fade instead of ellipsis
                                            softWrap:
                                                false, // Prevent word breaking
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                hotelData['location'] ??
                                                    "City Center",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ), // Add spacing before stars
                                  Row(
                                    children: List.generate(
                                      (hotelData['rating'] ?? 3).floor(),
                                      (index) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildSectionTitle("Booking Details"),
                      _buildInfoCard(
                        context,
                        children: [
                          _buildInfoRow(
                            "Room Type",
                            bookingData['roomType'] ?? "Not specified",
                            Icons.hotel,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            "Number of Rooms",
                            "${bookingData['numberOfRooms']} ${bookingData['numberOfRooms'] > 1 ? 'rooms' : 'room'}",
                            Icons.door_front_door,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            "Guests",
                            "${bookingData['numberOfAdults']} ${bookingData['numberOfAdults'] > 1 ? 'adults' : 'adult'}, ${bookingData['numberOfChildren']} ${bookingData['numberOfChildren'] > 1 || bookingData['numberOfChildren'] == 0 ? 'children' : 'child'}",
                            Icons.people,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            "Stay Duration",
                            "${bookingData['numberOfDays']} ${bookingData['numberOfDays'] > 1 ? 'nights' : 'night'}",
                            Icons.calendar_today,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildSectionTitle("Check-in & Check-out"),
                      _buildInfoCard(
                        context,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Check-in",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(checkInDate),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "From ${checkInTime.format(context)}",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 70,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Check-out",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(checkOutDate),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Until ${checkOutTime.format(context)}",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildSectionTitle("Price Details"),
                      _buildInfoCard(
                        context,
                        children: [
                          _buildInfoRow(
                            "Base Price",
                            "₹${bookingData['pricePerDay'].toStringAsFixed(2)} × ${bookingData['numberOfRooms']} × ${bookingData['numberOfDays']}",
                            Icons.attach_money,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            "Total Price",
                            "₹${bookingData['totalPrice'].toStringAsFixed(2)}",
                            Icons.payment,
                            isHighlighted: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildSectionTitle("Guest Details"),
                      _buildInfoCard(
                        context,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return constraints.maxWidth < 600
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "TITLE",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          DropdownButtonFormField<String>(
                                            value: _titleController.text,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            items:
                                                ['Mr', 'Mrs', 'Ms', 'Dr'].map((
                                                  String value,
                                                ) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                            onChanged: (newValue) {
                                              _titleController.text = newValue!;
                                            },
                                            isExpanded: true,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "FULL NAME",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          TextFormField(
                                            controller: _firstNameController,
                                            decoration: InputDecoration(
                                              hintText: 'First Name',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter first name';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            controller: _lastNameController,
                                            decoration: InputDecoration(
                                              hintText: 'Last Name',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter last name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                  : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "TITLE",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            DropdownButtonFormField<String>(
                                              value: _titleController.text,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              items:
                                                  ['Mr', 'Mrs', 'Ms', 'Dr'].map(
                                                    (String value) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    },
                                                  ).toList(),
                                              onChanged: (newValue) {
                                                _titleController.text =
                                                    newValue!;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "FULL NAME",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        _firstNameController,
                                                    decoration: InputDecoration(
                                                      hintText: 'First Name',
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter first name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        _lastNameController,
                                                    decoration: InputDecoration(
                                                      hintText: 'Last Name',
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter last name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                            },
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "EMAIL ADDRESS (Booking voucher will be sent to this email ID)",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email ID',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter email address';
                                  }
                                  if (!value.contains('@') ||
                                      !value.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "MOBILE NUMBER",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return constraints.maxWidth < 600
                                      ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DropdownButtonFormField<String>(
                                            value: _selectedCountryCode,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            items:
                                                ['+91', '+1', '+44', '+61'].map(
                                                  (String value) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  },
                                                ).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedCountryCode =
                                                    newValue!;
                                              });
                                            },
                                            isExpanded: true,
                                          ),
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            controller: _phoneController,
                                            decoration: InputDecoration(
                                              hintText: 'Contact Number',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            keyboardType: TextInputType.phone,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter phone number';
                                              }
                                              if (value.length != 10) {
                                                return 'Phone number must be 10 digits';
                                              }
                                              if (!RegExp(
                                                r'^[0-9]+$',
                                              ).hasMatch(value)) {
                                                return 'Only numbers are allowed';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      )
                                      : Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: DropdownButtonFormField<
                                              String
                                            >(
                                              value: _selectedCountryCode,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              items:
                                                  [
                                                    '+91',
                                                    '+1',
                                                    '+44',
                                                    '+61',
                                                  ].map((String value) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedCountryCode =
                                                      newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _phoneController,
                                              decoration: InputDecoration(
                                                hintText: 'Contact Number',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              keyboardType: TextInputType.phone,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter phone number';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _openMapView(bookingData),
                              icon: const Icon(Icons.map),
                              label: const Text("View on Map"),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _saveGuestDetails,
                              icon: const Icon(Icons.save),
                              label: const Text(
                                "Complete my booking",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 15)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlighted ? 16 : 15,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 20, thickness: 1, color: Colors.grey.shade300);
  }
}
