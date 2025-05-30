// import 'package:flutter/material.dart';
// import '../widgets/restaurant_card.dart';
// import '../restaurants/restaurant_details.dart';

// class ServicesPage extends StatefulWidget {
//   final List<Map<String, dynamic>> restaurants;
//   final List<Map<String, dynamic>> favoriteRestaurants;
//   final String title;
//   final Function(Map<String, dynamic>) toggleFavorite;

//   const ServicesPage({
//     super.key,
//     required this.restaurants,
//     required this.favoriteRestaurants,
//     required this.title,
//     required this.toggleFavorite,
//   });

//   @override
//   State<ServicesPage> createState() => _ServicesPageState();
// }

// class _ServicesPageState extends State<ServicesPage> {
//   late List<Map<String, dynamic>> displayedRestaurants;
//   String searchQuery = "";

//   @override
//   void initState() {
//     super.initState();
//     displayedRestaurants = List.from(widget.restaurants);
//   }

//   void filterRestaurants(String query) {
//     setState(() {
//       searchQuery = query;
//       if (query.isEmpty) {
//         // If search is empty, show all restaurants
//         displayedRestaurants = List.from(widget.restaurants);
//       } else {
//         // Filter restaurants based on search query
//         displayedRestaurants =
//             widget.restaurants.where((restaurant) {
//               final restaurantName =
//                   restaurant["name"].toString().toLowerCase();
//               final restaurantCuisine =
//                   restaurant["cuisine"].toString().toLowerCase();
//               final restaurantAddress =
//                   restaurant["address"].toString().toLowerCase();
//               final searchLower = query.toLowerCase();

//               return restaurantName.contains(searchLower) ||
//                   restaurantCuisine.contains(searchLower) ||
//                   restaurantAddress.contains(searchLower);
//             }).toList();
//       }
//     });
//   }

//   // Sort restaurants by rating
//   void sortByRating() {
//     setState(() {
//       displayedRestaurants.sort((a, b) {
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
//       displayedRestaurants.sort((a, b) {
//         return a["name"].toString().compareTo(b["name"].toString());
//       });
//     });
//     _showSnackbar("Sorted alphabetically by name");
//   }

//   // Sort by cuisine type
//   void sortByCuisine() {
//     setState(() {
//       displayedRestaurants.sort((a, b) {
//         return a["cuisine"].toString().compareTo(b["cuisine"].toString());
//       });
//     });
//     _showSnackbar("Sorted by cuisine type");
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
//     );
//   }

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
//                     searchQuery = "";
//                     displayedRestaurants = List.from(widget.restaurants);
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () {
//               _showSortFilterDialog();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Search for restaurants, cuisines, or addresses...",
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon:
//                     searchQuery.isNotEmpty
//                         ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             setState(() {
//                               searchQuery = "";
//                               displayedRestaurants = List.from(
//                                 widget.restaurants,
//                               );
//                             });
//                           },
//                         )
//                         : null,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.blue.shade300),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.blue, width: 2),
//                 ),
//                 filled: true,
//                 fillColor: Colors.blue.shade50,
//               ),
//               onChanged: filterRestaurants,
//             ),
//           ),

//           // Restaurant count
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   "${displayedRestaurants.length} restaurants found",
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),

//           // Restaurant list
//           Expanded(
//             child:
//                 displayedRestaurants.isEmpty
//                     ? const Center(
//                       child: Text(
//                         "No restaurants found",
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                     : ListView.builder(
//                       padding: const EdgeInsets.all(12.0),
//                       itemCount: displayedRestaurants.length,
//                       itemBuilder: (context, index) {
//                         final restaurant = displayedRestaurants[index];
//                         final isFavorite = widget.favoriteRestaurants.any(
//                           (fav) => fav["id"] == restaurant["id"],
//                         );

//                         return RestaurantCard(
//                           restaurant: restaurant,
//                           isFavorite: isFavorite,
//                           onFavoriteToggle:
//                               () => widget.toggleFavorite(restaurant),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => RestaurantDetailsPage(
//                                       restaurantId: restaurant["detailsId"],
//                                       imageUrls: restaurant["imageUrls"] ?? [],
//                                       name: restaurant["name"] ?? "",
//                                       rating: double.parse(
//                                         restaurant["rating"] ?? "0",
//                                       ),
//                                       address: restaurant["address"] ?? "",
//                                       phone: restaurant["phone"] ?? "N/A",
//                                       description:
//                                           restaurant["description"] ?? "",
//                                       timing: restaurant["timing"] ?? "",
//                                       isLiked: isFavorite,
//                                       onFavoriteToggled: (bool newValue) {
//                                         if (newValue != isFavorite) {
//                                           widget.toggleFavorite(restaurant);
//                                         }
//                                       },
//                                       onFavoriteChanged: (bool isFavorite) {},
//                                     ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../widgets/restaurant_card.dart';
import '../restaurants/restaurant_details.dart';

class ServicesPage extends StatefulWidget {
  final List<Map<String, dynamic>> restaurants;
  final List<Map<String, dynamic>> favoriteRestaurants;
  final String title;
  final Function(Map<String, dynamic>) toggleFavorite;

  const ServicesPage({
    super.key,
    required this.restaurants,
    required this.favoriteRestaurants,
    required this.title,
    required this.toggleFavorite,
  });

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late List<Map<String, dynamic>> displayedRestaurants;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    displayedRestaurants = List.from(widget.restaurants);
  }

  void filterRestaurants(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        displayedRestaurants = List.from(widget.restaurants);
      } else {
        displayedRestaurants =
            widget.restaurants.where((restaurant) {
              final restaurantName =
                  restaurant["name"].toString().toLowerCase();
              final restaurantCuisine =
                  restaurant["cuisine"].toString().toLowerCase();
              final restaurantAddress =
                  restaurant["address"].toString().toLowerCase();
              final searchLower = query.toLowerCase();

              return restaurantName.contains(searchLower) ||
                  restaurantCuisine.contains(searchLower) ||
                  restaurantAddress.contains(searchLower);
            }).toList();
      }
    });
  }

  void sortByRating() {
    setState(() {
      displayedRestaurants.sort((a, b) {
        double ratingA = double.parse(a["rating"].toString());
        double ratingB = double.parse(b["rating"].toString());
        return ratingB.compareTo(ratingA);
      });
    });
    _showSnackbar("Sorted by highest rating");
  }

  void sortByName() {
    setState(() {
      displayedRestaurants.sort((a, b) {
        return a["name"].toString().compareTo(b["name"].toString());
      });
    });
    _showSnackbar("Sorted alphabetically by name");
  }

  void sortByCuisine() {
    setState(() {
      displayedRestaurants.sort((a, b) {
        return a["cuisine"].toString().compareTo(b["cuisine"].toString());
      });
    });
    _showSnackbar("Sorted by cuisine type");
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _navigateToDetails(Map<String, dynamic> restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RestaurantDetailsPage(
              restaurantId: restaurant["detailsId"] ?? restaurant["id"],
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
              isLiked: widget.favoriteRestaurants.any(
                (fav) => fav["id"] == restaurant["id"],
              ),
              onFavoriteToggled: (bool newValue) {
                if (newValue !=
                    widget.favoriteRestaurants.any(
                      (fav) => fav["id"] == restaurant["id"],
                    )) {
                  widget.toggleFavorite(restaurant);
                }
              },
              onFavoriteChanged: (bool isFavorite) {},
            ),
      ),
    );
  }

  void _handleBookTable(Map<String, dynamic> restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RestaurantDetailsPage(
              restaurantId: restaurant["detailsId"] ?? restaurant["id"],
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
              isLiked: widget.favoriteRestaurants.any(
                (fav) => fav["id"] == restaurant["id"],
              ),
              onFavoriteToggled: (bool newValue) {
                if (newValue !=
                    widget.favoriteRestaurants.any(
                      (fav) => fav["id"] == restaurant["id"],
                    )) {
                  widget.toggleFavorite(restaurant);
                }
              },
              onFavoriteChanged: (bool isFavorite) {},
            ),
      ),
    );
  }

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
                    searchQuery = "";
                    displayedRestaurants = List.from(widget.restaurants);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showSortFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                              displayedRestaurants = List.from(
                                widget.restaurants,
                              );
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
          ),

          // Restaurant count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${displayedRestaurants.length} restaurants found",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Restaurant list
          Expanded(
            child:
                displayedRestaurants.isEmpty
                    ? const Center(
                      child: Text(
                        "No restaurants found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: displayedRestaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = displayedRestaurants[index];
                        final isFavorite = widget.favoriteRestaurants.any(
                          (fav) => fav["id"] == restaurant["id"],
                        );

                        return RestaurantCard(
                          restaurant: restaurant,
                          isFavorite: isFavorite,
                          onFavoriteToggle:
                              () => widget.toggleFavorite(restaurant),
                          onTap: () => _navigateToDetails(restaurant),
                          onBookTable: () => _handleBookTable(restaurant),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
