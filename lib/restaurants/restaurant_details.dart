// import 'package:city_wheels/restaurants/restaurant_booking.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RestaurantDetailsPage extends StatefulWidget {
//   final String restaurantId;
//   final List<String> imageUrls;
//   final String name;
//   final double rating;
//   final String address;
//   final String phone;
//   final String description;
//   final String timing;
//   final bool isLiked;
//   final String? menuImageUrl; // Menu image URL field

//   const RestaurantDetailsPage({
//     super.key,
//     required this.restaurantId,
//     required this.imageUrls,
//     required this.name,
//     required this.rating,
//     required this.address,
//     required this.phone,
//     required this.description,
//     required this.timing,
//     required this.isLiked,
//     this.menuImageUrl, // Menu image URL from Firebase
//     required Null Function(bool newValue) onFavoriteToggled,
//     required Null Function(bool isFavorite) onFavoriteChanged,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
// }

// class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
//   late bool isLiked;
//   String? menuImageUrl;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     isLiked = widget.isLiked;
//     fetchRestaurantData();
//   }

//   Future<void> fetchRestaurantData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Fetch the restaurant data directly from Firestore
//       final restaurantDoc =
//           await FirebaseFirestore.instance
//               .collection('restaurants')
//               .doc(widget.restaurantId)
//               .get();

//       if (restaurantDoc.exists) {
//         setState(() {
//           // Get menuImageUrl directly from the restaurant document
//           menuImageUrl = restaurantDoc.data()?['menuImageUrl'] as String?;
//           isLoading = false;
//         });
//       } else {
//         print('Restaurant document does not exist');
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error fetching restaurant data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void toggleLike() {
//     setState(() {
//       isLiked = !isLiked;
//     });

//     // Update Firestore reference for likes
//     FirebaseFirestore.instance
//         .collection('restaurants')
//         .doc(widget.restaurantId)
//         .update({'isLiked': isLiked});
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Ensuring `imageUrls` is always a List and handles empty lists
//     List<String> imageUrls =
//         (widget.imageUrls.isNotEmpty)
//             ? widget.imageUrls
//             : ["https://via.placeholder.com/250"]; // Default image

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.name),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image carousel with rating badge at bottom
//             Stack(
//               children: [
//                 // Carousel with proper handling for missing images
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: 250,
//                     autoPlay: true,
//                     autoPlayInterval: const Duration(seconds: 3),
//                     autoPlayAnimationDuration: const Duration(
//                       milliseconds: 800,
//                     ),
//                     enlargeCenterPage: true,
//                     viewportFraction: 1.0,
//                   ),
//                   items:
//                       imageUrls.map((image) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             image,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             errorBuilder:
//                                 (context, error, stackTrace) => Image.network(
//                                   "https://via.placeholder.com/250",
//                                 ),
//                           ),
//                         );
//                       }).toList(),
//                 ),

//                 // Rating badge positioned at bottom of carousel
//                 Positioned(
//                   right: 16,
//                   top: 16,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.star, color: Colors.white, size: 18),
//                         const SizedBox(width: 4),
//                         Text(
//                           widget.rating.toStringAsFixed(1),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.description.isNotEmpty
//                               ? widget.description
//                               : "No description available",
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: toggleLike,
//                         icon: Icon(
//                           isLiked ? Icons.favorite : Icons.favorite_border,
//                           color: isLiked ? Colors.red : Colors.grey,
//                           size: 28,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),

//                   Text(
//                     "📍 ${widget.address.isNotEmpty ? widget.address : "Address not available"}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     "📞 ${widget.phone.isNotEmpty ? widget.phone : "N/A"}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     "🕒 ${widget.timing.isNotEmpty ? widget.timing : "N/A"}",
//                     style: const TextStyle(fontSize: 16),
//                   ),

//                   const SizedBox(height: 24),

//                   // Menu Section
//                   const Text(
//                     "Menu",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),

//                   // Menu image with loading state
//                   isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : menuImageUrl != null
//                       ? Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               spreadRadius: 1,
//                               blurRadius: 5,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Column(
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   // Show full screen dialog when menu image is tapped
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return Dialog(
//                                         insetPadding: EdgeInsets.zero,
//                                         child: Container(
//                                           width: double.infinity,
//                                           height: double.infinity,
//                                           color: Colors.black,
//                                           child: Stack(
//                                             fit: StackFit.expand,
//                                             children: [
//                                               // Interactive viewer for pinch-to-zoom functionality
//                                               InteractiveViewer(
//                                                 panEnabled: true,
//                                                 minScale: 0.5,
//                                                 maxScale: 4,
//                                                 child: Image.network(
//                                                   menuImageUrl!,
//                                                   fit: BoxFit.contain,
//                                                 ),
//                                               ),
//                                               // Close button
//                                               Positioned(
//                                                 top: 40,
//                                                 right: 20,
//                                                 child: IconButton(
//                                                   icon: const Icon(
//                                                     Icons.close,
//                                                     color: Colors.white,
//                                                     size: 30,
//                                                   ),
//                                                   onPressed: () {
//                                                     Navigator.of(context).pop();
//                                                   },
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 },
//                                 child: Image.network(
//                                   menuImageUrl!,
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                   errorBuilder:
//                                       (context, error, stackTrace) =>
//                                           const Center(
//                                             child: Padding(
//                                               padding: EdgeInsets.all(40.0),
//                                               child: Text(
//                                                 "Could not load menu image",
//                                                 style: TextStyle(
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 8,
//                                   horizontal: 16,
//                                 ),
//                                 width: double.infinity,
//                                 color: Colors.grey.shade100,
//                                 child: const Text(
//                                   "Menu",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                       : const Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(20.0),
//                           child: Text(
//                             "No menu available",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                       ),

//                   const SizedBox(height: 24),

//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RestaurantBookingPage(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: const Text(
//                         "Book a Table",
//                         style: TextStyle(fontSize: 18),
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
//restaurant_details.dart
// import 'package:city_wheels/restaurants/restaurant_booking.dart';
// import 'package:city_wheels/restaurants/restaurant_map.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // import 'package:url_launcher/url_launcher.dart';

// class RestaurantDetailsPage extends StatefulWidget {
//   final String restaurantId;
//   final List<String> imageUrls;
//   final String name;
//   final double rating;
//   final String address;
//   final String phone;
//   final String description;
//   final String timing;
//   final bool isLiked;
//   final String? menuImageUrl; // Menu image URL field
//   final List<String> popularDishes; // Added popular dishes
//   final List<String> amenities; // Added amenities

//   const RestaurantDetailsPage({
//     super.key,
//     required this.restaurantId,
//     required this.imageUrls,
//     required this.name,
//     required this.rating,
//     required this.address,
//     required this.phone,
//     required this.description,
//     required this.timing,
//     required this.isLiked,
//     this.menuImageUrl, // Menu image URL from Firebase
//     this.popularDishes = const [], // Default to empty list
//     this.amenities = const [], // Default to empty list
//     required Null Function(bool newValue) onFavoriteToggled,
//     required Null Function(bool isFavorite) onFavoriteChanged,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
// }

// class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
//   late bool isLiked;
//   String? menuImageUrl;
//   List<String> popularDishes = [];
//   List<String> amenities = [];
//   bool isLoading = true;
//   double? latitude; // Added for location
//   double? longitude; // Added for location

//   @override
//   void initState() {
//     super.initState();
//     isLiked = widget.isLiked;
//     fetchRestaurantData();
//   }

//   Future<void> fetchRestaurantData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final restaurantDoc =
//           await FirebaseFirestore.instance
//               .collection('restaurant_details')
//               .doc(widget.restaurantId)
//               .get();

//       if (restaurantDoc.exists) {
//         final data = restaurantDoc.data();
//         if (data != null) {
//           setState(() {
//             // Safely extract menuImageUrl
//             menuImageUrl = data['menuImageUrl'] as String?;

//             // Safely extract popularDishes
//             if (data['popularDishes'] != null) {
//               final dishes = data['popularDishes'];
//               if (dishes is List) {
//                 popularDishes = dishes.map((item) => item.toString()).toList();
//               }
//             }

//             // Safely extract amenities
//             if (data['amenities'] != null) {
//               final amenitiesList = data['amenities'];
//               if (amenitiesList is List) {
//                 amenities =
//                     amenitiesList.map((item) => item.toString()).toList();
//               }
//             }

//             // Extract location coordinates
//             latitude = (data['latitude'] as num?)?.toDouble();
//             longitude = (data['longitude'] as num?)?.toDouble();

//             // If coordinates aren't in restaurant_details, try to fetch from restaurants collection
//             if (latitude == null || longitude == null) {
//               fetchCoordinatesFromRestaurants();
//             } else {
//               isLoading = false;
//             }
//           });
//         }
//         isLoading = false;
//       } else {
//         debugPrint('Restaurant details document does not exist');
//         // Try to fetch coordinates from restaurants collection as fallback
//         fetchCoordinatesFromRestaurants();
//       }
//     } catch (e) {
//       debugPrint('Error fetching restaurant details: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchCoordinatesFromRestaurants() async {
//     try {
//       final restaurantDoc =
//           await FirebaseFirestore.instance
//               .collection('restaurants')
//               .doc(widget.restaurantId)
//               .get();

//       if (restaurantDoc.exists) {
//         final data = restaurantDoc.data();
//         if (data != null) {
//           setState(() {
//             // Extract location coordinates
//             latitude = (data['latitude'] as num?)?.toDouble();
//             longitude = (data['longitude'] as num?)?.toDouble();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } else {
//         debugPrint(
//           'Restaurant document does not exist in restaurants collection',
//         );
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching restaurant from restaurants collection: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void toggleLike() {
//     setState(() {
//       isLiked = !isLiked;
//     });

//     // Update Firestore reference for likes in restaurant_details collection
//     FirebaseFirestore.instance
//         .collection('restaurant_details')
//         .doc(widget.restaurantId)
//         .update({'isLiked': isLiked});
//   }

//   void openMap() {
//     if (latitude != null && longitude != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => RestaurantMapPage(
//                 restaurantName: widget.name,
//                 latitude: latitude!,
//                 longitude: longitude!,
//               ),
//         ),
//       );
//     } else {
//       // Show a snackbar if coordinates are not available
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Restaurant location coordinates are not available'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Ensuring imageUrls is always a List and handles empty lists
//     List<String> imageUrls =
//         (widget.imageUrls.isNotEmpty)
//             ? widget.imageUrls
//             : ["https://via.placeholder.com/250"]; // Default image

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.name),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Image carousel with rating badge at bottom
//                     Stack(
//                       children: [
//                         // Carousel with proper handling for missing images
//                         CarouselSlider(
//                           options: CarouselOptions(
//                             height: 250,
//                             autoPlay: true,
//                             autoPlayInterval: const Duration(seconds: 3),
//                             autoPlayAnimationDuration: const Duration(
//                               milliseconds: 800,
//                             ),
//                             enlargeCenterPage: true,
//                             viewportFraction: 1.0,
//                           ),
//                           items:
//                               imageUrls.map((image) {
//                                 return ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.network(
//                                     image,
//                                     fit: BoxFit.cover,
//                                     width: double.infinity,
//                                     errorBuilder:
//                                         (context, error, stackTrace) =>
//                                             Image.network(
//                                               "https://via.placeholder.com/250",
//                                             ),
//                                   ),
//                                 );
//                               }).toList(),
//                         ),

//                         // Rating badge positioned at bottom of carousel
//                         Positioned(
//                           right: 16,
//                           top: 16,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(
//                                   Icons.star,
//                                   color: Colors.white,
//                                   size: 18,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   widget.rating.toStringAsFixed(1),
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   widget.description.isNotEmpty
//                                       ? widget.description
//                                       : "No description available",
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: toggleLike,
//                                 icon: Icon(
//                                   isLiked
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: isLiked ? Colors.red : Colors.grey,
//                                   size: 28,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),

//                           // Phone and timing information
//                           Text(
//                             "📞 ${widget.phone.isNotEmpty ? widget.phone : "N/A"}",
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           Text(
//                             "🕒 ${widget.timing.isNotEmpty ? widget.timing : "N/A"}",
//                             style: const TextStyle(fontSize: 16),
//                           ),

//                           const SizedBox(height: 24),

//                           // Menu Section
//                           const Text(
//                             "Menu",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 12),

//                           // Menu image with loading state
//                           menuImageUrl != null
//                               ? Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.grey.shade300,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       // ignore: deprecated_member_use
//                                       color: Colors.grey.withOpacity(0.3),
//                                       spreadRadius: 1,
//                                       blurRadius: 5,
//                                       offset: const Offset(0, 3),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Column(
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           // Show full screen dialog when menu image is tapped
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return Dialog(
//                                                 insetPadding: EdgeInsets.zero,
//                                                 child: Container(
//                                                   width: double.infinity,
//                                                   height: double.infinity,
//                                                   color: Colors.black,
//                                                   child: Stack(
//                                                     fit: StackFit.expand,
//                                                     children: [
//                                                       // Interactive viewer for pinch-to-zoom functionality
//                                                       InteractiveViewer(
//                                                         panEnabled: true,
//                                                         minScale: 0.5,
//                                                         maxScale: 4,
//                                                         child: Image.network(
//                                                           menuImageUrl!,
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                       ),
//                                                       // Close button
//                                                       Positioned(
//                                                         top: 40,
//                                                         right: 20,
//                                                         child: IconButton(
//                                                           icon: const Icon(
//                                                             Icons.close,
//                                                             color: Colors.white,
//                                                             size: 30,
//                                                           ),
//                                                           onPressed: () {
//                                                             Navigator.of(
//                                                               context,
//                                                             ).pop();
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Image.network(
//                                           menuImageUrl!,
//                                           fit: BoxFit.cover,
//                                           width: double.infinity,
//                                           errorBuilder:
//                                               (
//                                                 context,
//                                                 error,
//                                                 stackTrace,
//                                               ) => const Center(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.all(40.0),
//                                                   child: Text(
//                                                     "Could not load menu image",
//                                                     style: TextStyle(
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 8,
//                                           horizontal: 16,
//                                         ),
//                                         width: double.infinity,
//                                         color: Colors.grey.shade100,
//                                         child: const Text(
//                                           "Menu",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                               : const Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(20.0),
//                                   child: Text(
//                                     "No menu available",
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ),
//                               ),

//                           const SizedBox(height: 24),

//                           // Popular Dishes Section - Dynamically fetched from restaurant_details collection
//                           const Divider(thickness: 1),
//                           const Text(
//                             "Popular dishes",
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           popularDishes.isEmpty
//                               ? const Text(
//                                 "No popular dishes available",
//                                 style: TextStyle(color: Colors.grey),
//                               )
//                               : Wrap(
//                                 spacing: 8,
//                                 runSpacing: 16,
//                                 children:
//                                     popularDishes
//                                         .take(4) // Show at most 4 dishes
//                                         .map(
//                                           (dish) => SizedBox(
//                                             width:
//                                                 MediaQuery.of(
//                                                       context,
//                                                     ).size.width /
//                                                     2 -
//                                                 16,
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const Icon(
//                                                   Icons.restaurant,
//                                                   size: 16,
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Expanded(
//                                                   child: Text(
//                                                     dish,
//                                                     style: const TextStyle(
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                               ),

//                           const SizedBox(height: 24),

//                           // Location Section
//                           const Divider(thickness: 1),
//                           const Text(
//                             "Location",
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   widget.address.isNotEmpty
//                                       ? widget.address
//                                       : "Location not available",
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: openMap,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: const Icon(Icons.map, size: 24),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 24),

//                           // Amenities Section - Dynamically fetched from restaurant_details collection
//                           const Divider(thickness: 1),
//                           Row(
//                             children: [
//                               const Text(
//                                 "Amenities",
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "(${amenities.length})",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.grey.shade600,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           amenities.isEmpty
//                               ? const Text(
//                                 "No amenities available",
//                                 style: TextStyle(color: Colors.grey),
//                               )
//                               : Wrap(
//                                 spacing: 8,
//                                 runSpacing: 16,
//                                 children:
//                                     amenities
//                                         .map(
//                                           (amenity) => SizedBox(
//                                             width:
//                                                 MediaQuery.of(
//                                                       context,
//                                                     ).size.width /
//                                                     2 -
//                                                 16,
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const Icon(
//                                                   Icons.check_circle_outline,
//                                                   size: 16,
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Expanded(
//                                                   child: Text(
//                                                     amenity,
//                                                     style: const TextStyle(
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                               ),
//                           const SizedBox(height: 24),
//                           // Book Table Button
//                           const Divider(thickness: 1),
//                           const SizedBox(height: 16),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // Navigate to booking page
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) => RestaurantBookingPage(
//                                           // restaurantId: widget.restaurantId,
//                                           // restaurantName: widget.name,
//                                         ),
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.orangeAccent,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Book Table',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
// import 'package:city_wheels/restaurants/restaurant_booking.dart';
// import 'package:city_wheels/restaurants/restaurant_map.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // ignore: unused_import
// import 'package:intl/intl.dart';

// class RestaurantDetailsPage extends StatefulWidget {
//   final String restaurantId;
//   final List<String> imageUrls;
//   final String name;
//   final double rating;
//   final String address;
//   final String phone;
//   final String description;
//   final String timing;
//   final bool isLiked;
//   final String? menuImageUrl;
//   final List<String> popularDishes;
//   final List<String> amenities;
//   final String? standardTablePrice; // NEW FIELD

//   const RestaurantDetailsPage({
//     super.key,
//     required this.restaurantId,
//     required this.imageUrls,
//     required this.name,
//     required this.rating,
//     required this.address,
//     required this.phone,
//     required this.description,
//     required this.timing,
//     required this.isLiked,
//     this.menuImageUrl,
//     this.popularDishes = const [],
//     this.amenities = const [],
//     this.standardTablePrice, // NEW FIELD
//     required Null Function(bool newValue) onFavoriteToggled,
//     required Null Function(bool isFavorite) onFavoriteChanged,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
// }

// class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
//   late bool isLiked;
//   String? menuImageUrl;
//   List<String> popularDishes = [];
//   List<String> amenities = [];
//   bool isLoading = true;
//   double? latitude;
//   double? longitude;
//   String? standardTablePrice; // Added for "₹1,000 for two"
//   final TextEditingController _reviewController = TextEditingController();
//   double _userRating = 0.0; // For new review rating

//   @override
//   void initState() {
//     super.initState();
//     isLiked = widget.isLiked;
//     fetchRestaurantData();
//   }

//   Future<void> fetchRestaurantData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final restaurantDoc =
//           await FirebaseFirestore.instance
//               .collection('restaurant_details')
//               .doc(widget.restaurantId)
//               .get();

//       if (restaurantDoc.exists) {
//         final data = restaurantDoc.data();
//         if (data != null) {
//           setState(() {
//             // Safely extract menuImageUrl
//             menuImageUrl = data['menuImageUrl'] as String?;

//             //safely extract standardTable Price
//             standardTablePrice =
//                 data['standardTablePrice'] as String?; // Fetch price

//             // Safely extract popularDishes
//             if (data['popularDishes'] != null) {
//               final dishes = data['popularDishes'];
//               if (dishes is List) {
//                 popularDishes = dishes.map((item) => item.toString()).toList();
//               }
//             }

//             // Safely extract amenities
//             if (data['amenities'] != null) {
//               final amenitiesList = data['amenities'];
//               if (amenitiesList is List) {
//                 amenities =
//                     amenitiesList.map((item) => item.toString()).toList();
//               }
//             }

//             // Extract location coordinates
//             latitude = (data['latitude'] as num?)?.toDouble();
//             longitude = (data['longitude'] as num?)?.toDouble();

//             // If coordinates aren't in restaurant_details, try to fetch from restaurants collection
//             if (latitude == null || longitude == null) {
//               fetchCoordinatesFromRestaurants();
//             } else {
//               isLoading = false;
//             }
//           });
//         }
//         isLoading = false;
//       } else {
//         debugPrint('Restaurant details document does not exist');
//         // Try to fetch coordinates from restaurants collection as fallback
//         fetchCoordinatesFromRestaurants();
//       }
//     } catch (e) {
//       debugPrint('Error fetching restaurant details: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Submit new review to Firestore
//   Future<void> _submitReview() async {
//     if (_reviewController.text.isEmpty || _userRating == 0.0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add a rating and review text')),
//       );
//       return;
//     }

//     try {
//       await FirebaseFirestore.instance
//           .collection('restaurant_details')
//           .doc(widget.restaurantId)
//           .collection('reviews')
//           .add({
//             'rating': _userRating,
//             'text': _reviewController.text,
//             'timestamp': DateTime.now(),
//             'userName':
//                 'Anonymous', // Replace with actual user name if available
//             'userAvatar': '', // Add user avatar URL if available
//           });

//       _reviewController.clear();
//       setState(() {
//         _userRating = 0.0; // This will reset the stars
//       });
//       _userRating = 0.0;
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Review submitted successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to submit review: $e')));
//     }
//   }

//   Future<void> fetchCoordinatesFromRestaurants() async {
//     try {
//       final restaurantDoc =
//           await FirebaseFirestore.instance
//               .collection('restaurants')
//               .doc(widget.restaurantId)
//               .get();

//       if (restaurantDoc.exists) {
//         final data = restaurantDoc.data();
//         if (data != null) {
//           setState(() {
//             // Extract location coordinates
//             latitude = (data['latitude'] as num?)?.toDouble();
//             longitude = (data['longitude'] as num?)?.toDouble();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } else {
//         debugPrint(
//           'Restaurant document does not exist in restaurants collection',
//         );
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching restaurant from restaurants collection: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void toggleLike() {
//     setState(() {
//       isLiked = !isLiked;
//     });

//     // Update Firestore reference for likes in restaurant_details collection
//     FirebaseFirestore.instance
//         .collection('restaurant_details')
//         .doc(widget.restaurantId)
//         .update({'isLiked': isLiked});
//   }

//   void openMap() {
//     if (latitude != null && longitude != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => RestaurantMapPage(
//                 restaurantName: widget.name,
//                 latitude: latitude!,
//                 longitude: longitude!,
//               ),
//         ),
//       );
//     } else {
//       // Show a snackbar if coordinates are not available
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Restaurant location coordinates are not available'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Ensuring imageUrls is always a List and handles empty lists
//     List<String> imageUrls =
//         (widget.imageUrls.isNotEmpty)
//             ? widget.imageUrls
//             : ["https://via.placeholder.com/250"]; // Default image

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.name),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Image carousel with rating badge at bottom
//                     Stack(
//                       children: [
//                         // Carousel with proper handling for missing images
//                         CarouselSlider(
//                           options: CarouselOptions(
//                             height: 250,
//                             autoPlay: true,
//                             autoPlayInterval: const Duration(seconds: 3),
//                             autoPlayAnimationDuration: const Duration(
//                               milliseconds: 800,
//                             ),
//                             enlargeCenterPage: true,
//                             viewportFraction: 1.0,
//                           ),
//                           items:
//                               imageUrls.map((image) {
//                                 return ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.network(
//                                     image,
//                                     fit: BoxFit.cover,
//                                     width: double.infinity,
//                                     errorBuilder:
//                                         (context, error, stackTrace) =>
//                                             Image.network(
//                                               "https://via.placeholder.com/250",
//                                             ),
//                                   ),
//                                 );
//                               }).toList(),
//                         ),

//                         // Rating badge positioned at bottom of carousel
//                         Positioned(
//                           right: 16,
//                           top: 16,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(
//                                   Icons.star,
//                                   color: Colors.white,
//                                   size: 18,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   widget.rating.toStringAsFixed(1),
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   widget.description.isNotEmpty
//                                       ? widget.description
//                                       : "No description available",
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: toggleLike,
//                                 icon: Icon(
//                                   isLiked
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: isLiked ? Colors.red : Colors.grey,
//                                   size: 28,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),

//                           // Phone and timing information
//                           Text(
//                             "📞 ${widget.phone.isNotEmpty ? widget.phone : "N/A"}",
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           Text(
//                             "🕒 ${widget.timing.isNotEmpty ? widget.timing : "N/A"}",
//                             style: const TextStyle(fontSize: 16),
//                           ),

//                           // NEW: Standard Table Price
//                           // if (standardTablePrice != null)
//                           //   Text(
//                           //     "₹$standardTablePrice",
//                           //     style: const TextStyle(fontSize: 16),
//                           //   ),
//                           if (standardTablePrice != null)
//                             RichText(
//                               text: TextSpan(
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                                 children: [
//                                   const TextSpan(
//                                     text: "₹",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   TextSpan(text: standardTablePrice),
//                                 ],
//                               ),
//                             ),
//                           const SizedBox(height: 24),

//                           // Menu Section
//                           const Text(
//                             "Menu",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 12),

//                           // Menu image with loading state
//                           menuImageUrl != null
//                               ? Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.grey.shade300,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       // ignore: deprecated_member_use
//                                       color: Colors.grey.withOpacity(0.3),
//                                       spreadRadius: 1,
//                                       blurRadius: 5,
//                                       offset: const Offset(0, 3),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Column(
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           // Show full screen dialog when menu image is tapped
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return Dialog(
//                                                 insetPadding: EdgeInsets.zero,
//                                                 child: Container(
//                                                   width: double.infinity,
//                                                   height: double.infinity,
//                                                   color: Colors.black,
//                                                   child: Stack(
//                                                     fit: StackFit.expand,
//                                                     children: [
//                                                       // Interactive viewer for pinch-to-zoom functionality
//                                                       InteractiveViewer(
//                                                         panEnabled: true,
//                                                         minScale: 0.5,
//                                                         maxScale: 4,
//                                                         child: Image.network(
//                                                           menuImageUrl!,
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                       ),
//                                                       // Close button
//                                                       Positioned(
//                                                         top: 40,
//                                                         right: 20,
//                                                         child: IconButton(
//                                                           icon: const Icon(
//                                                             Icons.close,
//                                                             color: Colors.white,
//                                                             size: 30,
//                                                           ),
//                                                           onPressed: () {
//                                                             Navigator.of(
//                                                               context,
//                                                             ).pop();
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Image.network(
//                                           menuImageUrl!,
//                                           fit: BoxFit.cover,
//                                           width: double.infinity,
//                                           errorBuilder:
//                                               (
//                                                 context,
//                                                 error,
//                                                 stackTrace,
//                                               ) => const Center(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.all(40.0),
//                                                   child: Text(
//                                                     "Could not load menu image",
//                                                     style: TextStyle(
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 8,
//                                           horizontal: 16,
//                                         ),
//                                         width: double.infinity,
//                                         color: Colors.grey.shade100,
//                                         child: const Text(
//                                           "Menu",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                               : const Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(20.0),
//                                   child: Text(
//                                     "No menu available",
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ),
//                               ),

//                           const SizedBox(height: 24),

//                           // Popular Dishes Section - Dynamically fetched from restaurant_details collection
//                           const Divider(thickness: 1),
//                           const Text(
//                             "Popular dishes",
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           popularDishes.isEmpty
//                               ? const Text(
//                                 "No popular dishes available",
//                                 style: TextStyle(color: Colors.grey),
//                               )
//                               : Wrap(
//                                 spacing: 8,
//                                 runSpacing: 16,
//                                 children:
//                                     popularDishes
//                                         .take(4) // Show at most 4 dishes
//                                         .map(
//                                           (dish) => SizedBox(
//                                             width:
//                                                 MediaQuery.of(
//                                                       context,
//                                                     ).size.width /
//                                                     2 -
//                                                 16,
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const Icon(
//                                                   Icons.restaurant,
//                                                   size: 16,
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Expanded(
//                                                   child: Text(
//                                                     dish,
//                                                     style: const TextStyle(
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                               ),

//                           const SizedBox(height: 24),

//                           // Location Section
//                           const Divider(thickness: 1),
//                           const Text(
//                             "Location",
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   widget.address.isNotEmpty
//                                       ? widget.address
//                                       : "Location not available",
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: openMap,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: const Icon(Icons.map, size: 24),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 24),

//                           // Amenities Section - Dynamically fetched from restaurant_details collection
//                           const Divider(thickness: 1),
//                           Row(
//                             children: [
//                               const Text(
//                                 "Amenities",
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "(${amenities.length})",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.grey.shade600,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           amenities.isEmpty
//                               ? const Text(
//                                 "No amenities available",
//                                 style: TextStyle(color: Colors.grey),
//                               )
//                               : Wrap(
//                                 spacing: 8,
//                                 runSpacing: 16,
//                                 children:
//                                     amenities
//                                         .map(
//                                           (amenity) => SizedBox(
//                                             width:
//                                                 MediaQuery.of(
//                                                       context,
//                                                     ).size.width /
//                                                     2 -
//                                                 16,
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const Icon(
//                                                   Icons.check_circle_outline,
//                                                   size: 16,
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Expanded(
//                                                   child: Text(
//                                                     amenity,
//                                                     style: const TextStyle(
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                               ),
//                           const SizedBox(height: 24),

//                           // NEW: Reviews Section
//                           const Divider(thickness: 1),
//                           const Text(
//                             "Reviews",
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // Display Existing Reviews
//                           StreamBuilder<QuerySnapshot>(
//                             stream:
//                                 FirebaseFirestore.instance
//                                     .collection('restaurant_details')
//                                     .doc(widget.restaurantId)
//                                     .collection('reviews')
//                                     .orderBy('timestamp', descending: true)
//                                     .snapshots(),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               }

//                               if (!snapshot.hasData ||
//                                   snapshot.data!.docs.isEmpty) {
//                                 return const Text("No reviews yet");
//                               }

//                               return ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: snapshot.data!.docs.length,
//                                 itemBuilder: (context, index) {
//                                   final review = snapshot.data!.docs[index];
//                                   final data =
//                                       review.data() as Map<String, dynamic>;
//                                   return Card(
//                                     margin: const EdgeInsets.only(bottom: 12),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(12.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               CircleAvatar(
//                                                 backgroundImage:
//                                                     data['userAvatar'] != null
//                                                         ? NetworkImage(
//                                                           data['userAvatar'],
//                                                         )
//                                                         : null,
//                                                 child:
//                                                     data['userAvatar'] == null
//                                                         ? const Icon(
//                                                           Icons.person,
//                                                         )
//                                                         : null,
//                                               ),
//                                               const SizedBox(width: 8),
//                                               Text(
//                                                 data['userName'] ?? 'Anonymous',
//                                               ),
//                                               const Spacer(),
//                                               Text(
//                                                 DateFormat('MMM d, y').format(
//                                                   (data['timestamp']
//                                                           as Timestamp)
//                                                       .toDate(),
//                                                 ),
//                                                 style: TextStyle(
//                                                   color: Colors.grey[600],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Row(
//                                             children: List.generate(
//                                               5,
//                                               (i) => Icon(
//                                                 Icons.star,
//                                                 color:
//                                                     i <
//                                                             (data['rating']
//                                                                     as num)
//                                                                 .toInt()
//                                                         ? Colors.amber
//                                                         : Colors.grey,
//                                                 size: 20,
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Text(data['text']),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ),

//                           // Add Review Form
//                           const SizedBox(height: 24),
//                           const Text(
//                             "Write a Review",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: List.generate(
//                               5,
//                               (index) => IconButton(
//                                 icon: Icon(
//                                   Icons.star,
//                                   size: 30,
//                                   color:
//                                       index < _userRating
//                                           ? Colors.amber
//                                           : Colors.grey,
//                                 ),
//                                 onPressed:
//                                     () => setState(
//                                       () => _userRating = index + 1.0,
//                                     ),
//                               ),
//                             ),
//                           ),
//                           TextField(
//                             controller: _reviewController,
//                             decoration: const InputDecoration(
//                               hintText: "Share your experience...",
//                               border: OutlineInputBorder(),
//                             ),
//                             maxLines: 3,
//                           ),
//                           const SizedBox(height: 12),
//                           ElevatedButton(
//                             onPressed: _submitReview,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orangeAccent,
//                               minimumSize: const Size(double.infinity, 50),
//                             ),
//                             child: const Text(
//                               "Submit Review",
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ), // White text
//                             ),
//                           ),

//                           // Book Table Button
//                           const Divider(thickness: 1),
//                           const SizedBox(height: 16),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // Navigate to booking page
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) => RestaurantBookingPage(
//                                           restaurantId: widget.restaurantId,
//                                           // restaurantName: widget.name,
//                                           standardTablePrice:
//                                               widget.standardTablePrice,
//                                           // Add other required fields
//                                         ),
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.orangeAccent,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Book Table',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
import 'package:city_wheels/restaurants/restaurant_booking.dart';
import 'package:city_wheels/restaurants/restaurant_map.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String restaurantId;
  final List<String> imageUrls;
  final String name;
  final double rating;
  final String address;
  final String phone;
  final String description;
  final String timing;
  final bool isLiked;
  final String? menuImageUrl;
  final List<String> popularDishes;
  final List<String> amenities;
  final String? standardTablePrice; // NEW FIELD

  const RestaurantDetailsPage({
    super.key,
    required this.restaurantId,
    required this.imageUrls,
    required this.name,
    required this.rating,
    required this.address,
    required this.phone,
    required this.description,
    required this.timing,
    required this.isLiked,
    this.menuImageUrl,
    this.popularDishes = const [],
    this.amenities = const [],
    this.standardTablePrice, // NEW FIELD
    required Null Function(bool newValue) onFavoriteToggled,
    required Null Function(bool isFavorite) onFavoriteChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  late bool isLiked;
  String? menuImageUrl;
  List<String> popularDishes = [];
  List<String> amenities = [];
  bool isLoading = true;
  double? latitude;
  double? longitude;
  String? standardTablePrice; // Added for "₹1,000 for two"
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0.0; // For new review rating

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    fetchRestaurantData();
  }

  Future<void> fetchRestaurantData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final restaurantDoc =
          await FirebaseFirestore.instance
              .collection('restaurant_details')
              .doc(widget.restaurantId)
              .get();

      if (restaurantDoc.exists) {
        final data = restaurantDoc.data();
        if (data != null) {
          setState(() {
            // Safely extract menuImageUrl
            menuImageUrl = data['menuImageUrl'] as String?;

            //safely extract standardTable Price
            standardTablePrice =
                data['standardTablePrice'] as String?; // Fetch price
            debugPrint('Fetched standardTablePrice: $standardTablePrice');

            // Safely extract popularDishes
            if (data['popularDishes'] != null) {
              final dishes = data['popularDishes'];
              if (dishes is List) {
                popularDishes = dishes.map((item) => item.toString()).toList();
              }
            }

            // Safely extract amenities
            if (data['amenities'] != null) {
              final amenitiesList = data['amenities'];
              if (amenitiesList is List) {
                amenities =
                    amenitiesList.map((item) => item.toString()).toList();
              }
            }

            // Extract location coordinates
            latitude = (data['latitude'] as num?)?.toDouble();
            longitude = (data['longitude'] as num?)?.toDouble();

            // If coordinates aren't in restaurant_details, try to fetch from restaurants collection
            if (latitude == null || longitude == null) {
              fetchCoordinatesFromRestaurants();
            } else {
              isLoading = false;
            }
          });
        }
        isLoading = false;
      } else {
        debugPrint('Restaurant details document does not exist');
        // Try to fetch coordinates from restaurants collection as fallback
        fetchCoordinatesFromRestaurants();
      }
    } catch (e) {
      debugPrint('Error fetching restaurant details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Submit new review to Firestore
  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty || _userRating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a rating and review text')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('restaurant_details')
          .doc(widget.restaurantId)
          .collection('reviews')
          .add({
            'rating': _userRating,
            'text': _reviewController.text,
            'timestamp': DateTime.now(),
            'userName':
                'Anonymous', // Replace with actual user name if available
            'userAvatar': '', // Add user avatar URL if available
          });

      _reviewController.clear();
      setState(() {
        _userRating = 0.0; // This will reset the stars
      });
      _userRating = 0.0;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit review: $e')));
    }
  }

  Future<void> fetchCoordinatesFromRestaurants() async {
    try {
      final restaurantDoc =
          await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(widget.restaurantId)
              .get();

      if (restaurantDoc.exists) {
        final data = restaurantDoc.data();
        if (data != null) {
          setState(() {
            // Extract location coordinates
            latitude = (data['latitude'] as num?)?.toDouble();
            longitude = (data['longitude'] as num?)?.toDouble();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        debugPrint(
          'Restaurant document does not exist in restaurants collection',
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching restaurant from restaurants collection: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Update Firestore reference for likes in restaurant_details collection
    FirebaseFirestore.instance
        .collection('restaurant_details')
        .doc(widget.restaurantId)
        .update({'isLiked': isLiked});
  }

  void openMap() {
    if (latitude != null && longitude != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => RestaurantMapPage(
                restaurantName: widget.name,
                latitude: latitude!,
                longitude: longitude!,
              ),
        ),
      );
    } else {
      // Show a snackbar if coordinates are not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restaurant location coordinates are not available'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensuring imageUrls is always a List and handles empty lists
    List<String> imageUrls =
        (widget.imageUrls.isNotEmpty)
            ? widget.imageUrls
            : ["https://via.placeholder.com/250"]; // Default image

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.orangeAccent,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image carousel with rating badge at bottom
                    Stack(
                      children: [
                        // Carousel with proper handling for missing images
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                          ),
                          items:
                              imageUrls.map((image) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.network(
                                              "https://via.placeholder.com/250",
                                            ),
                                  ),
                                );
                              }).toList(),
                        ),

                        // Rating badge positioned at bottom of carousel
                        Positioned(
                          right: 16,
                          top: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.description.isNotEmpty
                                      ? widget.description
                                      : "No description available",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                onPressed: toggleLike,
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.grey,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Phone and timing information
                          Text(
                            "📞 ${widget.phone.isNotEmpty ? widget.phone : "N/A"}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "🕒 ${widget.timing.isNotEmpty ? widget.timing : "N/A"}",
                            style: const TextStyle(fontSize: 16),
                          ),

                          // NEW: Standard Table Price
                          // if (standardTablePrice != null)
                          //   Text(
                          //     "₹$standardTablePrice",
                          //     style: const TextStyle(fontSize: 16),
                          //   ),
                          if (standardTablePrice != null)
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "₹",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: standardTablePrice),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24),

                          // Menu Section
                          const Text(
                            "Menu",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Menu image with loading state
                          menuImageUrl != null
                              ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      // ignore: deprecated_member_use
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Show full screen dialog when menu image is tapped
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                insetPadding: EdgeInsets.zero,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  color: Colors.black,
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      // Interactive viewer for pinch-to-zoom functionality
                                                      InteractiveViewer(
                                                        panEnabled: true,
                                                        minScale: 0.5,
                                                        maxScale: 4,
                                                        child: Image.network(
                                                          menuImageUrl!,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      // Close button
                                                      Positioned(
                                                        top: 40,
                                                        right: 20,
                                                        child: IconButton(
                                                          icon: const Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.network(
                                          menuImageUrl!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(40.0),
                                                  child: Text(
                                                    "Could not load menu image",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        width: double.infinity,
                                        color: Colors.grey.shade100,
                                        child: const Text(
                                          "Menu",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    "No menu available",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),

                          const SizedBox(height: 24),

                          // Popular Dishes Section - Dynamically fetched from restaurant_details collection
                          const Divider(thickness: 1),
                          const Text(
                            "Popular dishes",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          popularDishes.isEmpty
                              ? const Text(
                                "No popular dishes available",
                                style: TextStyle(color: Colors.grey),
                              )
                              : Wrap(
                                spacing: 8,
                                runSpacing: 16,
                                children:
                                    popularDishes
                                        .take(4) // Show at most 4 dishes
                                        .map(
                                          (dish) => SizedBox(
                                            width:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    2 -
                                                16,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.restaurant,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    dish,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),

                          const SizedBox(height: 24),

                          // Location Section
                          const Divider(thickness: 1),
                          const Text(
                            "Location",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.address.isNotEmpty
                                      ? widget.address
                                      : "Location not available",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              GestureDetector(
                                onTap: openMap,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.map, size: 24),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Amenities Section - Dynamically fetched from restaurant_details collection
                          const Divider(thickness: 1),
                          Row(
                            children: [
                              const Text(
                                "Amenities",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "(${amenities.length})",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          amenities.isEmpty
                              ? const Text(
                                "No amenities available",
                                style: TextStyle(color: Colors.grey),
                              )
                              : Wrap(
                                spacing: 8,
                                runSpacing: 16,
                                children:
                                    amenities
                                        .map(
                                          (amenity) => SizedBox(
                                            width:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width /
                                                    2 -
                                                16,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_outline,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    amenity,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                          const SizedBox(height: 24),

                          // NEW: Reviews Section
                          const Divider(thickness: 1),
                          const Text(
                            "Reviews",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Display Existing Reviews
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('restaurant_details')
                                    .doc(widget.restaurantId)
                                    .collection('reviews')
                                    .orderBy('timestamp', descending: true)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Text("No reviews yet");
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final review = snapshot.data!.docs[index];
                                  final data =
                                      review.data() as Map<String, dynamic>;
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage:
                                                    data['userAvatar'] != null
                                                        ? NetworkImage(
                                                          data['userAvatar'],
                                                        )
                                                        : null,
                                                child:
                                                    data['userAvatar'] == null
                                                        ? const Icon(
                                                          Icons.person,
                                                        )
                                                        : null,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                data['userName'] ?? 'Anonymous',
                                              ),
                                              const Spacer(),
                                              Text(
                                                DateFormat('MMM d, y').format(
                                                  (data['timestamp']
                                                          as Timestamp)
                                                      .toDate(),
                                                ),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: List.generate(
                                              5,
                                              (i) => Icon(
                                                Icons.star,
                                                color:
                                                    i <
                                                            (data['rating']
                                                                    as num)
                                                                .toInt()
                                                        ? Colors.amber
                                                        : Colors.grey,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(data['text']),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          // Add Review Form
                          const SizedBox(height: 24),
                          const Text(
                            "Write a Review",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(
                              5,
                              (index) => IconButton(
                                icon: Icon(
                                  Icons.star,
                                  size: 30,
                                  color:
                                      index < _userRating
                                          ? Colors.amber
                                          : Colors.grey,
                                ),
                                onPressed:
                                    () => setState(
                                      () => _userRating = index + 1.0,
                                    ),
                              ),
                            ),
                          ),
                          TextField(
                            controller: _reviewController,
                            decoration: const InputDecoration(
                              hintText: "Share your experience...",
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submitReview,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              "Submit Review",
                              style: TextStyle(
                                color: Colors.white,
                              ), // White text
                            ),
                          ),

                          // Book Table Button
                          const Divider(thickness: 1),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to booking page
                                debugPrint(
                                  'Navigating with price: $standardTablePrice',
                                );
                                if (standardTablePrice == null) {
                                  debugPrint(
                                    'Warning: standardTablePrice is null when navigating',
                                  );
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RestaurantBookingPage(
                                          restaurantId: widget.restaurantId,
                                          // restaurantName: widget.name,
                                          standardTablePrice:
                                              standardTablePrice,
                                          restaurant: {},
                                          // Add other required fields
                                        ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Book Table',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
