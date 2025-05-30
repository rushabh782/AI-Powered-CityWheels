import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:city_wheels/vehicle_rental/rental_details.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_page.dart';

class VehicleDetailsPage extends StatefulWidget {
  final String documentId;

  const VehicleDetailsPage({super.key, required this.documentId});

  @override
  // ignore: library_private_types_in_public_api
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  int selectedStep = 1;
  int _selectedModelIndex = -1;
  List<String> _modelKeys = [];
  late Future<DocumentSnapshot> vehicleFuture;
  String userEmail = "NA";

  List<Map<String, dynamic>> reviews = [];
  bool showAllReviews = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    vehicleFuture =
        FirebaseFirestore.instance
            .collection('vehicles')
            .doc(widget.documentId)
            .get();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      // print("Fetching vehicle document...");

      // Get the vehicle document
      DocumentSnapshot vehicleSnapshot =
          await FirebaseFirestore.instance
              .collection('vehicles')
              .doc(widget.documentId)
              .get();

      // print("Vehicle document fetched: ${vehicleSnapshot.exists}");

      List<dynamic> reviewIds = vehicleSnapshot['vehicle_reviews'] ?? [];

      // print("Review IDs found: $reviewIds");

      if (reviewIds.isEmpty) {
        debugPrint("No reviews found for this vehicle.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      // print("Fetching review documents...");

      // Fetch reviews using the review IDs
      QuerySnapshot reviewSnapshot =
          await FirebaseFirestore.instance
              .collection('reviews')
              .where(FieldPath.documentId, whereIn: reviewIds)
              .get();

      // print("Review documents fetched: ${reviewSnapshot.docs.length}");

      List<Map<String, dynamic>> fetchedReviews =
          reviewSnapshot.docs.map((doc) {
            // Normalize keys by trimming whitespace
            Map<String, dynamic> rawData = doc.data() as Map<String, dynamic>;
            Map<String, dynamic> cleanedData = {};

            rawData.forEach((key, value) {
              cleanedData[key.trim()] = value; // Trim spaces from keys
            });

            // print("Review Data (Normalized): ${doc.id} -> $cleanedData");

            return {'id': doc.id, ...cleanedData};
          }).toList();

      setState(() {
        reviews = fetchedReviews;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addReview(double rating, String reviewText) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String userName = prefs.getString('userName') ?? 'Unknown User';

    DocumentReference newReviewRef =
        FirebaseFirestore.instance.collection('reviews').doc();

    await newReviewRef.set({
      // 'name': userName,
      'rating': rating,
      'review': reviewText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Add the new review ID to the vehicle's review list
    await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(widget.documentId)
        .update({
          'vehicle_reviews': FieldValue.arrayUnion([newReviewRef.id]),
        });

    fetchReviews(); // Refresh reviews
  }

  void showAddReviewDialog() {
    double rating = 5.0; // Initial rating
    TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Allows UI updates inside the dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add a Review"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Rating:"),
                  Slider(
                    value: rating,
                    min: 1,
                    max: 5,
                    divisions: 10,
                    label: rating.toStringAsFixed(1), // Format rating
                    onChanged: (value) {
                      setState(() {
                        rating = value; // Updates the rating inside the dialog
                      });
                    },
                  ),
                  TextField(
                    controller: reviewController,
                    decoration: InputDecoration(labelText: "Write your review"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    addReview(rating, reviewController.text);
                    Navigator.pop(context);
                  },
                  child: Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> checkUser() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // userEmail = prefs.getString('userEmail') ?? 'NA';

    if (userEmail != 'NA') {
      return true;
    }

    return false;
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

    final Map<String, dynamic> modelsMap = Map<String, dynamic>.from(
      vehicleData["model"],
    );
    _modelKeys = modelsMap.keys.toList(); // Keys like ["1", "2", "3"]

    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Details')),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.04),

              // Step Indicator Boxes
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
                          selectedStep = stepNumber;
                        });
                      },
                      child: Container(
                        width: screenWidth * 0.22,
                        height: screenHeight * 0.08,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              selectedStep == stepNumber
                                  ? Colors.blue
                                  : Colors.black,
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
                                    stepNumber == 1
                                        ? _buildGlowingText(
                                          stepNumber.toString(),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          colors: [Colors.black, Colors.white],
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
                            stepNumber == 1
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

              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Vehicle Image
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
                          _buildGlowingText(
                            vehicleData["name"],
                            fontSize: 22 * fontScale,
                            fontWeight: FontWeight.bold,
                            colors: [Colors.black, Colors.white],
                          ),
                          SizedBox(height: screenHeight * 0.005),

                          Divider(
                            thickness: 2,
                            color: Colors.grey.shade300,
                            indent: 20,
                            endIndent: 20,
                            height: screenHeight * 0.03,
                          ),

                          _buildDetailRow(
                            "Type",
                            vehicleData["type"] ?? "Vehicle",
                            fontScale,
                          ),
                          _buildDetailRow(
                            "Passengers",
                            vehicleData["Passengers"].toString(),
                            fontScale,
                          ),
                          _buildRatingsRow(
                            "Ratings",
                            double.parse(vehicleData["Ratings"].toString()),
                            fontScale,
                          ),
                          _buildDetailRow(
                            "Price per Hour",
                            "₹${vehicleData["pricePerHour"].toInt()}",
                            fontScale,
                          ),
                          _buildDetailRow(
                            "Price per Day",
                            "₹${vehicleData["pricePerDay"].toInt()}",
                            fontScale,
                          ),
                          _buildAvailabilityRow(
                            "Available",
                            vehicleData["count"] > 0 ? "Yes" : "No",
                            fontScale,
                          ),

                          // After your _buildAvailabilityRow widget
                          SizedBox(height: 20),
                          Text(
                            "Select Model",
                            style: TextStyle(
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _modelKeys.length,
                              itemBuilder: (context, index) {
                                final key = _modelKeys[index];
                                final model = modelsMap[key];
                                final isSelected = _selectedModelIndex == index;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedModelIndex = index;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(12),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? Colors.blue.shade50
                                              : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? Colors.blue
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Model $key",
                                          style: TextStyle(
                                            fontSize: 16 * fontScale,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Color: ${model['color']}",
                                          style: TextStyle(
                                            fontSize: 16 * fontScale,
                                          ),
                                        ),
                                        Text(
                                          "Mileage: ${model['mileage']} km/l",
                                          style: TextStyle(
                                            fontSize: 16 * fontScale,
                                          ),
                                        ),

                                        Text(
                                          model['count'] > 0
                                              ? 'In Stock'
                                              : 'Out of Stock',
                                          style: TextStyle(
                                            fontSize: 16 * fontScale,
                                            color:
                                                model['count'] > 0
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        if (isSelected)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              model['imageurl'],
                                              height: 60,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.007),

              Text(
                "Customer Chronicles",
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Column(
                children: [
                  if (reviews.isNotEmpty) buildReviewCard(reviews[0]),
                  if (reviews.length > 1 && !showAllReviews)
                    TextButton(
                      onPressed: () => setState(() => showAllReviews = true),
                      child: Text("View More Reviews"),
                    ),
                  if (showAllReviews)
                    Column(
                      children: reviews.skip(1).map(buildReviewCard).toList(),
                    ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: showAddReviewDialog,
                    child: Text("Add Review"),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Continue Button
              Center(
                child: SizedBox(
                  height: screenHeight * 0.045,
                  width: screenWidth * 0.35,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isUserLoggedIn = await checkUser();
                      if (!isUserLoggedIn) {
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text("Login Required"),
                                content: Text(
                                  "Please log in to continue with booking.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    },
                                    child: Text("Login"),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RentalDetailsPage(
                                  documentId: widget.documentId,
                                  modelId: _selectedModelIndex,
                                  pricePerHour: vehicleData['pricePerHour'],
                                  pricePerDay: vehicleData['pricePerDay'],
                                ),
                          ),
                        );
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
              SizedBox(height: screenHeight * 0.02),
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

  Widget _buildDetailRow(String label, String value, double fontScale) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18 * fontScale,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value, style: TextStyle(fontSize: 18 * fontScale)),
        ],
      ),
    );
  }
}

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

Widget _buildAvailabilityRow(
  String label,
  String availability,
  double fontScale,
) {
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
        Text(
          availability,
          style: TextStyle(
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.bold,
            color:
                availability == "Yes"
                    ? Colors.green
                    : Colors.red, // Green for Yes, Red for No
          ),
        ),
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

Widget buildReviewCard(Map<String, dynamic> review) {
  double rating = (review['rating'] ?? 0).toDouble(); // Ensure it's a double
  String reviewText = review['review'] ?? "No review provided";
  String reviewerName = review['name'] ?? "Anonymous";

  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for avatar, name, and rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 12), // Space between avatar and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewerName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      if (index + 1 <= rating) {
                        return Icon(Icons.star, color: Colors.blue, size: 18);
                      } else if (index < rating) {
                        return Icon(
                          Icons.star_half,
                          color: Colors.blue,
                          size: 18,
                        );
                      } else {
                        return Icon(
                          Icons.star_border,
                          color: Colors.blue,
                          size: 18,
                        );
                      }
                    }),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8), // Space between rating and review text
          Text(reviewText),
        ],
      ),
    ),
  );
}
