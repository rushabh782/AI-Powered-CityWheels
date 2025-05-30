// import 'package:flutter/material.dart';
// import 'categories_page.dart';
// import 'services_page.dart';

// class HotelsPage extends StatelessWidget {
//   final List<String> categories = [
//     "Luxury",
//     "Budget",
//     "Resorts",
//     "Vacation",
//     "Business",
//     "Boutique",
//     "Friendly",
//   ];

//   final List<Map<String, String>> featuredHotels = [
//     {
//       "image": "assets/images/TajLandsEnd.jpg",
//       "name": "The Taj Lands End",
//       "location": "Jeejeebhoy Road, Mumbai",
//       "rating": "3.4",
//       "price": "₹22000/night", // Changed Rs to ₹
//     },
//     {
//       "image": "assets/images/tajmahalpalace.jpg",
//       "name": "The Taj Mahal  Palace",
//       "location": "Colaba, Mumbai",
//       "rating": "4.2",
//       "price": "₹27000/night", // Changed Rs to ₹
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Hotels"),
//         actions: [
//           IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Location & Search Bar
//               _buildLocationSearch(),

//               // Categories Section
//               _buildSectionTitle(context, "Categories", CategoriesPage()),

//               // Categories List
//               _buildCategoriesList(),

//               // Featured Services Slider
//               _buildSectionTitle(context, "Available Services", ServicesPage()),
//               _buildHotelSlider(),

//               // Monthly Available Services
//               _buildSectionTitle(
//                 context,
//                 "Services Available This Month",
//                 ServicesPage(),
//               ),
//               _buildHotelList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationSearch() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Your Location",
//           style: TextStyle(fontSize: 12, color: Colors.grey),
//         ),
//         Row(
//           children: [
//             Icon(Icons.location_on, color: Colors.red),
//             Text(
//               "New York, USA",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Spacer(),
//             Icon(Icons.notifications, color: Colors.grey),
//           ],
//         ),
//         SizedBox(height: 10),
//         TextField(
//           decoration: InputDecoration(
//             hintText: "Search",
//             prefixIcon: Icon(Icons.search),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(BuildContext context, String title, Widget page) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         TextButton(
//           onPressed:
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => page),
//               ),
//           child: Text("See All", style: TextStyle(color: Colors.blue)),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategoriesList() {
//     return SizedBox(
//       height: 50,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Chip(label: Text(categories[index])),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildHotelSlider() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal, // Enables horizontal scrolling
//       child: Row(
//         children:
//             featuredHotels.map((hotel) {
//               return Container(
//                 width: 250, // Define a fixed width for each card
//                 margin: EdgeInsets.only(right: 10),
//                 child: Card(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.asset(
//                         hotel["image"]!,
//                         height: 120,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               hotel["name"]!,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.location_on,
//                                   size: 14,
//                                   color: Colors.grey,
//                                 ),
//                                 Text(
//                                   hotel["location"]!,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Icon(
//                                   Icons.star,
//                                   size: 14,
//                                   color: Colors.orange,
//                                 ),
//                                 Text(
//                                   hotel["rating"]!,
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               hotel["price"]!,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//       ),
//     );
//   }

//   Widget _buildHotelList() {
//     return Column(
//       children:
//           featuredHotels.map((hotel) {
//             return Card(
//               child: ListTile(
//                 leading: Image.asset(
//                   hotel["image"]!,
//                   width: 60,
//                   height: 60,
//                   fit: BoxFit.cover,
//                 ),
//                 title: Text(hotel["name"]!),
//                 subtitle: Text(hotel["location"]!),
//                 trailing: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.star, color: Colors.orange, size: 16),
//                     Text(hotel["rating"]!),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../hotels/categories_page.dart';
// import '../hotels/services_page.dart';
// import '../hotels/favorites_page.dart';
// import '../hotels/booking_page.dart';

// class HotelsPage extends StatefulWidget {
//   const HotelsPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HotelsPageState createState() => _HotelsPageState();
// }

// class _HotelsPageState extends State<HotelsPage> {
//   List<Map<String, dynamic>> hotels = [];
//   List<Map<String, dynamic>> favoriteHotels = [];
//   String searchQuery = "";
//   List<Map<String, dynamic>> filteredHotels = [];
//   String documentId = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchHotels();
//   }

//   Future<void> fetchHotels() async {
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection("hotels").get();
//       setState(() {
//         hotels =
//             snapshot.docs.map((doc) {
//               Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//               return {
//                 "id": doc.id,
//                 "image": data["imageUrl".trim()],
//                 "name": data["name".trim()],
//                 "location": data["location".trim()],
//                 "rating": data["rating".trim()],
//                 "price": "₹${data["price".trim()]}/night",
//                 "description": data["description".trim()],
//                 "latitude": data["latitude".trim()],
//                 "longitude": data["longitude".trim()],
//                 "amenities": data["amenities".trim()],
//               };
//             }).toList();

//         // Initialize filtered hotels with all hotels
//         filteredHotels = List.from(hotels);
//       });
//     } catch (e) {
//       debugPrint("Error fetching hotels: $e");
//     }
//   }

//   // Add after fetchHotels
//   void filterHotels(String query) {
//     setState(() {
//       searchQuery = query;
//       if (query.isEmpty) {
//         // If search is empty, show all hotels
//         filteredHotels = List.from(hotels);
//       } else {
//         // Filter hotels that start with the query (case insensitive)
//         filteredHotels =
//             hotels.where((hotel) {
//               final hotelName = hotel["name"].toString().toLowerCase();
//               final searchLower = query.toLowerCase();
//               return hotelName.startsWith(searchLower);
//             }).toList();
//       }
//     });
//   }

//   /// Toggles hotel as favorite or removes from favorites
//   void toggleFavorite(Map<String, dynamic> hotel) {
//     setState(() {
//       bool isRemoving = favoriteHotels.any(
//         (fav) => fav["name"] == hotel["name"],
//       );
//       if (isRemoving) {
//         favoriteHotels.removeWhere((fav) => fav["name"] == hotel["name"]);
//         _showSnackbar("${hotel["name"]} removed from favorites");
//       } else {
//         favoriteHotels.add(hotel);
//         _showSnackbar("${hotel["name"]} added to favorites");
//       }
//     });
//   }

//   /// Displays a snackbar message
//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: Duration(seconds: 1)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Hotels"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.favorite, color: Colors.red),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder:
//                       (context) =>
//                           FavoritesPage(favoriteHotels: favoriteHotels),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           hotels.isEmpty
//               ? Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildLocationSearch(),
//                     _buildSectionTitle(context, "Categories", CategoriesPage()),
//                     _buildCategoriesList(),
//                     _buildSectionTitle(
//                       context,
//                       "Available Services",
//                       ServicesPage(favoriteHotels: []),
//                     ),
//                     _buildHotelSlider(),
//                     _buildSectionTitle(
//                       context,
//                       "Services Available This Month",
//                       ServicesPage(favoriteHotels: []),
//                     ),
//                     _buildHotelList(),
//                   ],
//                 ),
//               ),
//     );
//   }

//   /// **Hotel Slider Widget**
//   Widget _buildHotelSlider() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children:
//             filteredHotels.map((hotel) {
//               final isFavorite = favoriteHotels.contains(hotel);

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => BookingPage(
//                             hotelId: hotel["id"],
//                             favoriteHotels: favoriteHotels,
//                             toggleFavorite: toggleFavorite,
//                           ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 250,
//                   margin: EdgeInsets.only(right: 10),
//                   child: Card(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.network(
//                           hotel["image"],
//                           height: 120,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       hotel["name"],
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: Icon(
//                                       isFavorite
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       color: isFavorite ? Colors.red : null,
//                                     ),
//                                     onPressed: () => toggleFavorite(hotel),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     size: 14,
//                                     color: Colors.grey,
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                       hotel["location"],
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.star,
//                                     size: 14,
//                                     color: Colors.orange,
//                                   ),
//                                   Text(
//                                     hotel["rating"].toString(),
//                                     style: TextStyle(fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 hotel["price"],
//                                 style: TextStyle(fontWeight: FontWeight.bold),
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

//   /// **Hotel List Widget**
//   Widget _buildHotelList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: filteredHotels.length,
//       itemBuilder: (context, index) {
//         final hotel = filteredHotels[index];
//         final isFavorite = favoriteHotels.contains(hotel);

//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (context) => BookingPage(
//                       hotelId: hotel["id"],
//                       favoriteHotels: favoriteHotels,
//                       toggleFavorite: toggleFavorite,
//                     ),
//               ),
//             );
//           },
//           child: Card(
//             child: ListTile(
//               leading: Image.network(
//                 hotel["image"],
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.cover,
//               ),
//               title: Text(
//                 hotel["name"],
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(hotel["location"], style: TextStyle(color: Colors.grey)),
//                   Row(
//                     children: [
//                       Icon(Icons.star, size: 14, color: Colors.orange),
//                       Text(hotel["rating"].toString()),
//                     ],
//                   ),
//                   Text(
//                     hotel["price"],
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               trailing: IconButton(
//                 icon: Icon(
//                   isFavorite ? Icons.favorite : Icons.favorite_border,
//                   color: isFavorite ? Colors.red : null,
//                 ),
//                 onPressed: () => toggleFavorite(hotel),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSectionTitle(
//     BuildContext context,
//     String title,
//     Widget nextPage,
//   ) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         TextButton(
//           onPressed:
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => nextPage),
//               ),
//           child: Text("See all"),
//         ),
//       ],
//     );
//   }

//   Widget _buildLocationSearch() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: "Search for hotels...",
//           prefixIcon: Icon(Icons.search),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         onChanged: filterHotels,
//       ),
//     );
//   }

//   Widget _buildCategoriesList() {
//     List<String> categories = [
//       "Luxury",
//       "Budget",
//       "Resorts",
//       "Business",
//       "Family",
//       "Boutique",
//     ];
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children:
//             categories
//                 .map(
//                   (category) => Chip(
//                     label: Text(category),
//                     backgroundColor: Colors.blue.shade100,
//                   ),
//                 )
//                 .toList(),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../hotels/categories_page.dart';
// import '../hotels/services_page.dart';
// import '../hotels/favorites_page.dart';
// import '../hotels/booking_page.dart';

// class HotelsPage extends StatefulWidget {
//   const HotelsPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HotelsPageState createState() => _HotelsPageState();
// }

// class _HotelsPageState extends State<HotelsPage> {
//   List<Map<String, dynamic>> hotels = [];
//   List<Map<String, dynamic>> favoriteHotels = [];
//   String searchQuery = "";
//   List<Map<String, dynamic>> filteredHotels = [];
//   String documentId = "";
//   String selectedCategory = "";
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHotels();
//   }

//   Future<void> fetchHotels() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection("hotels").get();
//       setState(() {
//         hotels =
//             snapshot.docs.map((doc) {
//               Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//               return {
//                 "id": doc.id,
//                 "image": data["imageUrl".trim()],
//                 "name": data["name".trim()],
//                 "location": data["location".trim()],
//                 "rating": data["rating".trim()],
//                 "price": "₹${data["price".trim()]}/night",
//                 "description": data["description".trim()],
//                 "latitude": data["latitude".trim()],
//                 "longitude": data["longitude".trim()],
//                 "amenities": data["amenities".trim()],
//                 "category":
//                     data["category"] ??
//                     "Luxury", // Ensure category field exists
//               };
//             }).toList();

//         // Initialize filtered hotels with all hotels
//         filteredHotels = List.from(hotels);
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error fetching hotels: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Enhanced search functionality
//   void filterHotels(String query) {
//     setState(() {
//       searchQuery = query;
//       if (query.isEmpty && selectedCategory.isEmpty) {
//         // If search is empty and no category filter, show all hotels
//         filteredHotels = List.from(hotels);
//       } else {
//         // Filter hotels based on search query and/or selected category
//         filteredHotels =
//             hotels.where((hotel) {
//               final hotelName = hotel["name"].toString().toLowerCase();
//               final hotelLocation = hotel["location"].toString().toLowerCase();
//               final searchLower = query.toLowerCase();

//               bool matchesSearch =
//                   query.isEmpty ||
//                   hotelName.contains(searchLower) ||
//                   hotelLocation.contains(searchLower);

//               bool matchesCategory =
//                   selectedCategory.isEmpty ||
//                   hotel["category"].toString() == selectedCategory;

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
//       filterHotels(searchQuery);
//     });
//   }

//   // Sort hotels by price (low to high)
//   void sortByPriceLowToHigh() {
//     setState(() {
//       filteredHotels.sort((a, b) {
//         // Extract numeric price value
//         double priceA = double.parse(
//           a["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
//         );
//         double priceB = double.parse(
//           b["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
//         );
//         return priceA.compareTo(priceB);
//       });
//     });
//     _showSnackbar("Sorted by price: Low to High");
//   }

//   // Sort hotels by price (high to low)
//   void sortByPriceHighToLow() {
//     setState(() {
//       filteredHotels.sort((a, b) {
//         // Extract numeric price value
//         double priceA = double.parse(
//           a["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
//         );
//         double priceB = double.parse(
//           b["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
//         );
//         return priceB.compareTo(priceA);
//       });
//     });
//     _showSnackbar("Sorted by price: High to Low");
//   }

//   // Sort hotels by rating
//   void sortByRating() {
//     setState(() {
//       filteredHotels.sort((a, b) {
//         double ratingA = double.parse(a["rating"].toString());
//         double ratingB = double.parse(b["rating"].toString());
//         return ratingB.compareTo(ratingA);
//       });
//     });
//     _showSnackbar("Sorted by highest rating");
//   }

//   /// Toggles hotel as favorite or removes from favorites
//   void toggleFavorite(Map<String, dynamic> hotel) {
//     setState(() {
//       bool isRemoving = favoriteHotels.any((fav) => fav["id"] == hotel["id"]);
//       if (isRemoving) {
//         favoriteHotels.removeWhere((fav) => fav["id"] == hotel["id"]);
//         _showSnackbar("${hotel["name"]} removed from favorites");
//       } else {
//         favoriteHotels.add(hotel);
//         _showSnackbar("${hotel["name"]} added to favorites");
//       }
//     });
//   }

//   /// Displays a snackbar message
//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: Duration(seconds: 1)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Hotels"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: () {
//               _showSortFilterDialog();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.favorite, color: Colors.red),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder:
//                       (context) =>
//                           FavoritesPage(favoriteHotels: favoriteHotels),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//                 onRefresh: fetchHotels,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildLocationSearch(),
//                       _buildSectionTitle(
//                         context,
//                         "Categories",
//                         CategoriesPage(),
//                       ),
//                       _buildCategoriesList(),
//                       _buildSectionTitle(
//                         context,
//                         "Featured Hotels",
//                         ServicesPage(favoriteHotels: []),
//                       ),
//                       _buildHotelSlider(),
//                       _buildSectionTitle(
//                         context,
//                         "Special Deals This Month",
//                         ServicesPage(favoriteHotels: []),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "${filteredHotels.length} hotels found",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       _buildHotelList(),
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
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Sort & Filter",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Divider(),
//               ListTile(
//                 leading: Icon(Icons.arrow_downward),
//                 title: Text("Price: Low to High"),
//                 onTap: () {
//                   sortByPriceLowToHigh();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.arrow_upward),
//                 title: Text("Price: High to Low"),
//                 onTap: () {
//                   sortByPriceHighToLow();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.star),
//                 title: Text("Top Rated"),
//                 onTap: () {
//                   sortByRating();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.clear_all),
//                 title: Text("Clear All Filters"),
//                 onTap: () {
//                   setState(() {
//                     selectedCategory = "";
//                     searchQuery = "";
//                     filteredHotels = List.from(hotels);
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

//   /// **Hotel Slider Widget**
//   Widget _buildHotelSlider() {
//     // Get top 5 highly rated hotels for slider
//     List<Map<String, dynamic>> topHotels = List.from(hotels);
//     topHotels.sort(
//       (a, b) => double.parse(
//         b["rating"].toString(),
//       ).compareTo(double.parse(a["rating"].toString())),
//     );
//     topHotels = topHotels.take(5).toList();

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children:
//             topHotels.map((hotel) {
//               final isFavorite = favoriteHotels.any(
//                 (fav) => fav["id"] == hotel["id"],
//               );

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => BookingPage(
//                             hotelId: hotel["id"],
//                             favoriteHotels: favoriteHotels,
//                             toggleFavorite: toggleFavorite,
//                             hotelName: hotel["name"],
//                           ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 250,
//                   margin: EdgeInsets.only(right: 10),
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(12),
//                           ),
//                           child: Stack(
//                             children: [
//                               Image.network(
//                                 hotel["image"],
//                                 height: 150,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                               ),
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.star,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                       SizedBox(width: 4),
//                                       Text(
//                                         hotel["rating"].toString(),
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
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
//                                       hotel["name"],
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: Icon(
//                                       isFavorite
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       color: isFavorite ? Colors.red : null,
//                                     ),
//                                     onPressed: () => toggleFavorite(hotel),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     size: 14,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(width: 4),
//                                   Expanded(
//                                     child: Text(
//                                       hotel["location"],
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 hotel["price"],
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   color: Colors.blue.shade800,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Wrap(
//                                 spacing: 6,
//                                 children: [
//                                   _buildAmenityChip("WiFi"),
//                                   _buildAmenityChip("Pool"),
//                                 ],
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

//   Widget _buildAmenityChip(String amenity) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue.shade100),
//       ),
//       child: Text(
//         amenity,
//         style: TextStyle(fontSize: 10, color: Colors.blue.shade800),
//       ),
//     );
//   }

//   /// **Hotel List Widget**
//   Widget _buildHotelList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: filteredHotels.length,
//       itemBuilder: (context, index) {
//         final hotel = filteredHotels[index];
//         final isFavorite = favoriteHotels.any(
//           (fav) => fav["id"] == hotel["id"],
//         );

//         return Container(
//           margin: EdgeInsets.only(bottom: 12),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder:
//                       (context) => BookingPage(
//                         hotelId: hotel["id"],
//                         hotelName: hotel["name"],
//                         favoriteHotels: favoriteHotels,
//                         toggleFavorite: toggleFavorite,
//                       ),
//                 ),
//               );
//             },
//             child: Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       bottomLeft: Radius.circular(12),
//                     ),
//                     child: Image.network(
//                       hotel["image"],
//                       width: 120,
//                       height: 120,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   hotel["name"],
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(
//                                   isFavorite
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: isFavorite ? Colors.red : null,
//                                 ),
//                                 onPressed: () => toggleFavorite(hotel),
//                                 constraints: BoxConstraints(),
//                                 padding: EdgeInsets.zero,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.location_on,
//                                 size: 14,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 4),
//                               Expanded(
//                                 child: Text(
//                                   hotel["location"],
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 6,
//                                   vertical: 2,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.star,
//                                       size: 12,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 2),
//                                     Text(
//                                       hotel["rating"].toString(),
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 hotel["category"].toString(),
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.blue.shade800,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             hotel["price"],
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: Colors.blue.shade800,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSectionTitle(
//     BuildContext context,
//     String title,
//     Widget nextPage,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           TextButton(
//             onPressed:
//                 () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => nextPage),
//                 ),
//             child: Text("See all"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationSearch() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: "Search for hotels or locations...",
//           prefixIcon: Icon(Icons.search),
//           suffixIcon:
//               searchQuery.isNotEmpty
//                   ? IconButton(
//                     icon: Icon(Icons.clear),
//                     onPressed: () {
//                       setState(() {
//                         searchQuery = "";
//                         filteredHotels = List.from(hotels);
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
//             borderSide: BorderSide(color: Colors.blue, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.blue.shade50,
//         ),
//         onChanged: filterHotels,
//       ),
//     );
//   }

//   Widget _buildCategoriesList() {
//     List<String> categories = [
//       "Luxury",
//       "Budget",
//       "Resorts",
//       "Business",
//       "Family",
//       "Boutique",
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
//                         padding: EdgeInsets.symmetric(
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
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../hotels/categories_page.dart';
// import '../hotels/services_page.dart';
// import '../hotels/favorites_page.dart';
// import '../hotels/booking_page.dart';

// class HotelsPage extends StatefulWidget {
//   const HotelsPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HotelsPageState createState() => _HotelsPageState();
// }

// class _HotelsPageState extends State<HotelsPage> {
//   List<Map<String, dynamic>> hotels = [];
//   List<Map<String, dynamic>> favoriteHotels = [];
//   String searchQuery = "";
//   List<Map<String, dynamic>> filteredHotels = [];
//   String documentId = "";
//   String selectedCategory = "";
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHotels();
//   }

//   Future<void> fetchHotels() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection("hotels").get();
//       setState(() {
//         hotels =
//             snapshot.docs.map((doc) {
//               Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//               return {
//                 "id": doc.id,
//                 "image": data["imageUrl".trim()],
//                 "name": data["name".trim()],
//                 "location": data["location".trim()],
//                 "rating": data["rating".trim()],
//                 "price": "₹${data["price".trim()]}/night",
//                 "description": data["description".trim()],
//                 "latitude": data["latitude".trim()],
//                 "longitude": data["longitude".trim()],
//                 "amenities": data["amenities".trim()],
//                 "category":
//                     data["category"] ??
//                     "Luxury", // Ensure category field exists
//               };
//             }).toList();

//         // Initialize filtered hotels with all hotels
//         filteredHotels = List.from(hotels);
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error fetching hotels: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Enhanced search functionality
//   void filterHotels(String query) {
//     setState(() {
//       searchQuery = query;
//       if (query.isEmpty && selectedCategory.isEmpty) {
//         // If search is empty and no category filter, show all hotels
//         filteredHotels = List.from(hotels);
//       } else {
//         // Filter hotels based on search query and/or selected category
//         filteredHotels =
//             hotels.where((hotel) {
//               final hotelName = hotel["name"].toString().toLowerCase();
//               final hotelLocation = hotel["location"].toString().toLowerCase();
//               final searchLower = query.toLowerCase();

//               bool matchesSearch =
//                   query.isEmpty ||
//                   hotelName.contains(searchLower) ||
//                   hotelLocation.contains(searchLower);

//               bool matchesCategory =
//                   selectedCategory.isEmpty ||
//                   hotel["category"].toString() == selectedCategory;

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
//       filterHotels(searchQuery);
//     });
//   }

//   // Sort hotels by price (low to high)
//   void sortByPriceLowToHigh() {
//     setState(() {
//       filteredHotels.sort((a, b) {
//         // Extract numeric price value
//         double priceA = double.parse(
//           a["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
//         );
//         double priceB = double.parse(
//           b["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
//         );
//         return priceA.compareTo(priceB);
//       });
//     });
//     _showSnackbar("Sorted by price: Low to High");
//   }

//   // Sort hotels by price (high to low)
//   void sortByPriceHighToLow() {
//     setState(() {
//       filteredHotels.sort((a, b) {
//         // Extract numeric price value
//         double priceA = double.parse(
//           a["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
//         );
//         double priceB = double.parse(
//           b["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
//         );
//         return priceB.compareTo(priceA);
//       });
//     });
//     _showSnackbar("Sorted by price: High to Low");
//   }

//   // Sort hotels by rating
//   void sortByRating() {
//     setState(() {
//       filteredHotels.sort((a, b) {
//         double ratingA = double.parse(a["rating"].toString());
//         double ratingB = double.parse(b["rating"].toString());
//         return ratingB.compareTo(ratingA);
//       });
//     });
//     _showSnackbar("Sorted by highest rating");
//   }

//   /// Toggles hotel as favorite or removes from favorites
//   void toggleFavorite(Map<String, dynamic> hotel) {
//     setState(() {
//       bool isRemoving = favoriteHotels.any((fav) => fav["id"] == hotel["id"]);
//       if (isRemoving) {
//         favoriteHotels.removeWhere((fav) => fav["id"] == hotel["id"]);
//         _showSnackbar("${hotel["name"]} removed from favorites");
//       } else {
//         favoriteHotels.add(hotel);
//         _showSnackbar("${hotel["name"]} added to favorites");
//       }
//     });
//   }

//   /// Displays a snackbar message
//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: Duration(seconds: 1)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Hotels"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: () {
//               _showSortFilterDialog();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.favorite, color: Colors.red),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder:
//                       (context) =>
//                           FavoritesPage(favoriteHotels: favoriteHotels),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//                 onRefresh: fetchHotels,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildLocationSearch(),
//                       _buildSectionTitle(
//                         context,
//                         "Categories",
//                         CategoriesPage(),
//                       ),
//                       _buildCategoriesList(),
//                       _buildSectionTitle(
//                         context,
//                         "Featured Hotels",
//                         ServicesPage(favoriteHotels: []),
//                       ),
//                       _buildHotelSlider(),
//                       _buildSectionTitle(
//                         context,
//                         "Special Deals This Month",
//                         ServicesPage(favoriteHotels: []),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "${filteredHotels.length} hotels found",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       _buildHotelList(),
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
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Sort & Filter",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Divider(),
//               ListTile(
//                 leading: Icon(Icons.arrow_downward),
//                 title: Text("Price: Low to High"),
//                 onTap: () {
//                   sortByPriceLowToHigh();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.arrow_upward),
//                 title: Text("Price: High to Low"),
//                 onTap: () {
//                   sortByPriceHighToLow();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.star),
//                 title: Text("Top Rated"),
//                 onTap: () {
//                   sortByRating();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.clear_all),
//                 title: Text("Clear All Filters"),
//                 onTap: () {
//                   setState(() {
//                     selectedCategory = "";
//                     searchQuery = "";
//                     filteredHotels = List.from(hotels);
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

//   /// **Hotel Slider Widget**
//   Widget _buildHotelSlider() {
//     // Get top 5 highly rated hotels for slider
//     List<Map<String, dynamic>> topHotels = List.from(hotels);
//     topHotels.sort(
//       (a, b) => double.parse(
//         b["rating"].toString(),
//       ).compareTo(double.parse(a["rating"].toString())),
//     );
//     topHotels = topHotels.take(5).toList();

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children:
//             topHotels.map((hotel) {
//               final isFavorite = favoriteHotels.any(
//                 (fav) => fav["id"] == hotel["id"],
//               );

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => BookingPage(
//                             hotelId: hotel["id"],
//                             favoriteHotels: favoriteHotels,
//                             toggleFavorite: toggleFavorite,
//                             hotelName: hotel["name"],
//                           ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 250,
//                   margin: EdgeInsets.only(right: 10),
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(12),
//                           ),
//                           child: Stack(
//                             children: [
//                               Image.network(
//                                 hotel["image"],
//                                 height: 150,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                               ),
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.star,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                       SizedBox(width: 4),
//                                       Text(
//                                         hotel["rating"].toString(),
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
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
//                                       hotel["name"],
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: Icon(
//                                       isFavorite
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       color: isFavorite ? Colors.red : null,
//                                     ),
//                                     onPressed: () => toggleFavorite(hotel),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     size: 14,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(width: 4),
//                                   Expanded(
//                                     child: Text(
//                                       hotel["location"],
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 hotel["price"],
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   color: Colors.blue.shade800,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Wrap(
//                                 spacing: 6,
//                                 children: [
//                                   _buildAmenityChip("WiFi"),
//                                   _buildAmenityChip("Pool"),
//                                 ],
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

//   Widget _buildAmenityChip(String amenity) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue.shade100),
//       ),
//       child: Text(
//         amenity,
//         style: TextStyle(fontSize: 10, color: Colors.blue.shade800),
//       ),
//     );
//   }

//   /// **Hotel List Widget**
//   Widget _buildHotelList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: filteredHotels.length,
//       itemBuilder: (context, index) {
//         final hotel = filteredHotels[index];
//         final isFavorite = favoriteHotels.any(
//           (fav) => fav["id"] == hotel["id"],
//         );

//         return Container(
//           margin: EdgeInsets.only(bottom: 12),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder:
//                       (context) => BookingPage(
//                         hotelId: hotel["id"],
//                         hotelName: hotel["name"],
//                         favoriteHotels: favoriteHotels,
//                         toggleFavorite: toggleFavorite,
//                       ),
//                 ),
//               );
//             },
//             child: Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       bottomLeft: Radius.circular(12),
//                     ),
//                     child: Image.network(
//                       hotel["image"],
//                       width: 120,
//                       height: 120,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   hotel["name"],
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(
//                                   isFavorite
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: isFavorite ? Colors.red : null,
//                                 ),
//                                 onPressed: () => toggleFavorite(hotel),
//                                 constraints: BoxConstraints(),
//                                 padding: EdgeInsets.zero,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.location_on,
//                                 size: 14,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 4),
//                               Expanded(
//                                 child: Text(
//                                   hotel["location"],
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 6,
//                                   vertical: 2,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.star,
//                                       size: 12,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 2),
//                                     Text(
//                                       hotel["rating"].toString(),
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 hotel["category"].toString(),
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.blue.shade800,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             hotel["price"],
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: Colors.blue.shade800,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSectionTitle(
//     BuildContext context,
//     String title,
//     Widget nextPage,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           TextButton(
//             onPressed:
//                 () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => nextPage),
//                 ),
//             child: Text("See all"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationSearch() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: "Search for hotels or locations...",
//           prefixIcon: Icon(Icons.search),
//           suffixIcon:
//               searchQuery.isNotEmpty
//                   ? IconButton(
//                     icon: Icon(Icons.clear),
//                     onPressed: () {
//                       setState(() {
//                         searchQuery = "";
//                         filteredHotels = List.from(hotels);
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
//             borderSide: BorderSide(color: Colors.blue, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.blue.shade50,
//         ),
//         onChanged: filterHotels,
//       ),
//     );
//   }

//   Widget _buildCategoriesList() {
//     List<String> categories = [
//       "Luxury",
//       "Budget",
//       "Resorts",
//       "Business",
//       "Family",
//       "Boutique",
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
//                         padding: EdgeInsets.symmetric(
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
// }
import 'package:city_wheels/widgets/hotel_comparison_chatbot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../hotels/categories_page.dart';
import '../hotels/services_page.dart';
import '../hotels/favorites_page.dart';
import '../hotels/booking_page.dart';

class HotelsPage extends StatefulWidget {
  const HotelsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HotelsPageState createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  List<Map<String, dynamic>> hotels = [];
  List<Map<String, dynamic>> favoriteHotels = [];
  String searchQuery = "";
  List<Map<String, dynamic>> filteredHotels = [];
  String documentId = "";
  String selectedCategory = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("hotels").get();
      setState(() {
        hotels =
            snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              return {
                "id": doc.id,
                "image": data["imageUrl".trim()],
                "name": data["name".trim()],
                "location": data["location".trim()],
                "rating": data["rating".trim()],
                "price": "₹${data["price".trim()]}/night",
                "description": data["description".trim()],
                "latitude": data["latitude".trim()],
                "longitude": data["longitude".trim()],
                "amenities": data["amenities".trim()],
                "category":
                    data["category"] ??
                    "Luxury", // Ensure category field exists
              };
            }).toList();

        // Initialize filtered hotels with all hotels
        filteredHotels = List.from(hotels);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching hotels: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Enhanced search functionality
  void filterHotels(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty && selectedCategory.isEmpty) {
        // If search is empty and no category filter, show all hotels
        filteredHotels = List.from(hotels);
      } else {
        // Filter hotels based on search query and/or selected category
        filteredHotels =
            hotels.where((hotel) {
              final hotelName = hotel["name"].toString().toLowerCase();
              final hotelLocation = hotel["location"].toString().toLowerCase();
              final searchLower = query.toLowerCase();

              bool matchesSearch =
                  query.isEmpty ||
                  hotelName.contains(searchLower) ||
                  hotelLocation.contains(searchLower);

              bool matchesCategory =
                  selectedCategory.isEmpty ||
                  hotel["category"].toString() == selectedCategory;

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
      filterHotels(searchQuery);
    });
  }

  // Sort hotels by price (low to high)
  void sortByPriceLowToHigh() {
    setState(() {
      filteredHotels.sort((a, b) {
        // Extract numeric price value
        double priceA = double.parse(
          a["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
        );
        double priceB = double.parse(
          b["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
        );
        return priceA.compareTo(priceB);
      });
    });
    _showSnackbar("Sorted by price: Low to High");
  }

  // Sort hotels by price (high to low)
  void sortByPriceHighToLow() {
    setState(() {
      filteredHotels.sort((a, b) {
        // Extract numeric price value
        double priceA = double.parse(
          a["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
        );
        double priceB = double.parse(
          b["price"].toString().replaceAll(RegExp(r'[^\d.]'), ''),
        );
        return priceB.compareTo(priceA);
      });
    });
    _showSnackbar("Sorted by price: High to Low");
  }

  // Sort hotels by rating
  void sortByRating() {
    setState(() {
      filteredHotels.sort((a, b) {
        double ratingA = double.parse(a["rating"].toString());
        double ratingB = double.parse(b["rating"].toString());
        return ratingB.compareTo(ratingA);
      });
    });
    _showSnackbar("Sorted by highest rating");
  }

  /// Toggles hotel as favorite or removes from favorites
  void toggleFavorite(Map<String, dynamic> hotel) {
    setState(() {
      bool isRemoving = favoriteHotels.any((fav) => fav["id"] == hotel["id"]);
      if (isRemoving) {
        favoriteHotels.removeWhere((fav) => fav["id"] == hotel["id"]);
        _showSnackbar("${hotel["name"]} removed from favorites");
      } else {
        favoriteHotels.add(hotel);
        _showSnackbar("${hotel["name"]} added to favorites");
      }
    });
  }

  /// Displays a snackbar message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hotels"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showSortFilterDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          FavoritesPage(favoriteHotels: favoriteHotels),
                ),
              );
            },
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchHotels,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationSearch(),
                      _buildSectionTitle(
                        context,
                        "Categories",
                        CategoriesPage(),
                      ),
                      _buildCategoriesList(),
                      _buildSectionTitle(
                        context,
                        "Featured Hotels",
                        ServicesPage(favoriteHotels: []),
                      ),
                      _buildHotelSlider(),
                      _buildSectionTitle(
                        context,
                        "Special Deals This Month",
                        ServicesPage(favoriteHotels: []),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${filteredHotels.length} hotels found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildHotelList(),
                    ],
                  ),
                ),
              ),
      floatingActionButton: const HotelComparisonChatbot(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Show sort and filter dialog
  void _showSortFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sort & Filter",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.arrow_downward),
                title: Text("Price: Low to High"),
                onTap: () {
                  sortByPriceLowToHigh();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_upward),
                title: Text("Price: High to Low"),
                onTap: () {
                  sortByPriceHighToLow();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text("Top Rated"),
                onTap: () {
                  sortByRating();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.clear_all),
                title: Text("Clear All Filters"),
                onTap: () {
                  setState(() {
                    selectedCategory = "";
                    searchQuery = "";
                    filteredHotels = List.from(hotels);
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

  /// **Hotel Slider Widget**
  Widget _buildHotelSlider() {
    // Get top 5 highly rated hotels for slider
    List<Map<String, dynamic>> topHotels = List.from(hotels);
    topHotels.sort(
      (a, b) => double.parse(
        b["rating"].toString(),
      ).compareTo(double.parse(a["rating"].toString())),
    );
    topHotels = topHotels.take(5).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            topHotels.map((hotel) {
              final isFavorite = favoriteHotels.any(
                (fav) => fav["id"] == hotel["id"],
              );

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BookingPage(
                            hotelId: hotel["id"],
                            favoriteHotels: favoriteHotels,
                            toggleFavorite: toggleFavorite,
                            hotelName: hotel["name"],
                          ),
                    ),
                  );
                },
                child: Container(
                  width: 250,
                  margin: EdgeInsets.only(right: 10),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                hotel["image"],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        hotel["rating"].toString(),
                                        style: TextStyle(
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
                                      hotel["name"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                    onPressed: () => toggleFavorite(hotel),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      hotel["location"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                hotel["price"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  _buildAmenityChip("WiFi"),
                                  _buildAmenityChip("Pool"),
                                ],
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

  Widget _buildAmenityChip(String amenity) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        amenity,
        style: TextStyle(fontSize: 10, color: Colors.blue.shade800),
      ),
    );
  }

  /// **Hotel List Widget**
  Widget _buildHotelList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredHotels.length,
      itemBuilder: (context, index) {
        final hotel = filteredHotels[index];
        final isFavorite = favoriteHotels.any(
          (fav) => fav["id"] == hotel["id"],
        );

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BookingPage(
                        hotelId: hotel["id"],
                        hotelName: hotel["name"],
                        favoriteHotels: favoriteHotels,
                        toggleFavorite: toggleFavorite,
                      ),
                ),
              );
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.network(
                      hotel["image"],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  hotel["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () => toggleFavorite(hotel),
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  hotel["location"],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      hotel["rating"].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                hotel["category"].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            hotel["price"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    Widget nextPage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nextPage),
                ),
            child: Text("See all"),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search for hotels or locations...",
          prefixIcon: Icon(Icons.search),
          suffixIcon:
              searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchQuery = "";
                        filteredHotels = List.from(hotels);
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
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
        onChanged: filterHotels,
      ),
    );
  }

  Widget _buildCategoriesList() {
    List<String> categories = [
      "Luxury",
      "Budget",
      "Resorts",
      "Business",
      "Family",
      "Boutique",
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
                        padding: EdgeInsets.symmetric(
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
}
