import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:city_wheels/map.dart';
import 'package:city_wheels/vehicle_rental/booking_details.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class RentalDetailsPage extends StatefulWidget {
  final String documentId;
  final int modelId;
  final int pricePerHour;
  final int pricePerDay;

  const RentalDetailsPage({
    super.key,
    required this.documentId,
    required this.modelId,
    required this.pricePerHour,
    required this.pricePerDay,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RentalDetailsPageState createState() => _RentalDetailsPageState();
}

class _RentalDetailsPageState extends State<RentalDetailsPage> {
  int selectedStep = 2;
  late Future<DocumentSnapshot> vehicleFuture;
  DateTime? sourceDate;
  TimeOfDay? sourceTime;
  DateTime? destinationDate;
  TimeOfDay? destinationTime;
  double totalHours = 0;
  double totalCost = 0;
  double selectedLatitude = 19.22302046430575;
  double selectedLongitude = 72.84087107987945;
  String selectedAddress = "NA";

  Future<void> _selectDate(BuildContext context, bool isSource) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isSource
              ? (sourceDate ?? DateTime.now())
              : (destinationDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isSource) {
          sourceDate = picked;
          // Ensure sourceDate is always ≤ destinationDate
          if (destinationDate != null &&
              sourceDate!.isAfter(destinationDate!)) {
            destinationDate = sourceDate;
          }
        } else {
          // Ensure destinationDate is always ≥ sourceDate
          if (sourceDate != null && picked.isBefore(sourceDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Destination date cannot be before Source date!"),
              ),
            );
            return;
          }
          destinationDate = picked;
        }
        _calculateHours();
      });
    }
  }

  Future<void> saveToPreferences() async {
    // final prefs = await SharedPreferences.getInstance();

    // await prefs.setString('sourceDate', sourceDate?.toIso8601String() ?? '');
    // await prefs.setString(
    //   'sourceTime',
    //   sourceTime != null ? '${sourceTime!.hour}:${sourceTime!.minute}' : '',
    // );
    // await prefs.setString(
    //   'destinationDate',
    //   destinationDate?.toIso8601String() ?? '',
    // );
    // await prefs.setString(
    //   'destinationTime',
    //   destinationTime != null
    //       ? '${destinationTime!.hour}:${destinationTime!.minute}'
    //       : '',
    // );
    // await prefs.setDouble('totalHours', totalHours);
    // await prefs.setDouble('totalCost', totalCost);
    // await prefs.setString('address', selectedAddress);

    // Retrieve and print values after saving
    // print("Stored in SharedPreferences:");
    // print("User Email : ${prefs.getString('userEmail')}");
    // print("Source Date: ${prefs.getString('sourceDate')}");
    // print("Source Time: ${prefs.getString('sourceTime')}");
    // print("Destination Date: ${prefs.getString('destinationDate')}");
    // print("Destination Time: ${prefs.getString('destinationTime')}");
    // print("Total Hours: ${prefs.getDouble('totalHours')}");
    // print("Total Cost: ${prefs.getDouble('totalCost')}");
    // print("Address: ${prefs.getString('address')}");
  }

  Future<void> _selectTime(BuildContext context, bool isSource) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isSource
              ? (sourceTime ?? TimeOfDay.now())
              : (destinationTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isSource) {
          sourceTime = picked;
        } else {
          // If dates are the same, ensure sourceTime < destinationTime
          if (sourceDate != null &&
              destinationDate != null &&
              sourceDate!.isAtSameMomentAs(destinationDate!) &&
              sourceTime != null) {
            int sourceMinutes = sourceTime!.hour * 60 + sourceTime!.minute;
            int destMinutes = picked.hour * 60 + picked.minute;

            if (destMinutes <= sourceMinutes) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Destination time must be after Source time!"),
                ),
              );
              return;
            }
          }
          destinationTime = picked;
        }
        _calculateHours();
      });
    }
  }

  void _calculateHours() {
    if (sourceDate != null &&
        sourceTime != null &&
        destinationDate != null &&
        destinationTime != null) {
      DateTime startDateTime = DateTime(
        sourceDate!.year,
        sourceDate!.month,
        sourceDate!.day,
        sourceTime!.hour,
        sourceTime!.minute,
      );

      DateTime endDateTime = DateTime(
        destinationDate!.year,
        destinationDate!.month,
        destinationDate!.day,
        destinationTime!.hour,
        destinationTime!.minute,
      );

      if (endDateTime.isAfter(startDateTime)) {
        totalHours =
            endDateTime.difference(startDateTime).inMinutes /
            60.0; // Convert minutes to hours

        // **Calculate Total Cost**
        double totalDays = totalHours / 24;
        int fullDays = totalDays.floor(); // Integer part of days
        double remainingHours =
            totalHours - (fullDays * 24); // Remaining hours after full days

        totalCost =
            (fullDays * widget.pricePerDay) +
            (remainingHours * widget.pricePerHour);

        setState(() {}); // Update UI
      } else {
        totalHours = 0.0;
        totalCost = 0.0;
        setState(() {}); // Update UI for invalid case
      }
    } else {
      totalHours = 0.0;
      totalCost = 0.0;
      setState(() {}); // Update UI for default case
    }
  }

  @override
  void initState() {
    super.initState();
    vehicleFuture =
        FirebaseFirestore.instance
            .collection('vehicles')
            .doc(widget.documentId)
            .get();
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
    // double fontScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(title: const Text('Rental Details')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.04),
          // Step Indicator Boxes (No horizontal padding applied)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              int stepNumber = index + 1;
              return Padding(
                padding: EdgeInsets.only(
                  right: index < 2 ? screenWidth * 0.05 : 0,
                ),
                child: GestureDetector(
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
                          stepNumber == 1
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
                                stepNumber == 2
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
                        stepNumber == 2
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
                ),
              );
            }),
          ),

          SizedBox(height: screenHeight * 0.02),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Vehicle Image (Outside the Ticket)
                    Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(vehicleData["imageUrl"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Ticket-Style Container
                    Container(
                      width: screenWidth * 0.9,
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            vehicleData["name"],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),

                          Divider(
                            thickness: 2,
                            color: Colors.grey.shade300,
                            indent: 20,
                            endIndent: 20,
                            height: screenHeight * 0.03,
                          ),

                          // Source Details
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Source Details:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date:", style: TextStyle(fontSize: 14)),
                              GestureDetector(
                                onTap: () => _selectDate(context, true),
                                child: Row(
                                  children: [
                                    Text(
                                      sourceDate != null
                                          ? DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(sourceDate!)
                                          : "Select",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    // SizedBox(width: 5),
                                    // Icon(Icons.calendar_today, color: Colors.blue),
                                  ],
                                ),
                              ),
                              Text("Time:", style: TextStyle(fontSize: 14)),
                              GestureDetector(
                                onTap: () => _selectTime(context, true),
                                child: Row(
                                  children: [
                                    Text(
                                      sourceTime != null
                                          ? sourceTime!.format(context)
                                          : "Select",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    // SizedBox(width: 5),
                                    // Icon(Icons.access_time, color: Colors.blue),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // Destination Details
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Destination Details:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date:", style: TextStyle(fontSize: 14)),
                              GestureDetector(
                                onTap: () => _selectDate(context, false),
                                child: Row(
                                  children: [
                                    Text(
                                      destinationDate != null
                                          ? DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(destinationDate!)
                                          : "Select",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    // SizedBox(width: 5),
                                    // Icon(Icons.calendar_today, color: Colors.blue),
                                  ],
                                ),
                              ),
                              Text("Time:", style: TextStyle(fontSize: 14)),
                              GestureDetector(
                                onTap: () => _selectTime(context, false),
                                child: Row(
                                  children: [
                                    Text(
                                      destinationTime != null
                                          ? destinationTime!.format(context)
                                          : "Select",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    // SizedBox(width: 5),
                                    // Icon(Icons.access_time, color: Colors.blue),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MapScreen(
                                        latitude: selectedLatitude,
                                        longitude: selectedLongitude,
                                      ),
                                ),
                              );

                              // Update selected location when user returns
                              if (result != null) {
                                setState(() {
                                  selectedLatitude = result["latitude"];
                                  selectedLongitude = result["longitude"];
                                  selectedAddress = result["address"];
                                });

                                debugPrint(
                                  "Selected Address: ${result["address"]}",
                                );
                                debugPrint(
                                  "Latitude: ${result["latitude"]}, Longitude: ${result["longitude"]}",
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Text(
                                "Selected Location:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            selectedAddress,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Total Cost
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Cost:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₹${totalCost.toStringAsFixed(2)}", // Display cost with 2 decimal places
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),
                    Center(
                      child: SizedBox(
                        height: screenHeight * 0.045,
                        width: screenWidth * 0.35,
                        child: ElevatedButton(
                          onPressed: () async {
                            await saveToPreferences();
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BookingDetailsPage(
                                      documentId: widget.documentId,
                                      modelId: widget.modelId + 1,
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ), // Adjusted padding
                          ),
                          child: Text(
                            'Continue',
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
          ),
        ],
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
