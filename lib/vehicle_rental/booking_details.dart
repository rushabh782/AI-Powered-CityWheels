import 'package:city_wheels/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:city_wheels/secret/keys.dart';
// import 'package:google_fonts/google_fonts.dart';

class BookingDetailsPage extends StatefulWidget {
  final String documentId;
  final int modelId;

  const BookingDetailsPage({
    super.key,
    required this.documentId,
    required this.modelId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage>
    with SingleTickerProviderStateMixin {
  int selectedStep = 3;
  late Future<DocumentSnapshot> vehicleFuture;
  String sourceDate = "NA";
  String sourceTime = "NA";
  String destinationDate = "NA";
  String destinationTime = "NA";
  double totalCost = 0.0;
  double gst = 0;
  double finalTotal = 0;
  String selectedAddress = "NA";
  String userEmail = "NA";

  late AnimationController _carController;
  late Animation<double> _carAnimation;

  @override
  void initState() {
    super.initState();
    vehicleFuture =
        FirebaseFirestore.instance
            .collection('vehicles')
            .doc(widget.documentId)
            .get();
    _loadPreferences();

    // Car Animation Setup
    _carController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _carController
            .reset(); // Reset to start position after reaching the end
        _carController.forward(); // Start again from left to right
      }
    });

    _carAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _carController, curve: Curves.easeInOut));

    _carController.forward();
  }

  @override
  void dispose() {
    _carController.dispose();
    super.dispose();
  }

  Future<String> _fetchPaymentIntent() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        // headers: {'Authorization': 'Bearer ${StripeKeys.secretKey}'},
        body: {
          'amount': (finalTotal * 100).toInt().toString(),
          'currency': 'INR',
          'payment_method_types[]': 'card',
        },
      );

      debugPrint("Response Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['client_secret']; // Extracting client secret
      } else {
        throw Exception("Failed to fetch PaymentIntent");
      }
    } catch (e) {
      throw Exception("Error creating payment intent: $e");
    }
  }

  Future<bool> _makePayment() async {
    try {
      debugPrint("Initializing Stripe in VehiclePaymentPage...");

      // Fetch client secret from backend
      String clientSecret = await _fetchPaymentIntent();
      debugPrint("Client Secret: $clientSecret");

      // Initialize Payment Sheet
      // await Stripe.instance.initPaymentSheet(
      //   paymentSheetParameters: SetupPaymentSheetParameters(
      //     paymentIntentClientSecret: clientSecret,
      //     merchantDisplayName: 'CityWheels',
      //   ),
      // );

      debugPrint("Presenting Payment Sheet...");
      // await Stripe.instance.presentPaymentSheet();

      // Check if further authentication is required
      // final paymentIntent = await Stripe.instance.retrievePaymentIntent(
      //   clientSecret,
      // );
      // if (paymentIntent.status == PaymentIntentsStatus.RequiresAction) {
      //   print("Handling Next Action (3D Secure)...");
      //   await Stripe.instance.handleNextAction(clientSecret);
      // }

      // If successful
      debugPrint("Payment Successful! ✅");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Successful! Your booking has been confirmed"),
        ),
      );

      return true;
    } catch (e) {
      // if (e is StripeException) {
      //   print("Stripe Error: ${e.error.localizedMessage}");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text("Payment Failed: ${e.error.localizedMessage}"),
      //     ),
      //   );
      // } else {
      //   print("Unexpected Error: $e");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Payment Failed. Please try again.")),
      //   );
      // }
    }

    return false;
  }

  Future<void> _saveBookingDetails({
    required String sourceDate,
    required String sourceTime,
    required String destinationDate,
    required String destinationTime,
    required double totalCost,
    required String selectedAddress,
    required String documentId,
    required String userEmail,
    required int modelId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('vehicle_bookings').add({
        'pickUpDate': sourceDate,
        'pickUpTime': sourceTime,
        'dropOffDate': destinationDate,
        'dropOffTime': destinationTime,
        'totalCost': totalCost,
        'address': selectedAddress,
        'vehicleId': documentId,
        'userEmail': userEmail,
        'timestamp': FieldValue.serverTimestamp(),
        'modelId': modelId + 1,
      });
    } catch (e) {
      debugPrint("Error saving booking details: $e");
    }
  }

  Future<void> _loadPreferences() async {
    // final prefs = await SharedPreferences.getInstance();

    // setState(() {
    //   userEmail = prefs.getString('userEmail') ?? 'NA';

    //   // Convert ISO Date to DD-MM-YYYY
    //   sourceDate = _formatDate(prefs.getString('sourceDate'));
    //   destinationDate = _formatDate(prefs.getString('destinationDate'));

    //   // Convert 24-hour time to 12-hour format with AM/PM
    //   sourceTime = _formatTime(prefs.getString('sourceTime'));
    //   destinationTime = _formatTime(prefs.getString('destinationTime'));

    //   totalCost = prefs.getDouble('totalCost') ?? 0.0;
    //   selectedAddress = prefs.getString('address') ?? 'NA';

    //   gst = totalCost * 0.12;
    //   finalTotal = totalCost + gst;
    // });

    // Print values for debugging
    debugPrint("Source Date: $sourceDate");
    debugPrint("Source Time: $sourceTime");
    debugPrint("Destination Date: $destinationDate");
    debugPrint("Destination Time: $destinationTime");
    debugPrint("Total Cost: $totalCost");
  }

  Future<void> savePreferences() async {
    // final prefs = await SharedPreferences.getInstance();

    // prefs.setDouble('totalCost', finalTotal);
  }

  Future<void> _deductVehicleCount(
    Map<String, dynamic> vehicleData,
    String? modelId,
  ) async {
    try {
      final vehicleRef = FirebaseFirestore.instance
          .collection('vehicles')
          .doc(widget.documentId);
      debugPrint(modelId);

      // Deduct main vehicle count
      int currentCount = vehicleData['count'] ?? 0;
      if (currentCount > 0) {
        await vehicleRef.update({'count': currentCount - 1});
      }

      // Parse modelId and check if valid and not zero
      int model = int.tryParse(modelId ?? '-1') ?? -1;
      model += 1;

      debugPrint("model : $model");

      if (model != -1) {
        String modelKey = model.toString();
        int modelCount = vehicleData['model']?[modelKey]?['count'] ?? 0;

        if (modelCount > 0) {
          await vehicleRef.update({'model.$modelKey.count': modelCount - 1});
        }
      }
    } catch (e) {
      debugPrint("modelId : $modelId");
      debugPrint("Error updating count: $e");
    }
  }

  // Helper function to format date
  // ignore: unused_element
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "NA";
    DateTime date = DateTime.parse(dateString);
    return DateFormat('dd-MM-yyyy').format(date);
  }

  // Helper function to format time (24-hour to 12-hour format)
  // ignore: unused_element
  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return "NA";

    List<String> parts = timeString.split(':'); // Split "HH:MM"
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Format time to 12-hour format with AM/PM
    return DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: vehicleFuture, // Fetch data once
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text("Vehicle not found")));
        }

        var vehicleData = snapshot.data!.data() as Map<String, dynamic>;

        return _buildUI(vehicleData); // Build the UI separately
      },
    );
  }

  Widget _buildUI(Map<String, dynamic> vehicleData) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // ignore: deprecated_member_use
    double fontScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.01),
              // Step Indicator Boxes (No horizontal padding applied)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  int stepNumber = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStep =
                            2; // stepNumber for selecting different boxes
                      });
                    },
                    child: Container(
                      width: screenWidth * 0.22,
                      height: screenHeight * 0.08,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            stepNumber == 1 || stepNumber == 2
                                ? Colors
                                    .green // Green for step 1
                                : (selectedStep == stepNumber
                                    ? Colors.blue
                                    : Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child:
                                  stepNumber == 3
                                      ? Text(
                                        stepNumber.toString(),
                                        style: TextStyle(color: Colors.black),
                                      )
                                      : Text(
                                        stepNumber.toString(),
                                        style: TextStyle(
                                          color:
                                              selectedStep == stepNumber
                                                  ? Colors.blue
                                                  : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          stepNumber == 3
                              ? _buildGlowingText(
                                _getStepTitle(stepNumber),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                colors: [Colors.white, Colors.blue],
                              )
                              : Text(
                                _getStepTitle(stepNumber),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Apply padding only to the content below the step indicator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Vehicle Image at the Top
                    Container(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 6),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(vehicleData['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Ticket Container
                    Container(
                      width: screenWidth * 0.9,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            vehicleData['name'],
                            style: TextStyle(
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            vehicleData['type'],
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          // Address
                          Text(
                            selectedAddress,
                            style: TextStyle(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(),

                          // Pickup and Drop-off details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pickup",
                                    style: TextStyle(
                                      fontSize: 16 * fontScale,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  _buildDetailRow(
                                    "Date",
                                    sourceDate,
                                    fontScale,
                                  ),
                                  _buildDetailRow(
                                    "Time",
                                    sourceTime,
                                    fontScale,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Drop-off",
                                    style: TextStyle(
                                      fontSize: 16 * fontScale,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  _buildDetailRow(
                                    "Date",
                                    destinationDate,
                                    fontScale,
                                  ),
                                  _buildDetailRow(
                                    "Time",
                                    destinationTime,
                                    fontScale,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Car Animation
                          Stack(
                            children: [
                              Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade400,
                                      width: 2,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _carAnimation,
                                builder: (context, child) {
                                  return Positioned(
                                    left:
                                        _carAnimation.value *
                                        (screenWidth * 0.7),
                                    top: 5,
                                    child: SizedBox(
                                      width:
                                          40, // Adjust width to fit inside the 40px-high container
                                      height: 40,
                                      child: Image.asset(
                                        'assets/images/bike_payment.png',
                                        fit:
                                            BoxFit
                                                .contain, // Ensures it fits within the box
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Cost Details
                          _buildDetailRow(
                            "Subtotal",
                            "₹${totalCost.toStringAsFixed(2)}",
                            fontScale,
                          ),
                          _buildDetailRow(
                            "GST (12%)",
                            "₹${gst.toStringAsFixed(2)}",
                            fontScale,
                          ),
                          Divider(),
                          Text(
                            "Total: ₹${finalTotal.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 20 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Center(
                child: SizedBox(
                  height: screenHeight * 0.045,
                  width: screenWidth * 0.35,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool paymentSuccess =
                          await _makePayment(); // Ensure _makePayment() returns a bool
                      if (paymentSuccess) {
                        await savePreferences();
                        await _deductVehicleCount(
                          vehicleData,
                          widget.modelId.toString(),
                        );
                        await _saveBookingDetails(
                          sourceDate: sourceDate,
                          sourceTime: sourceTime,
                          destinationDate: destinationDate,
                          destinationTime: destinationTime,
                          totalCost: totalCost,
                          selectedAddress: selectedAddress,
                          documentId: widget.documentId,
                          userEmail: userEmail,
                          modelId: widget.modelId,
                        );
                        Navigator.pushAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(builder: (context) => BottomBar()),
                          (route) => false,
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        _showPaymentFailedDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return "Vehicle Details";
      case 2:
        return "Rental Details";
      case 3:
        return "Booking";
      default:
        return "";
    }
  }
}

void _showPaymentFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Payment Failed"),
        content: Text(
          "Your payment was not successful. Please try again or go back to home.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text("Try Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomBar()),
                (route) => false,
              );
            },
            child: Text("Home"),
          ),
        ],
      );
    },
  );
}

// ignore: unused_element
Widget _buildRatingsRow(String label, double rating, double fontScale) {
  int fullStars = rating.floor();
  bool hasHalfStar = (rating - fullStars) >= 0.5;
  int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            // Full Blue Stars
            for (int i = 0; i < fullStars; i++)
              Icon(Icons.star, color: Colors.blue, size: 18),

            // Half Star (if applicable)
            if (hasHalfStar)
              Icon(Icons.star_half, color: Colors.blue, size: 18),

            // Empty Black Stars
            for (int i = 0; i < emptyStars; i++)
              Icon(Icons.star, color: Colors.black, size: 18),

            // Rating Text
            SizedBox(width: 5),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(fontSize: 16 * fontScale),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildDetailRow(String label, String value, double fontScale) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(value, style: TextStyle(fontSize: 16 * fontScale)),
      ],
    ),
  );
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
            colors.map((color) {
              return Shadow(
                color: color,
                offset: Offset(0, 0),
                blurRadius: 10.0,
              );
            }).toList(),
      ),
      children: [TextSpan(text: text, style: TextStyle(color: colors.first))],
    ),
  );
}

// Widget _buildAvailabilityRow(String label, String availability, double fontScale) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 5.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 16 * fontScale, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           availability,
//           style: TextStyle(
//             fontSize: 16 * fontScale,
//             fontWeight: FontWeight.bold,
//             color: availability == "Yes" ? Colors.green : Colors.red, // Green for Yes, Red for No
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildDetailnewRow(String label, String value, double fontScale) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
//       children: [
//         Text(
//           "$label: ", // Add a colon for better readability
//           style: TextStyle(fontSize: 18 * fontScale, fontWeight: FontWeight.w500),
//         ),
//         Flexible(
//           child: Text(
//             value,
//             style: TextStyle(fontSize: 18 * fontScale),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
