// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../widgets/restaurant_card.dart';
// import '../restaurants/restaurant_details.dart';

// class RestaurantListingsPage extends StatelessWidget {
//   const RestaurantListingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Restaurants"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔍 Search Bar
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Search food or restaurant here...",
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // 🍽️ Popular Restaurants Section
//             const Text(
//               "Popular Restaurants Nearby",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             // 🔹 Fetch and Display Restaurant List
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream:
//                     FirebaseFirestore.instance
//                         .collection('restaurants')
//                         .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text("No restaurants found"));
//                   }

//                   final restaurants = snapshot.data!.docs;

//                   return ListView.builder(
//                     itemCount: restaurants.length,
//                     itemBuilder: (context, index) {
//                       var doc = restaurants[index];
//                       var restaurantData = doc.data() as Map<String, dynamic>;

//                       // ignore: avoid_print
//                       print(restaurantData['name']);

//                       String detailsId =
//                           restaurantData['detailsId'] ?? ''; // Fetch detailsId
//                       if (detailsId.isEmpty) {
//                         return const SizedBox(); // Skip if detailsId is missing
//                       }

//                       return FutureBuilder<DocumentSnapshot>(
//                         future:
//                             FirebaseFirestore.instance
//                                 .collection('restaurant_details')
//                                 .doc(detailsId)
//                                 .get(),
//                         builder: (context, detailsSnapshot) {
//                           if (detailsSnapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           if (!detailsSnapshot.hasData ||
//                               !detailsSnapshot.data!.exists) {
//                             return const Center(
//                               child: Text("Restaurant details not found"),
//                             );
//                           }

//                           var detailsData =
//                               detailsSnapshot.data!.data()
//                                   as Map<String, dynamic>;

//                           List<String> imageUrls =
//                               (detailsData['imageUrl'] as List<dynamic>?)
//                                   ?.map((e) => e.toString())
//                                   .toList() ??
//                               [];

//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => RestaurantDetailsPage(
//                                         restaurantId: doc.id,
//                                         imageUrls: imageUrls,
//                                         name: detailsData['name'],
//                                         rating:
//                                             (detailsData['rating'] as num?)
//                                                 ?.toDouble() ??
//                                             0.0,
//                                         address:
//                                             detailsData['address'] ??
//                                             'Unknown address',
//                                         phone:
//                                             detailsData['phone']?.toString() ??
//                                             'N/A',
//                                         description:
//                                             detailsData['description'] ??
//                                             'No description available',
//                                         timing: detailsData['timing'] ?? 'N/A',
//                                         isLiked:
//                                             detailsData['isLiked'] ?? false,
//                                       ),
//                                 ),
//                               );
//                             },
//                             child: RestaurantCard(
//                               documentId: doc.id,
//                               imageUrl: restaurantData['imageUrl'] ?? 'NA',
//                               name: restaurantData['name'],
//                               cuisine: restaurantData['cuisine'] ?? 'Unknown',
//                               rating:
//                                   (restaurantData['rating'] as num?)
//                                       ?.toDouble() ??
//                                   0.0,
//                               isLiked: restaurantData['isLiked'] ?? false,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import '../widgets/restaurant_card.dart';
// import '../restaurants/restaurant_details.dart';

// class RestaurantListingsPage extends StatefulWidget {
//   const RestaurantListingsPage({super.key});

//   @override
//   State<RestaurantListingsPage> createState() => _RestaurantListingsPageState();
// }

// class _RestaurantListingsPageState extends State<RestaurantListingsPage> {
//   // Search functionality variables
//   String searchQuery = "";
//   List<QueryDocumentSnapshot> allRestaurants = [];
//   List<QueryDocumentSnapshot> filteredRestaurants = [];
//   bool isLoading = true;

//   // Debounce timer to prevent excessive filtering
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     fetchRestaurants();
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   // Fetch all restaurants initially
//   Future<void> fetchRestaurants() async {
//     try {
//       final snapshot =
//           await FirebaseFirestore.instance.collection('restaurants').get();

//       setState(() {
//         allRestaurants = snapshot.docs;
//         filteredRestaurants = List.from(allRestaurants);
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error fetching restaurants: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Filter restaurants based on search query
//   void filterRestaurants(String query) {
//     setState(() {
//       searchQuery = query;
//       if (query.isEmpty) {
//         // If search is empty, show all restaurants
//         filteredRestaurants = List.from(allRestaurants);
//       } else {
//         // Filter restaurants that start with the query (case insensitive)
//         filteredRestaurants =
//             allRestaurants.where((doc) {
//               final restaurantData = doc.data() as Map<String, dynamic>;
//               final restaurantName =
//                   restaurantData['name'].toString().toLowerCase();
//               final searchLower = query.toLowerCase();
//               return restaurantName.startsWith(searchLower);
//             }).toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Restaurants"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔍 Search Bar with debouncing
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Search food or restaurant here...",
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 suffixIcon:
//                     searchQuery.isNotEmpty
//                         ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             setState(() {
//                               searchQuery = "";
//                               filteredRestaurants = List.from(allRestaurants);
//                             });
//                             // Clear the text field
//                             FocusScope.of(context).unfocus();
//                           },
//                         )
//                         : null,
//               ),
//               onChanged: (value) {
//                 // Debounce search to avoid excessive filtering
//                 if (_debounce?.isActive ?? false) _debounce!.cancel();
//                 _debounce = Timer(const Duration(milliseconds: 500), () {
//                   filterRestaurants(value);
//                 });
//               },
//             ),
//             const SizedBox(height: 20),

//             // 🍽️ Section title with result count
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Popular Restaurants Nearby",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 if (!isLoading)
//                   Text(
//                     "${filteredRestaurants.length} results",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 10),

//             // 🔹 Display restaurant list or appropriate messages
//             isLoading
//                 ? const Expanded(
//                   child: Center(child: CircularProgressIndicator()),
//                 )
//                 : filteredRestaurants.isEmpty && searchQuery.isNotEmpty
//                 ? Expanded(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.search_off,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "No restaurants found matching '$searchQuery'",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//                 : Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredRestaurants.length,
//                     itemBuilder: (context, index) {
//                       var doc = filteredRestaurants[index];
//                       var restaurantData = doc.data() as Map<String, dynamic>;

//                       String detailsId = restaurantData['detailsId'] ?? '';
//                       if (detailsId.isEmpty) {
//                         return const SizedBox(); // Skip if detailsId is missing
//                       }

//                       return FutureBuilder<DocumentSnapshot>(
//                         future:
//                             FirebaseFirestore.instance
//                                 .collection('restaurant_details')
//                                 .doc(detailsId)
//                                 .get(),
//                         builder: (context, detailsSnapshot) {
//                           if (detailsSnapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           if (!detailsSnapshot.hasData ||
//                               !detailsSnapshot.data!.exists) {
//                             return const Center(
//                               child: Text("Restaurant details not found"),
//                             );
//                           }

//                           var detailsData =
//                               detailsSnapshot.data!.data()
//                                   as Map<String, dynamic>;

//                           List<String> imageUrls =
//                               (detailsData['imageUrl'] as List<dynamic>?)
//                                   ?.map((e) => e.toString())
//                                   .toList() ??
//                               [];

//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => RestaurantDetailsPage(
//                                         restaurantId: doc.id,
//                                         imageUrls: imageUrls,
//                                         name: detailsData['name'],
//                                         rating:
//                                             (detailsData['rating'] as num?)
//                                                 ?.toDouble() ??
//                                             0.0,
//                                         address:
//                                             detailsData['address'] ??
//                                             'Unknown address',
//                                         phone:
//                                             detailsData['phone']?.toString() ??
//                                             'N/A',
//                                         description:
//                                             detailsData['description'] ??
//                                             'No description available',
//                                         timing: detailsData['timing'] ?? 'N/A',
//                                         isLiked:
//                                             detailsData['isLiked'] ?? false,
//                                       ),
//                                 ),
//                               );
//                             },
//                             child: RestaurantCard(
//                               documentId: doc.id,
//                               imageUrl: restaurantData['imageUrl'] ?? 'NA',
//                               name: restaurantData['name'],
//                               cuisine: restaurantData['cuisine'] ?? 'Unknown',
//                               rating:
//                                   (restaurantData['rating'] as num?)
//                                       ?.toDouble() ??
//                                   0.0,
//                               isLiked: restaurantData['isLiked'] ?? false,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//Most important above implementation

// //restaurant_listings.dart
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../widgets/restaurant_card.dart';
// import '../restaurants/restaurant_details.dart';
// import '../restaurants/favorites_page.dart';
// import '../restaurants/categories_page.dart';
// import '../restaurants/services.dart';

// class RestaurantListingsPage extends StatefulWidget {
//   const RestaurantListingsPage({super.key});

//   @override
//   State<RestaurantListingsPage> createState() => _RestaurantListingsPageState();
// }

// class _RestaurantListingsPageState extends State<RestaurantListingsPage> {
//   List<Map<String, dynamic>> restaurants = [];
//   List<Map<String, dynamic>> favoriteRestaurants = [];
//   String searchQuery = "";
//   List<Map<String, dynamic>> filteredRestaurants = [];
//   String selectedCategory = "";
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchRestaurants();
//   }

//   Future<void> fetchRestaurants() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection("restaurants").get();

//       List<Map<String, dynamic>> restaurantsList = [];
//       for (var doc in snapshot.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         String detailsId = data['detailsId'] ?? '';

//         if (detailsId.isNotEmpty) {
//           try {
//             DocumentSnapshot detailsSnapshot =
//                 await FirebaseFirestore.instance
//                     .collection('restaurant_details')
//                     .doc(detailsId)
//                     .get();

//             if (detailsSnapshot.exists) {
//               Map<String, dynamic> detailsData =
//                   detailsSnapshot.data() as Map<String, dynamic>;

//               restaurantsList.add({
//                 "id": doc.id,
//                 "detailsId": detailsId,
//                 "image": data["imageUrl"] ?? "",
//                 "name": data["name"] ?? "",
//                 "cuisine": data["cuisine"] ?? "General",
//                 "rating": (data["rating"] as num?)?.toString() ?? "0.0",
//                 "isLiked": data["isLiked"] ?? false,
//                 "address": detailsData["address"] ?? "",
//                 "phone": detailsData["phone"]?.toString() ?? "N/A",
//                 "description": detailsData["description"] ?? "",
//                 "timing": detailsData["timing"] ?? "",
//                 "imageUrls":
//                     (detailsData["imageUrl"] as List<dynamic>?)
//                         ?.map((e) => e.toString())
//                         .toList() ??
//                     [],
//                 "category":
//                     data["category"] ??
//                     "Popular", // Ensure category field exists
//               });
//               // Debugging prints
//               debugPrint("Added Restaurant: ${restaurantsList.last}");
//               debugPrint("Raw Firestore Data for ${doc.id}: $data");
//               debugPrint(
//                 "Raw Firestore Details Data for $detailsId: $detailsData",
//               );

//               // Print full list after all additions
//               debugPrint(
//                 "Final Restaurants List: ${jsonEncode(restaurantsList)}",
//               );
//             }
//           } catch (e) {
//             debugPrint("Error fetching restaurant details: $e");
//           }
//         }
//       }

//       setState(() {
//         restaurants = restaurantsList;
//         filteredRestaurants = List.from(restaurants);
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error fetching restaurants: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Enhanced search functionality similar to hotels_page.dart
//   void filterRestaurants(String query) {
//     setState(() {
//       searchQuery = query;
//       if (query.isEmpty && selectedCategory.isEmpty) {
//         // If search is empty and no category filter, show all restaurants
//         filteredRestaurants = List.from(restaurants);
//       } else {
//         // Filter restaurants based on search query and/or selected category
//         filteredRestaurants =
//             restaurants.where((restaurant) {
//               final restaurantName =
//                   restaurant["name"].toString().toLowerCase();
//               final restaurantCuisine =
//                   restaurant["cuisine"].toString().toLowerCase();
//               final restaurantAddress =
//                   restaurant["address"].toString().toLowerCase();
//               final searchLower = query.toLowerCase();

//               bool matchesSearch =
//                   query.isEmpty ||
//                   restaurantName.contains(searchLower) ||
//                   restaurantCuisine.contains(searchLower) ||
//                   restaurantAddress.contains(searchLower);

//               bool matchesCategory =
//                   selectedCategory.isEmpty ||
//                   restaurant["category"].toString() == selectedCategory;

//               return matchesSearch && matchesCategory;
//             }).toList();
//       }
//     });
//   }

//   // Filter by category
//   void filterByCategory(String category) {
//     setState(() {
//       if (selectedCategory == category) {
//         // If same category is clicked again, clear the filter
//         selectedCategory = "";
//       } else {
//         selectedCategory = category;
//       }

//       // Apply both filters
//       filterRestaurants(searchQuery);
//     });
//   }

//   // Sort restaurants by rating
//   void sortByRating() {
//     setState(() {
//       filteredRestaurants.sort((a, b) {
//         double ratingA = double.parse(a["rating"].toString());
//         double ratingB = double.parse(b["rating"].toString());
//         return ratingB.compareTo(ratingA);
//       });
//     });
//     _showSnackbar("Sorted by highest rating");
//   }

//   // Sort by name alphabetically
//   void sortByName() {
//     setState(() {
//       filteredRestaurants.sort((a, b) {
//         return a["name"].toString().compareTo(b["name"].toString());
//       });
//     });
//     _showSnackbar("Sorted alphabetically by name");
//   }

//   // Sort by cuisine type
//   void sortByCuisine() {
//     setState(() {
//       filteredRestaurants.sort((a, b) {
//         return a["cuisine"].toString().compareTo(b["cuisine"].toString());
//       });
//     });
//     _showSnackbar("Sorted by cuisine type");
//   }

//   /// Toggles restaurant as favorite or removes from favorites
//   void toggleFavorite(Map<String, dynamic> restaurant) {
//     setState(() {
//       bool isRemoving = favoriteRestaurants.any(
//         (fav) => fav["id"] == restaurant["id"],
//       );
//       if (isRemoving) {
//         favoriteRestaurants.removeWhere((fav) => fav["id"] == restaurant["id"]);
//         _showSnackbar("${restaurant["name"]} removed from favorites");
//       } else {
//         favoriteRestaurants.add(restaurant);
//         _showSnackbar("${restaurant["name"]} added to favorites");
//       }
//     });
//   }

//   /// Displays a snackbar message
//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Restaurants"),
//         // backgroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () {
//               _showSortFilterDialog();
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.favorite, color: Colors.red),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder:
//                       (context) => FavoritesPage(
//                         favoriteRestaurants: favoriteRestaurants,
//                         onRemoveFavorite: (restaurant) {
//                           // This will be called when a restaurant is removed from favorites
//                           removeFromFavorites(restaurant);
//                         },
//                       ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//                 onRefresh: fetchRestaurants,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSearchBar(),
//                       _buildSectionTitle(
//                         context,
//                         "Categories",
//                         const CategoriesPage(), // This remains the same
//                       ),
//                       _buildCategoriesList(),
//                       _buildSectionTitle(
//                         context,
//                         "Featured Restaurants",
//                         const SizedBox.shrink(), // This is a placeholder, navigation is handled in _buildSectionTitle
//                       ),
//                       _buildFeaturedRestaurants(),
//                       _buildSectionTitle(
//                         context,
//                         "Popular Restaurants Nearby",
//                         const SizedBox.shrink(), // This is a placeholder, navigation is handled in _buildSectionTitle
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "${filteredRestaurants.length} restaurants found",
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       _buildRestaurantList(),
//                     ],
//                   ),
//                 ),
//               ),
//     );
//   }

//   // Show sort and filter dialog
//   void _showSortFilterDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Sort & Filter",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.star),
//                 title: const Text("Top Rated"),
//                 onTap: () {
//                   sortByRating();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.sort_by_alpha),
//                 title: const Text("Alphabetically"),
//                 onTap: () {
//                   sortByName();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.restaurant_menu),
//                 title: const Text("By Cuisine"),
//                 onTap: () {
//                   sortByCuisine();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.clear_all),
//                 title: const Text("Clear All Filters"),
//                 onTap: () {
//                   setState(() {
//                     selectedCategory = "";
//                     searchQuery = "";
//                     filteredRestaurants = List.from(restaurants);
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: "Search for restaurants, cuisines, or addresses...",
//           prefixIcon: const Icon(Icons.search),
//           suffixIcon:
//               searchQuery.isNotEmpty
//                   ? IconButton(
//                     icon: const Icon(Icons.clear),
//                     onPressed: () {
//                       setState(() {
//                         searchQuery = "";
//                         filteredRestaurants = List.from(restaurants);
//                       });
//                     },
//                   )
//                   : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: Colors.blue.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Colors.blue, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.blue.shade50,
//         ),
//         onChanged: filterRestaurants,
//       ),
//     );
//   }

//   Widget _buildCategoriesList() {
//     List<String> categories = [
//       "Popular",
//       "Fast Food",
//       "Italian",
//       "Chinese",
//       "Indian",
//       "Continental",
//     ];
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children:
//             categories
//                 .map(
//                   (category) => Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: InkWell(
//                       onTap: () => filterByCategory(category),
//                       child: Chip(
//                         label: Text(category),
//                         backgroundColor:
//                             selectedCategory == category
//                                 ? Colors.blue
//                                 : Colors.blue.shade100,
//                         labelStyle: TextStyle(
//                           color:
//                               selectedCategory == category
//                                   ? Colors.white
//                                   : Colors.blue.shade900,
//                           fontWeight:
//                               selectedCategory == category
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//                 .toList(),
//       ),
//     );
//   }

//   Widget _buildFeaturedRestaurants() {
//     // Get top 5 highly rated restaurants for featured section
//     List<Map<String, dynamic>> topRestaurants = List.from(restaurants);
//     topRestaurants.sort(
//       (a, b) => double.parse(
//         b["rating"].toString(),
//       ).compareTo(double.parse(a["rating"].toString())),
//     );
//     topRestaurants = topRestaurants.take(5).toList();

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children:
//             topRestaurants.map((restaurant) {
//               final isFavorite = favoriteRestaurants.any(
//                 (fav) => fav["id"] == restaurant["id"],
//               );

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => RestaurantDetailsPage(
//                             restaurantId: restaurant["detailsId"],
//                             imageUrls:
//                                 restaurant["imageUrls"] ??
//                                 [], // Add fallback for null
//                             name: restaurant["name"] ?? "",
//                             rating: double.parse(restaurant["rating"] ?? "0"),
//                             address: restaurant["address"] ?? "",
//                             phone: restaurant["phone"] ?? "N/A",
//                             description: restaurant["description"] ?? "",
//                             timing: restaurant["timing"] ?? "",
//                             isLiked: isFavorite,
//                             // Add onFavoriteToggled callback if needed
//                             onFavoriteToggled: (bool newValue) {
//                               if (newValue) {
//                                 favoriteRestaurants.add(restaurant);
//                               } else {
//                                 favoriteRestaurants.removeWhere(
//                                   (fav) => fav["id"] == restaurant["id"],
//                                 );
//                               }
//                               setState(() {});
//                             },
//                             onFavoriteChanged: (bool isFavorite) {},
//                           ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 250,
//                   margin: const EdgeInsets.only(right: 10),
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(12),
//                           ),
//                           child: Stack(
//                             children: [
//                               Image.network(
//                                 restaurant["image"],
//                                 height: 150,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     height: 150,
//                                     width: double.infinity,
//                                     color: Colors.grey.shade300,
//                                     child: const Icon(
//                                       Icons.restaurant,
//                                       size: 50,
//                                     ),
//                                   );
//                                 },
//                               ),
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.star,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                       const SizedBox(width: 2),
//                                       Text(
//                                         restaurant["rating"],
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               // Positioned(
//                               //   bottom: 0,
//                               //   right: 0,
//                               //   child: IconButton(
//                               //     icon: Icon(
//                               //       isFavorite
//                               //           ? Icons.favorite
//                               //           : Icons.favorite_border,
//                               //       color: Colors.red,
//                               //     ),
//                               //     onPressed: () => toggleFavorite(restaurant),
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ),
//                         // Inside the Padding widget in _buildFeaturedRestaurants() method
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       restaurant["name"],
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: Icon(
//                                       isFavorite
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       color: Colors.red,
//                                     ),
//                                     onPressed: () => toggleFavorite(restaurant),
//                                     padding: EdgeInsets.zero,
//                                     constraints: const BoxConstraints(),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 restaurant["cuisine"],
//                                 style: TextStyle(color: Colors.grey.shade700),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 restaurant["address"],
//                                 style: TextStyle(color: Colors.grey.shade600),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//       ),
//     );
//   }

//   Widget _buildRestaurantList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: filteredRestaurants.length,
//       itemBuilder: (context, index) {
//         final restaurant = filteredRestaurants[index];
//         final isFavorite = favoriteRestaurants.any(
//           (fav) => fav["id"] == restaurant["id"],
//         );

//         return RestaurantCard(
//           restaurant: restaurant,
//           isFavorite: isFavorite,
//           onFavoriteToggle: () => toggleFavorite(restaurant),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (context) => RestaurantDetailsPage(
//                       restaurantId: restaurant["detailsId"],
//                       imageUrls:
//                           restaurant["imageUrls"] ??
//                           [], // Add fallback for null
//                       name: restaurant["name"] ?? "",
//                       rating: double.parse(restaurant["rating"] ?? "0"),
//                       address: restaurant["address"] ?? "",
//                       phone: restaurant["phone"] ?? "N/A",
//                       description: restaurant["description"] ?? "",
//                       timing: restaurant["timing"] ?? "",
//                       isLiked:
//                           true, // Always true since we're in favorites page
//                       // Update the callback to handle the favorite toggle properly
//                       onFavoriteToggled: (bool newValue) {
//                         if (!newValue) {
//                           // If toggled to false, remove from favorites
//                           removeFromFavorites(restaurant);
//                         }
//                         // No need to add to favorites since we're already in favorites page
//                       },
//                       onFavoriteChanged: (bool isFavorite) {},
//                     ),
//               ),
//             ).then((_) {
//               // This refresh may no longer be needed since we're handling changes in the callback
//               // But keeping it for safety to ensure UI is in sync
//               setState(() {
//                 // Ensure our local favorites list matches the parent's list
//               });
//             });
//           },
//         );
//       },
//     );
//   }

//   // Widget _buildSectionTitle(BuildContext context, String title, Widget page) {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(vertical: 16.0),
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //       children: [
//   //         Text(
//   //           title,
//   //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//   //         ),
//   //         InkWell(
//   //           onTap: () {
//   //             if (title == "Categories") {
//   //               Navigator.push(
//   //                 context,
//   //                 MaterialPageRoute(builder: (context) => page),
//   //               );
//   //             } else {}
//   //           },
//   //           child: Text(
//   //             "See All",
//   //             style: TextStyle(
//   //               color: Colors.blue.shade700,
//   //               fontWeight: FontWeight.w500,
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   // Then modify the _buildSectionTitle method in the _RestaurantListingsPageState class
//   Widget _buildSectionTitle(BuildContext context, String title, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           InkWell(
//             onTap: () {
//               if (title == "Categories") {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => page),
//                 );
//               } else if (title == "Featured Restaurants") {
//                 // Navigate to ServicesPage with featured restaurants (top rated)
//                 List<Map<String, dynamic>> topRestaurants = List.from(
//                   restaurants,
//                 );
//                 topRestaurants.sort(
//                   (a, b) => double.parse(
//                     b["rating"].toString(),
//                   ).compareTo(double.parse(a["rating"].toString())),
//                 );

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (context) => ServicesPage(
//                           restaurants: topRestaurants,
//                           favoriteRestaurants: favoriteRestaurants,
//                           title: "Featured Restaurants",
//                           toggleFavorite: toggleFavorite,
//                         ),
//                   ),
//                 );
//               } else if (title == "Popular Restaurants Nearby") {
//                 // Navigate to ServicesPage with all restaurants
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (context) => ServicesPage(
//                           restaurants: restaurants,
//                           favoriteRestaurants: favoriteRestaurants,
//                           title: "All Restaurants",
//                           toggleFavorite: toggleFavorite,
//                         ),
//                   ),
//                 );
//               }
//             },
//             child: Text(
//               "See All",
//               style: TextStyle(
//                 color: Colors.blue.shade700,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void removeFromFavorites(Map<String, dynamic> restaurant) {
//     setState(() {
//       favoriteRestaurants.removeWhere((fav) => fav["id"] == restaurant["id"]);
//       _showSnackbar("${restaurant["name"]} removed from favorites");

//       // If you're storing favorites in some persistence (like SharedPreferences)
//       // saveFavorites(); // You would implement this method to save the updated list
//     });
//   }
// }
//restaurant_listings.dart
import 'dart:convert';

import 'package:city_wheels/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/restaurant_card.dart';
import '../restaurants/restaurant_details.dart';
import '../restaurants/favorites_page.dart';
import '../restaurants/categories_page.dart';
import '../restaurants/services.dart';

class RestaurantListingsPage extends StatefulWidget {
  const RestaurantListingsPage({super.key});

  @override
  State<RestaurantListingsPage> createState() => _RestaurantListingsPageState();
}

class _RestaurantListingsPageState extends State<RestaurantListingsPage> {
  List<Map<String, dynamic>> restaurants = [];
  List<Map<String, dynamic>> favoriteRestaurants = [];
  String searchQuery = "";
  List<Map<String, dynamic>> filteredRestaurants = [];
  String selectedCategory = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("restaurants").get();

      List<Map<String, dynamic>> restaurantsList = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String detailsId = data['detailsId'] ?? '';

        if (detailsId.isNotEmpty) {
          try {
            DocumentSnapshot detailsSnapshot =
                await FirebaseFirestore.instance
                    .collection('restaurant_details')
                    .doc(detailsId)
                    .get();

            if (detailsSnapshot.exists) {
              Map<String, dynamic> detailsData =
                  detailsSnapshot.data() as Map<String, dynamic>;

              restaurantsList.add({
                "id": doc.id,
                "detailsId": detailsId,
                "image": data["imageUrl"] ?? "",
                "name": data["name"] ?? "",
                "cuisine": data["cuisine"] ?? "General",
                "rating": (data["rating"] as num?)?.toString() ?? "0.0",
                "isLiked": data["isLiked"] ?? false,
                "address": detailsData["address"] ?? "",
                "phone": detailsData["phone"]?.toString() ?? "N/A",
                "description": detailsData["description"] ?? "",
                "timing": detailsData["timing"] ?? "",
                "imageUrls":
                    (detailsData["imageUrl"] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .toList() ??
                    [],
                "category":
                    data["category"] ??
                    "Popular", // Ensure category field exists
              });
              // Debugging prints
              debugPrint("Added Restaurant: ${restaurantsList.last}");
              debugPrint("Raw Firestore Data for ${doc.id}: $data");
              debugPrint(
                "Raw Firestore Details Data for $detailsId: $detailsData",
              );

              // Print full list after all additions
              debugPrint(
                "Final Restaurants List: ${jsonEncode(restaurantsList)}",
              );
            }
          } catch (e) {
            debugPrint("Error fetching restaurant details: $e");
          }
        }
      }

      setState(() {
        restaurants = restaurantsList;
        filteredRestaurants = List.from(restaurants);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching restaurants: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _checkAuthentication() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user != null;
    } catch (e) {
      debugPrint("Error checking authentication: $e");
      return false;
    }
  }

  // Enhanced search functionality similar to hotels_page.dart
  void filterRestaurants(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty && selectedCategory.isEmpty) {
        // If search is empty and no category filter, show all restaurants
        filteredRestaurants = List.from(restaurants);
      } else {
        // Filter restaurants based on search query and/or selected category
        filteredRestaurants =
            restaurants.where((restaurant) {
              final restaurantName =
                  restaurant["name"].toString().toLowerCase();
              final restaurantCuisine =
                  restaurant["cuisine"].toString().toLowerCase();
              final restaurantAddress =
                  restaurant["address"].toString().toLowerCase();
              final searchLower = query.toLowerCase();

              bool matchesSearch =
                  query.isEmpty ||
                  restaurantName.contains(searchLower) ||
                  restaurantCuisine.contains(searchLower) ||
                  restaurantAddress.contains(searchLower);

              bool matchesCategory =
                  selectedCategory.isEmpty ||
                  restaurant["category"].toString() == selectedCategory;

              return matchesSearch && matchesCategory;
            }).toList();
      }
    });
  }

  // Filter by category
  void filterByCategory(String category) {
    setState(() {
      if (selectedCategory == category) {
        // If same category is clicked again, clear the filter
        selectedCategory = "";
      } else {
        selectedCategory = category;
      }

      // Apply both filters
      filterRestaurants(searchQuery);
    });
  }

  // Sort restaurants by rating
  void sortByRating() {
    setState(() {
      filteredRestaurants.sort((a, b) {
        double ratingA = double.parse(a["rating"].toString());
        double ratingB = double.parse(b["rating"].toString());
        return ratingB.compareTo(ratingA);
      });
    });
    _showSnackbar("Sorted by highest rating");
  }

  // Sort by name alphabetically
  void sortByName() {
    setState(() {
      filteredRestaurants.sort((a, b) {
        return a["name"].toString().compareTo(b["name"].toString());
      });
    });
    _showSnackbar("Sorted alphabetically by name");
  }

  // Sort by cuisine type
  void sortByCuisine() {
    setState(() {
      filteredRestaurants.sort((a, b) {
        return a["cuisine"].toString().compareTo(b["cuisine"].toString());
      });
    });
    _showSnackbar("Sorted by cuisine type");
  }

  /// Toggles restaurant as favorite or removes from favorites
  void toggleFavorite(Map<String, dynamic> restaurant) {
    setState(() {
      bool isRemoving = favoriteRestaurants.any(
        (fav) => fav["id"] == restaurant["id"],
      );
      if (isRemoving) {
        favoriteRestaurants.removeWhere((fav) => fav["id"] == restaurant["id"]);
        _showSnackbar("${restaurant["name"]} removed from favorites");
      } else {
        favoriteRestaurants.add(restaurant);
        _showSnackbar("${restaurant["name"]} added to favorites");
      }
    });
  }

  /// Displays a snackbar message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants"),
        // backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showSortFilterDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FavoritesPage(
                        favoriteRestaurants: favoriteRestaurants,
                        onRemoveFavorite: (restaurant) {
                          // This will be called when a restaurant is removed from favorites
                          removeFromFavorites(restaurant);
                        },
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchRestaurants,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      _buildSectionTitle(
                        context,
                        "Categories",
                        const CategoriesPage(), // This remains the same
                      ),
                      _buildCategoriesList(),
                      _buildSectionTitle(
                        context,
                        "Featured Restaurants",
                        const SizedBox.shrink(), // This is a placeholder, navigation is handled in _buildSectionTitle
                      ),
                      _buildFeaturedRestaurants(),
                      _buildSectionTitle(
                        context,
                        "Popular Restaurants Nearby",
                        const SizedBox.shrink(), // This is a placeholder, navigation is handled in _buildSectionTitle
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${filteredRestaurants.length} restaurants found",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildRestaurantList(),
                    ],
                  ),
                ),
              ),
    );
  }

  // Show sort and filter dialog
  void _showSortFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sort & Filter",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text("Top Rated"),
                onTap: () {
                  sortByRating();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text("Alphabetically"),
                onTap: () {
                  sortByName();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: const Text("By Cuisine"),
                onTap: () {
                  sortByCuisine();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text("Clear All Filters"),
                onTap: () {
                  setState(() {
                    selectedCategory = "";
                    searchQuery = "";
                    filteredRestaurants = List.from(restaurants);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search for restaurants, cuisines, or addresses...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              searchQuery.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchQuery = "";
                        filteredRestaurants = List.from(restaurants);
                      });
                    },
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
        onChanged: filterRestaurants,
      ),
    );
  }

  Widget _buildCategoriesList() {
    List<String> categories = [
      "Popular",
      "Fast Food",
      "Italian",
      "Chinese",
      "Indian",
      "Continental",
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categories
                .map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () => filterByCategory(category),
                      child: Chip(
                        label: Text(category),
                        backgroundColor:
                            selectedCategory == category
                                ? Colors.blue
                                : Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color:
                              selectedCategory == category
                                  ? Colors.white
                                  : Colors.blue.shade900,
                          fontWeight:
                              selectedCategory == category
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  // Widget _buildFeaturedRestaurants() {
  //   // Get top 5 highly rated restaurants for featured section
  //   List<Map<String, dynamic>> topRestaurants = List.from(restaurants);
  //   topRestaurants.sort(
  //     (a, b) => double.parse(
  //       b["rating"].toString(),
  //     ).compareTo(double.parse(a["rating"].toString())),
  //   );
  //   topRestaurants = topRestaurants.take(5).toList();

  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children:
  //           topRestaurants.map((restaurant) {
  //             final isFavorite = favoriteRestaurants.any(
  //               (fav) => fav["id"] == restaurant["id"],
  //             );

  //             return GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder:
  //                         (context) => RestaurantDetailsPage(
  //                           restaurantId: restaurant["detailsId"],
  //                           imageUrls:
  //                               restaurant["imageUrls"] ??
  //                               [], // Add fallback for null
  //                           name: restaurant["name"] ?? "",
  //                           rating: double.parse(restaurant["rating"] ?? "0"),
  //                           address: restaurant["address"] ?? "",
  //                           phone: restaurant["phone"] ?? "N/A",
  //                           description: restaurant["description"] ?? "",
  //                           timing: restaurant["timing"] ?? "",
  //                           isLiked: isFavorite,
  //                           // Add onFavoriteToggled callback if needed
  //                           onFavoriteToggled: (bool newValue) {
  //                             if (newValue) {
  //                               favoriteRestaurants.add(restaurant);
  //                             } else {
  //                               favoriteRestaurants.removeWhere(
  //                                 (fav) => fav["id"] == restaurant["id"],
  //                               );
  //                             }
  //                             setState(() {});
  //                           },
  //                           onFavoriteChanged: (bool isFavorite) {},
  //                         ),
  //                   ),
  //                 );
  //               },
  //               child: Container(
  //                 width: 250,
  //                 margin: const EdgeInsets.only(right: 10),
  //                 child: Card(
  //                   elevation: 4,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       ClipRRect(
  //                         borderRadius: const BorderRadius.vertical(
  //                           top: Radius.circular(12),
  //                         ),
  //                         child: Stack(
  //                           children: [
  //                             Image.network(
  //                               restaurant["image"],
  //                               height: 150,
  //                               width: double.infinity,
  //                               fit: BoxFit.cover,
  //                               errorBuilder: (context, error, stackTrace) {
  //                                 return Container(
  //                                   height: 150,
  //                                   width: double.infinity,
  //                                   color: Colors.grey.shade300,
  //                                   child: const Icon(
  //                                     Icons.restaurant,
  //                                     size: 50,
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                             Positioned(
  //                               top: 10,
  //                               right: 10,
  //                               child: Container(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 8,
  //                                   vertical: 4,
  //                                 ),
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.green,
  //                                   borderRadius: BorderRadius.circular(12),
  //                                 ),
  //                                 child: Row(
  //                                   children: [
  //                                     const Icon(
  //                                       Icons.star,
  //                                       color: Colors.white,
  //                                       size: 16,
  //                                     ),
  //                                     const SizedBox(width: 2),
  //                                     Text(
  //                                       restaurant["rating"],
  //                                       style: const TextStyle(
  //                                         color: Colors.white,
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             // Positioned(
  //                             //   bottom: 0,
  //                             //   right: 0,
  //                             //   child: IconButton(
  //                             //     icon: Icon(
  //                             //       isFavorite
  //                             //           ? Icons.favorite
  //                             //           : Icons.favorite_border,
  //                             //       color: Colors.red,
  //                             //     ),
  //                             //     onPressed: () => toggleFavorite(restaurant),
  //                             //   ),
  //                             // ),
  //                           ],
  //                         ),
  //                       ),
  //                       // Inside the Padding widget in _buildFeaturedRestaurants() method
  //                       Padding(
  //                         padding: const EdgeInsets.all(12.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     restaurant["name"],
  //                                     style: const TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                     maxLines: 1,
  //                                     overflow: TextOverflow.ellipsis,
  //                                   ),
  //                                 ),
  //                                 IconButton(
  //                                   icon: Icon(
  //                                     isFavorite
  //                                         ? Icons.favorite
  //                                         : Icons.favorite_border,
  //                                     color: Colors.red,
  //                                   ),
  //                                   onPressed: () => toggleFavorite(restaurant),
  //                                   padding: EdgeInsets.zero,
  //                                   constraints: const BoxConstraints(),
  //                                 ),
  //                               ],
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Text(
  //                               restaurant["cuisine"],
  //                               style: TextStyle(color: Colors.grey.shade700),
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Text(
  //                               restaurant["address"],
  //                               style: TextStyle(color: Colors.grey.shade600),
  //                               maxLines: 2,
  //                               overflow: TextOverflow.ellipsis,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //     ),
  //   );
  // }

  Widget _buildFeaturedRestaurants() {
    // Get top 5 highly rated restaurants for featured section
    List<Map<String, dynamic>> topRestaurants = List.from(restaurants);
    topRestaurants.sort(
      (a, b) => double.parse(
        b["rating"].toString(),
      ).compareTo(double.parse(a["rating"].toString())),
    );
    topRestaurants = topRestaurants.take(5).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            topRestaurants.map((restaurant) {
              final isFavorite = favoriteRestaurants.any(
                (fav) => fav["id"] == restaurant["id"],
              );

              return GestureDetector(
                onTap: () async {
                  final isAuthenticated = await _checkAuthentication();
                  if (!isAuthenticated) {
                    if (mounted) {
                      _showLoginAlert(context);
                    }
                    return;
                  }
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RestaurantDetailsPage(
                            restaurantId: restaurant["detailsId"] ?? '',
                            imageUrls:
                                (restaurant["imageUrls"] as List<dynamic>?)
                                    ?.cast<String>() ??
                                [],
                            name: restaurant["name"] ?? '',
                            rating:
                                double.tryParse(
                                  restaurant["rating"]?.toString() ?? '0',
                                ) ??
                                0.0,
                            address: restaurant["address"] ?? '',
                            phone: restaurant["phone"]?.toString() ?? 'N/A',
                            description: restaurant["description"] ?? '',
                            timing: restaurant["timing"] ?? '',
                            isLiked: isFavorite,
                            onFavoriteToggled: (bool newValue) {
                              if (newValue) {
                                favoriteRestaurants.add(restaurant);
                              } else {
                                favoriteRestaurants.removeWhere(
                                  (fav) => fav["id"] == restaurant["id"],
                                );
                              }
                              setState(() {});
                            },
                            onFavoriteChanged: (bool isFavorite) {},
                          ),
                    ),
                  );
                },
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 10),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                restaurant["image"],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.restaurant,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        restaurant["rating"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      restaurant["name"] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => toggleFavorite(restaurant),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                restaurant["cuisine"] ?? '',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                restaurant["address"] ?? '',
                                style: TextStyle(color: Colors.grey.shade600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  // Widget _buildRestaurantList() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: filteredRestaurants.length,
  //     itemBuilder: (context, index) {
  //       final restaurant = filteredRestaurants[index];
  //       final isFavorite = favoriteRestaurants.any(
  //         (fav) => fav["id"] == restaurant["id"],
  //       );

  //       return RestaurantCard(
  //         restaurant: restaurant,
  //         isFavorite: isFavorite,
  //         onFavoriteToggle: () => toggleFavorite(restaurant),
  //         onTap: () async {
  //           // Check authentication first
  //           final isAuthenticated = await _checkAuthentication();
  //           if (!isAuthenticated) {
  //             // ignore: use_build_context_synchronously
  //             _showLoginAlert(context);
  //             return;
  //           }

  //           // Proceed with navigation if authenticated
  //           Navigator.push(
  //             // ignore: use_build_context_synchronously
  //             context,
  //             MaterialPageRoute(
  //               builder:
  //                   (context) => RestaurantDetailsPage(
  //                     restaurantId: restaurant["detailsId"],
  //                     imageUrls: restaurant["imageUrls"] ?? [],
  //                     name: restaurant["name"] ?? "",
  //                     rating: double.parse(restaurant["rating"] ?? "0"),
  //                     address: restaurant["address"] ?? "",
  //                     phone: restaurant["phone"] ?? "N/A",
  //                     description: restaurant["description"] ?? "",
  //                     timing: restaurant["timing"] ?? "",
  //                     isLiked:
  //                         isFavorite, // Changed from hardcoded true to actual favorite status
  //                     onFavoriteToggled: (bool newValue) {
  //                       if (!newValue) {
  //                         removeFromFavorites(restaurant);
  //                       }
  //                       setState(() {}); // Refresh UI
  //                     },
  //                     onFavoriteChanged: (bool isFavorite) {},
  //                   ),
  //             ),
  //           ).then((_) {
  //             // This ensures the UI updates when returning from details page
  //             setState(() {});
  //           });
  //         },
  //         // Add this if your RestaurantCard has a book table button
  //         onBookTable: () async {
  //           final isAuthenticated = await _checkAuthentication();
  //           if (!isAuthenticated) {
  //             // ignore: use_build_context_synchronously
  //             _showLoginAlert(context);
  //             return;
  //           }
  //           // Proceed with booking logic if authenticated
  //           _handleBookTable(restaurant);
  //         },
  //       );
  //     },
  //   );
  // }
  Widget _buildRestaurantList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = filteredRestaurants[index];
        final isFavorite = favoriteRestaurants.any(
          (fav) => fav["id"] == restaurant["id"],
        );

        return RestaurantCard(
          restaurant: restaurant,
          isFavorite: isFavorite,
          onFavoriteToggle: () => toggleFavorite(restaurant),
          onTap: () async {
            final isAuthenticated = await _checkAuthentication();
            if (!isAuthenticated) {
              if (mounted) {
                // ignore: use_build_context_synchronously
                _showLoginAlert(context);
              }
              return;
            }
            _navigateToRestaurantDetails(restaurant);
          },
          onBookTable: () async {
            final isAuthenticated = await _checkAuthentication();
            if (!isAuthenticated) {
              if (mounted) {
                // ignore: use_build_context_synchronously
                _showLoginAlert(context);
              }
              return;
            }
            _handleBookTable(restaurant);
          },
        );
      },
    );
  }

  void _navigateToRestaurantDetails(Map<String, dynamic> restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RestaurantDetailsPage(
              restaurantId: restaurant["detailsId"] ?? '',
              imageUrls:
                  (restaurant["imageUrls"] as List<dynamic>?)?.cast<String>() ??
                  [],
              name: restaurant["name"] ?? '',
              rating:
                  double.tryParse(restaurant["rating"]?.toString() ?? '0') ??
                  0.0,
              address: restaurant["address"] ?? '',
              phone: restaurant["phone"]?.toString() ?? 'N/A',
              description: restaurant["description"] ?? '',
              timing: restaurant["timing"] ?? '',
              isLiked: favoriteRestaurants.any(
                (fav) => fav["id"] == restaurant["id"],
              ),
              onFavoriteToggled: (bool newValue) {
                if (!newValue) {
                  removeFromFavorites(restaurant);
                }
              },
              onFavoriteChanged: (bool isFavorite) {},
            ),
      ),
    );
  }

  // Add these helper methods to your class
  void _showLoginAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Required"),
          content: const Text(
            "You need to login to view restaurant details or book a table.",
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Login"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(), // Direct class reference
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _handleBookTable(Map<String, dynamic> restaurant) async {
    // Check authentication first
    final isAuthenticated = await _checkAuthentication();
    if (!isAuthenticated) {
      // ignore: use_build_context_synchronously
      _showLoginAlert(context);
      return;
    }

    // Proceed with navigation if authenticated
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder:
            (context) => RestaurantDetailsPage(
              restaurantId: restaurant["detailsId"] ?? '',
              imageUrls:
                  (restaurant["imageUrls"] as List<dynamic>?)?.cast<String>() ??
                  [],
              name: restaurant["name"] ?? '',
              rating:
                  double.tryParse(restaurant["rating"]?.toString() ?? '0') ??
                  0.0,
              address: restaurant["address"] ?? '',
              phone: restaurant["phone"]?.toString() ?? 'N/A',
              description: restaurant["description"] ?? '',
              timing: restaurant["timing"] ?? '',
              isLiked: favoriteRestaurants.any(
                (fav) => fav["id"] == restaurant["id"],
              ),
              onFavoriteToggled: (bool newValue) {
                if (!newValue) {
                  removeFromFavorites(restaurant);
                }
              },
              onFavoriteChanged: (bool isFavorite) {},
            ),
      ),
    );
  }

  // Widget _buildSectionTitle(BuildContext context, String title, Widget page) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           title,
  //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             if (title == "Categories") {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => page),
  //               );
  //             } else {}
  //           },
  //           child: Text(
  //             "See All",
  //             style: TextStyle(
  //               color: Colors.blue.shade700,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Then modify the _buildSectionTitle method in the _RestaurantListingsPageState class
  Widget _buildSectionTitle(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              if (title == "Categories") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              } else if (title == "Featured Restaurants") {
                // Navigate to ServicesPage with featured restaurants (top rated)
                List<Map<String, dynamic>> topRestaurants = List.from(
                  restaurants,
                );
                topRestaurants.sort(
                  (a, b) => double.parse(
                    b["rating"].toString(),
                  ).compareTo(double.parse(a["rating"].toString())),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ServicesPage(
                          restaurants: topRestaurants,
                          favoriteRestaurants: favoriteRestaurants,
                          title: "Featured Restaurants",
                          toggleFavorite: toggleFavorite,
                        ),
                  ),
                );
              } else if (title == "Popular Restaurants Nearby") {
                // Navigate to ServicesPage with all restaurants
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ServicesPage(
                          restaurants: restaurants,
                          favoriteRestaurants: favoriteRestaurants,
                          title: "All Restaurants",
                          toggleFavorite: toggleFavorite,
                        ),
                  ),
                );
              }
            },
            child: Text(
              "See All",
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void removeFromFavorites(Map<String, dynamic> restaurant) {
    setState(() {
      favoriteRestaurants.removeWhere((fav) => fav["id"] == restaurant["id"]);
      _showSnackbar("${restaurant["name"]} removed from favorites");

      // If you're storing favorites in some persistence (like SharedPreferences)
      // saveFavorites(); // You would implement this method to save the updated list
    });
  }
}
