// //booking_page.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:city_wheels/hotels/confirm_booking_page.dart';
// import 'package:flutter/material.dart';

// class BookingPage extends StatefulWidget {
//   final String hotelId;
//   final String hotelName;
//   final List<Map<String, dynamic>> favoriteHotels;
//   final Function(Map<String, dynamic>) toggleFavorite;

//   const BookingPage({
//     required this.hotelId,
//     required this.favoriteHotels,
//     required this.toggleFavorite,
//     required this.hotelName,
//     super.key,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _BookingPageState createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   late bool isFavorite;
//   Map<String, dynamic>? hotelData;
//   bool isLoading = true;
//   final TextEditingController _reviewController = TextEditingController();
//   double _userRating = 0.0;
//   List<Map<String, dynamic>> reviews = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchHotelDetails();
//     fetchHotelReviews();
//   }

//   /// Fetch hotel details from Firestore
//   Future<void> fetchHotelDetails() async {
//     try {
//       DocumentSnapshot hotelSnapshot =
//           await FirebaseFirestore.instance
//               .collection("hotels")
//               .doc(widget.hotelId)
//               .get();

//       if (hotelSnapshot.exists) {
//         setState(() {
//           hotelData = hotelSnapshot.data() as Map<String, dynamic>;
//           isFavorite = widget.favoriteHotels.any(
//             (hotel) => hotel["id"] == widget.hotelId,
//           );
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       debugPrint("Error fetching hotel data: $e");
//     }
//   }

//   Future<void> fetchHotelReviews() async {
//     try {
//       QuerySnapshot reviewSnapshot =
//           await FirebaseFirestore.instance
//               .collection("hotels")
//               .doc(widget.hotelId)
//               .collection("reviews")
//               .orderBy("timestamp", descending: true)
//               .get();

//       setState(() {
//         reviews =
//             reviewSnapshot.docs
//                 .map(
//                   (doc) => {
//                     ...doc.data() as Map<String, dynamic>,
//                     "id": doc.id,
//                   },
//                 )
//                 .toList();
//       });
//     } catch (e) {
//       debugPrint("Error fetching reviews: $e");
//     }
//   }

//   Future<void> addReview() async {
//     if (_reviewController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Review cannot be empty")));
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance
//           .collection("hotels")
//           .doc(widget.hotelId)
//           .collection("reviews")
//           .add({
//             "text": _reviewController.text.trim(),
//             "rating": _userRating,
//             "timestamp": FieldValue.serverTimestamp(),
//             // In a real app, you'd add user details from authentication
//             "userName": "Anonymous User",
//             "userAvatar": "",
//           });

//       // Clear the text field and reset rating
//       _reviewController.clear();
//       setState(() {
//         _userRating = 0.0;
//       });

//       // Refresh reviews
//       await fetchHotelReviews();

//       // Show success message
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Review added successfully")),
//       );
//     } catch (e) {
//       debugPrint("Error adding review: $e");
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Failed to add review")));
//     }
//   }

//   void toggleFavoriteStatus() {
//     setState(() {
//       isFavorite = !isFavorite;
//     });

//     widget.toggleFavorite({
//       "id": widget.hotelId,
//       "name": hotelData?["name"] ?? "Unknown",
//       "location": hotelData?["location"] ?? "Unknown",
//       "price": hotelData?["price"]?.toString() ?? "N/A",
//       "rating": hotelData?["rating"] ?? 0.0,
//       "image": hotelData?["imageUrl"] ?? "",
//     });

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double screenWidth = MediaQuery.of(context).size.width;

//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (hotelData == null) {
//       return const Scaffold(
//         body: Center(child: Text("Hotel data not available")),
//       );
//     }

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 // Hotel Image
//                 Container(
//                   width: double.infinity,
//                   height: screenHeight * 0.35,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image:
//                           hotelData!["imageUrl"] != null &&
//                                   hotelData!["imageUrl"].isNotEmpty
//                               ? NetworkImage(hotelData!["imageUrl"])
//                               : const AssetImage(
//                                     "assets/images/default_hotel.jpg",
//                                   )
//                                   as ImageProvider,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),

//                 // Back Button
//                 Positioned(
//                   top: screenHeight * 0.05,
//                   left: 10,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.black54,
//                       ),
//                       child: const Icon(Icons.arrow_back, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // Hotel Details
//             Padding(
//               padding: EdgeInsets.all(screenWidth * 0.05),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Hotel Name & Favorite Button
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           hotelData!["name"] ?? "Hotel Name",
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.06,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: toggleFavoriteStatus,
//                         child: Icon(
//                           isFavorite ? Icons.favorite : Icons.favorite_border,
//                           color: isFavorite ? Colors.red : Colors.grey,
//                           size: 28,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),

//                   // Location
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           hotelData!["location"] ?? "Unknown location",
//                           style: const TextStyle(color: Colors.grey),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),

//                   // Rating & Price
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.amber),
//                       const SizedBox(width: 4),
//                       Text(
//                         hotelData!["rating"]?.toString() ?? "0.0",
//                         style: TextStyle(fontSize: screenWidth * 0.05),
//                       ),
//                       const Spacer(),
//                       Text(
//                         "₹${hotelData!["price"]?.toString() ?? "N/A"}",
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.05,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.02),

//                   // Description
//                   Text(
//                     "Hotel Description",
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.05,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     hotelData!["description"] ?? "No description available",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   SizedBox(height: screenHeight * 0.02),

//                   // Key Amenities
//                   Text(
//                     "Key Amenities:",
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.05,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children:
//                         (hotelData!["amenities"] as List?)
//                             ?.map<Widget>((amenity) => Text("• $amenity"))
//                             .toList() ??
//                         [const Text("No amenities available")],
//                   ),
//                   SizedBox(height: screenHeight * 0.02),

//                   // Reviews section
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Reviews (${reviews.length})",
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.05,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       // Review List
//                       if (reviews.isNotEmpty)
//                         Column(
//                           children:
//                               reviews.map((review) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 8.0),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       CircleAvatar(
//                                         backgroundColor: Colors.grey[300],
//                                         child: const Icon(
//                                           Icons.person,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   review['userName'] ??
//                                                       'Anonymous',
//                                                   style: const TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                                 Row(
//                                                   children: List.generate(
//                                                     5,
//                                                     (index) => Icon(
//                                                       index <
//                                                               (review['rating'] ??
//                                                                   0)
//                                                           ? Icons.star
//                                                           : Icons.star_border,
//                                                       color: Colors.amber,
//                                                       size: 16,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(review['text'] ?? ''),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }).toList(),
//                         )
//                       else
//                         const Text("No reviews yet"),

//                       // Add Review Section
//                       const SizedBox(height: 16),
//                       Text(
//                         "Add a Review",
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.05,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: List.generate(
//                           5,
//                           (index) => GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _userRating = index + 1.0;
//                               });
//                             },
//                             child: Icon(
//                               index < _userRating
//                                   ? Icons.star
//                                   : Icons.star_border,
//                               color: Colors.amber,
//                               size: 32,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: _reviewController,
//                         decoration: InputDecoration(
//                           hintText: "Write your review here...",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         maxLines: 3,
//                       ),
//                       const SizedBox(height: 8),
//                       ElevatedButton(
//                         onPressed: addReview,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: const Text("Submit Review"),
//                       ),
//                     ],
//                   ),

//                   // Book Now Button
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => ConfirmBookingPage(
//                                 hotelId: widget.hotelId,
//                                 hotelName: widget.hotelName,
//                               ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(
//                         vertical: screenHeight * 0.02,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Book Now",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: screenWidth * 0.05,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//booking_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:city_wheels/hotels/confirm_booking_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class BookingPage extends StatefulWidget {
  final String hotelId;
  final String hotelName;
  final List<Map<String, dynamic>> favoriteHotels;
  final Function(Map<String, dynamic>) toggleFavorite;

  const BookingPage({
    required this.hotelId,
    required this.favoriteHotels,
    required this.toggleFavorite,
    required this.hotelName,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late bool isFavorite;
  Map<String, dynamic>? hotelData;
  bool isLoading = true;
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0.0;
  List<Map<String, dynamic>> reviews = [];

  // AI Summary variables
  late FlutterTts flutterTts;
  String? generatedSummary;
  bool isGeneratingSummary = false;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    fetchHotelDetails();
    fetchHotelReviews();
    flutterTts = FlutterTts();
    setupTts();
  }

  void setupTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _reviewController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  // Future<String> generateAISummary(String description) async {
  //   final apiKey = dotenv.get('OPENAI_API_KEY');

  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://api.openai.com/v1/chat/completions'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $apiKey',
  //       },
  //       body: jsonEncode({
  //         "model": "gpt-3.5-turbo",
  //         "messages": [
  //           {
  //             "role": "system",
  //             "content":
  //                 "Extract 3 key highlights for travelers from this hotel description. "
  //                 "Use 1 emoji per highlight. Be concise.\nExample format:\n"
  //                 "🔥 Lake views • 🏋️ 24/7 gym • 🚍 Free shuttle",
  //           },
  //           {"role": "user", "content": description},
  //         ],
  //         "temperature": 0.5,
  //         "max_tokens": 100,
  //       }),
  //     );

  //     // if (response.statusCode == 200) {
  //     //   final data = jsonDecode(response.body);
  //     //   return data['choices'][0]['message']['content'];
  //     // } else {
  //     //   throw Exception('API Error: ${response.statusCode}');
  //     // }
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return data['summary'] ?? "No summary available.";
  //     } else {
  //       throw Exception('API Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('AI Summary Error: $e');
  //     return "✨ Luxury stay • 🏊 Pool • 🍽️ Fine dining";
  //   }
  // }
  // Future<String> generateAISummary(String description) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://localhost:3003/summarize'), // Use your IP here
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({"text": description}),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return data['summary'] ?? "No summary available.";
  //     } else {
  //       throw Exception('API Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Summary Error: $e');
  //     return "✨ Luxury stay • 🏊 Pool • 🍽 Fine dining"; // fallback summary
  //   }
  // }
  Future<String> generateAISummary(String description) async {
    if (description.isEmpty) return "✨ Luxury stay • 🏊 Pool • 🍽️ Fine dining";

    try {
      final response = await http
          .post(
            Uri.parse(
              'http://192.168.183.87:3003/summarize',
            ), // Replace with your local IP
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"text": description}),
          )
          .timeout(const Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['summary'] ?? "No summary available.";
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Summary Error: $e');
      return "✨ Luxury stay • 🏊 Pool • 🍽️ Fine dining"; // Fallback
    }
  }

  Future<void> fetchHotelDetails() async {
    try {
      DocumentSnapshot hotelSnapshot =
          await FirebaseFirestore.instance
              .collection("hotels")
              .doc(widget.hotelId)
              .get();

      if (hotelSnapshot.exists) {
        setState(() {
          hotelData = hotelSnapshot.data() as Map<String, dynamic>;
          isFavorite = widget.favoriteHotels.any(
            (hotel) => hotel["id"] == widget.hotelId,
          );
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching hotel data: $e");
    }
  }

  Future<void> fetchHotelReviews() async {
    try {
      QuerySnapshot reviewSnapshot =
          await FirebaseFirestore.instance
              .collection("hotels")
              .doc(widget.hotelId)
              .collection("reviews")
              .orderBy("timestamp", descending: true)
              .get();

      setState(() {
        reviews =
            reviewSnapshot.docs
                .map(
                  (doc) => {
                    ...doc.data() as Map<String, dynamic>,
                    "id": doc.id,
                  },
                )
                .toList();
      });
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    }
  }

  // Future<void> generateSummary() async {
  //   if (hotelData == null) return;

  //   setState(() => isGeneratingSummary = true);

  //   try {
  //     if (hotelData!['summary'] != null) {
  //       setState(() => generatedSummary = hotelData!['summary']);
  //     } else {
  //       // Fallback summary if API fails
  //       final fallbackSummary = "✨ Luxury stay • 🏊 Pool • 🍽️ Fine dining";

  //       // Try to generate with AI (replace with your actual API call)
  //       try {
  //         final response = await http.post(
  //           Uri.parse('https://your-ai-service.com/generate-summary'),
  //           headers: {'Content-Type': 'application/json'},
  //           body: jsonEncode({
  //             'text': hotelData!['description'],
  //             'max_length': 100,
  //           }),
  //         );

  //         if (response.statusCode == 200) {
  //           final data = jsonDecode(response.body);
  //           generatedSummary = data['summary'] ?? fallbackSummary;
  //         } else {
  //           generatedSummary = fallbackSummary;
  //         }
  //       } catch (e) {
  //         generatedSummary = fallbackSummary;
  //       }

  //       // Save to Firestore
  //       await FirebaseFirestore.instance
  //           .collection('hotels')
  //           .doc(widget.hotelId)
  //           .update({'summary': generatedSummary});

  //       setState(() {});
  //     }
  //   } catch (e) {
  //     debugPrint('Error generating summary: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to generate summary')),
  //     );
  //   } finally {
  //     setState(() => isGeneratingSummary = false);
  //   }
  // }
  Future<void> generateSummary() async {
    if (hotelData == null || hotelData!['description'] == null) {
      setState(
        () => generatedSummary = "✨ Luxury stay • 🏊 Pool • 🍽️ Fine dining",
      );
      return;
    }
    setState(() => isGeneratingSummary = true);

    try {
      if (hotelData!['summary'] != null) {
        setState(() => generatedSummary = hotelData!['summary']);
      } else {
        final summary = await generateAISummary(hotelData!['description']);

        // Save to Firestore for future use
        await FirebaseFirestore.instance
            .collection('hotels')
            .doc(widget.hotelId)
            .update({'summary': summary});

        setState(() => generatedSummary = summary);
      }
    } catch (e) {
      debugPrint('Error generating summary: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate summary')),
      );
    } finally {
      setState(() => isGeneratingSummary = false);
    }
  }

  Future<void> speakSummary() async {
    if (generatedSummary == null) return;

    if (isSpeaking) {
      await flutterTts.stop();
      setState(() => isSpeaking = false);
    } else {
      setState(() => isSpeaking = true);
      await flutterTts.speak(generatedSummary!);
      setState(() => isSpeaking = false);
    }
  }

  // Widget _buildSummarySection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 8),
  //       ElevatedButton.icon(
  //         onPressed: () async {
  //           if (generatedSummary == null) {
  //             await generateSummary();
  //           }
  //           await speakSummary();
  //         },
  //         icon:
  //             isGeneratingSummary
  //                 ? const SizedBox(
  //                   width: 20,
  //                   height: 20,
  //                   child: CircularProgressIndicator(
  //                     strokeWidth: 2,
  //                     color: Colors.white,
  //                   ),
  //                 )
  //                 : isSpeaking
  //                 ? const Icon(Icons.volume_off)
  //                 : const Icon(Icons.auto_awesome, size: 20),
  //         label: Text(
  //           isGeneratingSummary
  //               ? 'Generating...'
  //               : isSpeaking
  //               ? 'Stop'
  //               : 'AI Summary 🔊',
  //           style: const TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.deepPurple,
  //           foregroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //         ),
  //       ),
  //       if (generatedSummary != null) ...[
  //         const SizedBox(height: 12),
  //         Container(
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.deepPurple.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Row(
  //             children: [
  //               const Icon(Icons.auto_awesome, color: Colors.deepPurple),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 child: Text(
  //                   generatedSummary!,
  //                   style: const TextStyle(fontStyle: FontStyle.italic),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ],
  //   );
  // }
  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () async {
            if (generatedSummary == null) {
              await generateSummary();
            }
            await speakSummary();
          },
          icon:
              isGeneratingSummary
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : isSpeaking
                  ? const Icon(Icons.volume_off)
                  : const Icon(Icons.auto_awesome, size: 20),
          label: Text(
            isGeneratingSummary
                ? 'Generating...'
                : isSpeaking
                ? 'Stop'
                : 'AI Summary 🔊',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
        if (generatedSummary != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    generatedSummary!,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> addReview() async {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Review cannot be empty")));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("hotels")
          .doc(widget.hotelId)
          .collection("reviews")
          .add({
            "text": _reviewController.text.trim(),
            "rating": _userRating,
            "timestamp": FieldValue.serverTimestamp(),
            "userName": "Anonymous User",
            "userAvatar": "",
          });

      _reviewController.clear();
      setState(() {
        _userRating = 0.0;
      });

      await fetchHotelReviews();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review added successfully")),
      );
    } catch (e) {
      debugPrint("Error adding review: $e");
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add review")));
    }
  }

  void toggleFavoriteStatus() {
    setState(() {
      isFavorite = !isFavorite;
    });

    widget.toggleFavorite({
      "id": widget.hotelId,
      "name": hotelData?["name"] ?? "Unknown",
      "location": hotelData?["location"] ?? "Unknown",
      "price": hotelData?["price"]?.toString() ?? "N/A",
      "rating": hotelData?["rating"] ?? 0.0,
      "image": hotelData?["imageUrl"] ?? "",
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hotelData == null) {
      return const Scaffold(
        body: Center(child: Text("Hotel data not available")),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          hotelData!["imageUrl"] != null &&
                                  hotelData!["imageUrl"].isNotEmpty
                              ? NetworkImage(hotelData!["imageUrl"])
                              : const AssetImage(
                                    "assets/images/default_hotel.jpg",
                                  )
                                  as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.05,
                  left: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hotelData!["name"] ?? "Hotel Name",
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: toggleFavoriteStatus,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotelData!["location"] ?? "Unknown location",
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        hotelData!["rating"]?.toString() ?? "0.0",
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      const Spacer(),
                      Text(
                        "₹${hotelData!["price"]?.toString() ?? "N/A"}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Hotel Description",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       hotelData!["description"] ?? "No description available",
                  //       style: const TextStyle(color: Colors.grey),
                  //     ),
                  //     _buildSummarySection(),
                  //   ],
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotelData!["description"] ?? "No description available",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      _buildSummarySection(), // This adds the AI summary feature
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Key Amenities:",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        (hotelData!["amenities"] as List?)
                            ?.map<Widget>((amenity) => Text("• $amenity"))
                            .toList() ??
                        [const Text("No amenities available")],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reviews (${reviews.length})",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (reviews.isNotEmpty)
                        Column(
                          children:
                              reviews.map((review) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  review['userName'] ??
                                                      'Anonymous',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                    (index) => Icon(
                                                      index <
                                                              (review['rating'] ??
                                                                  0)
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(review['text'] ?? ''),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        )
                      else
                        const Text("No reviews yet"),
                      const SizedBox(height: 16),
                      Text(
                        "Add a Review",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _userRating = index + 1.0;
                              });
                            },
                            child: Icon(
                              index < _userRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reviewController,
                        decoration: InputDecoration(
                          hintText: "Write your review here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: addReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Submit Review"),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ConfirmBookingPage(
                                hotelId: widget.hotelId,
                                hotelName: widget.hotelName,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Book Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
