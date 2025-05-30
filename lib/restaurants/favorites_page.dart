// import 'package:flutter/material.dart';
// import '../widgets/restaurant_card.dart';
// import '../restaurants/restaurant_details.dart';

// class FavoritesPage extends StatefulWidget {
//   final List<Map<String, dynamic>> favoriteRestaurants;
//   final Function(Map<String, dynamic>) onRemoveFavorite; // Add this callback

//   const FavoritesPage({
//     super.key,
//     required this.favoriteRestaurants,
//     required this.onRemoveFavorite, // Require this parameter
//   });

//   @override
//   State<FavoritesPage> createState() => _FavoritesPageState();
// }

// class _FavoritesPageState extends State<FavoritesPage> {
//   late List<Map<String, dynamic>> favorites;

//   @override
//   void initState() {
//     super.initState();
//     favorites = List.from(widget.favoriteRestaurants);
//   }

//   /// Removes a restaurant from favorites
//   void removeFromFavorites(Map<String, dynamic> restaurant) {
//     setState(() {
//       favorites.removeWhere((fav) => fav["id"] == restaurant["id"]);
//       widget.onRemoveFavorite(restaurant); // Update parent state
//       _showSnackbar("${restaurant["name"]} removed from favorites");
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
//         title: const Text("My Favorites"),
//         backgroundColor: Colors.blue,
//       ),
//       body:
//           favorites.isEmpty
//               ? _buildEmptyState()
//               : ListView.builder(
//                 padding: const EdgeInsets.all(12.0),
//                 itemCount: favorites.length,
//                 itemBuilder: (context, index) {
//                   final restaurant = favorites[index];

//                   return RestaurantCard(
//                     restaurant: restaurant,
//                     isFavorite: true,
//                     onFavoriteToggle: () => removeFromFavorites(restaurant),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => RestaurantDetailsPage(
//                                 restaurantId: restaurant["id"],
//                                 imageUrls: restaurant["imageUrls"],
//                                 name: restaurant["name"],
//                                 rating: double.parse(restaurant["rating"]),
//                                 address: restaurant["address"],
//                                 phone: restaurant["phone"],
//                                 description: restaurant["description"],
//                                 timing: restaurant["timing"],
//                                 isLiked: true,
//                                 onFavoriteChanged: (bool isFavorite) {
//                                   if (!isFavorite) {
//                                     removeFromFavorites(restaurant);
//                                   }
//                                 },
//                                 onFavoriteToggled: (bool newValue) {},
//                               ),
//                         ),
//                       ).then((_) {
//                         // Refresh the list when returning from details page
//                         setState(() {});
//                       });
//                     },
//                   );
//                 },
//               ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
//           const SizedBox(height: 16),
//           const Text(
//             "No favorites yet",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "Tap the heart icon on restaurants you like to add them to your favorites",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Browse Restaurants"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../widgets/restaurant_card.dart';
import '../restaurants/restaurant_details.dart';

class FavoritesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteRestaurants;
  final Function(Map<String, dynamic>) onRemoveFavorite;

  const FavoritesPage({
    super.key,
    required this.favoriteRestaurants,
    required this.onRemoveFavorite,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<Map<String, dynamic>> favorites;

  @override
  void initState() {
    super.initState();
    favorites = List.from(widget.favoriteRestaurants);
  }

  void removeFromFavorites(Map<String, dynamic> restaurant) {
    setState(() {
      favorites.removeWhere((fav) => fav["id"] == restaurant["id"]);
      widget.onRemoveFavorite(restaurant);
      _showSnackbar("${restaurant["name"]} removed from favorites");
    });
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
              isLiked: true,
              onFavoriteToggled: (bool newValue) {
                if (!newValue) {
                  removeFromFavorites(restaurant);
                }
              },
              onFavoriteChanged: (bool isFavorite) {},
            ),
      ),
    ).then((_) {
      setState(() {});
    });
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
              isLiked: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorites"),
        backgroundColor: Colors.blue,
      ),
      body:
          favorites.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final restaurant = favorites[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    isFavorite: true,
                    onFavoriteToggle: () => removeFromFavorites(restaurant),
                    onTap: () => _navigateToDetails(restaurant),
                    onBookTable: () => _handleBookTable(restaurant),
                  );
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No favorites yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the heart icon on restaurants you like to add them to your favorites",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Browse Restaurants"),
          ),
        ],
      ),
    );
  }
}
