import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteHotels;

  const FavoritesPage({super.key, required this.favoriteHotels});

  @override
  Widget build(BuildContext context) {
    if (favoriteHotels.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Favorites")),
        body: const Center(
          child: Text("No favorite hotels yet", style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: ListView.builder(
        itemCount: favoriteHotels.length,
        itemBuilder: (context, index) {
          final hotel = favoriteHotels[index];

          // Check if this is a direct hotel object or needs to be fetched
          if (hotel.containsKey("id") &&
              hotel.containsKey("name") &&
              hotel.containsKey("location") &&
              hotel.containsKey("image")) {
            // Direct object with all required fields
            return _buildHotelTile(hotel);
          } else if (hotel.containsKey("documentId") ||
              hotel.containsKey("id")) {
            // Need to fetch from Firestore
            final String documentId = hotel["documentId"] ?? hotel["id"];

            return FutureBuilder(
              future:
                  FirebaseFirestore.instance
                      .collection('hotels')
                      .doc(documentId)
                      .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text("Loading..."),
                    subtitle: Text("Please wait"),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return ListTile(
                    title: const Text("Hotel not found"),
                    subtitle: const Text("This hotel may have been removed."),
                    leading: Icon(Icons.error, color: Colors.red),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                // Convert Firestore data to match our expected structure
                final hotelData = {
                  "id": documentId,
                  "name": data["name"]?.trim() ?? "Unknown",
                  "location":
                      data["location"]?.trim() ?? "Location unavailable",
                  "image": data["imageUrl"]?.trim() ?? "",
                  "rating": data["rating"]?.trim() ?? "0.0",
                  "price": "₹${data["price"]?.trim() ?? "0"}/night",
                };

                return _buildHotelTile(hotelData);
              },
            );
          } else {
            // Handle case where hotel data format is unknown
            return ListTile(
              title: Text(hotel["name"] ?? "Unknown Hotel"),
              subtitle: const Text("Limited information available"),
              leading: Icon(Icons.hotel, color: Colors.grey),
            );
          }
        },
      ),
    );
  }

  Widget _buildHotelTile(Map<String, dynamic> hotel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.hardEdge,
          child:
              hotel["image"] != null && hotel["image"].toString().isNotEmpty
                  ? Image.network(
                    hotel["image"],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, size: 40),
                  )
                  : Icon(Icons.hotel, size: 40),
        ),
        title: Text(
          hotel["name"] ?? "Unknown",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hotel["location"] ?? "Location unavailable"),
            const SizedBox(height: 4),
            Row(
              children: [
                if (hotel["rating"] != null) ...[
                  Icon(Icons.star, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(hotel["rating"].toString()),
                  const SizedBox(width: 12),
                ],
                if (hotel["price"] != null)
                  Text(
                    hotel["price"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.favorite, color: Colors.red),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FavoritesPage extends StatelessWidget {
//   final List<Map<String, dynamic>>
//   favoriteHotels; // List of Maps containing documentId

//   const FavoritesPage({super.key, required this.favoriteHotels});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Favorites")),
//       body: ListView.builder(
//         itemCount: favoriteHotels.length,
//         itemBuilder: (context, index) {
//           final hotelData = favoriteHotels[index];
//           final String documentId =
//               hotelData["documentId"]; // Extract Firestore ID

//           return FutureBuilder<DocumentSnapshot>(
//             future:
//                 FirebaseFirestore.instance
//                     .collection('hotels')
//                     .doc(documentId)
//                     .get(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return ListTile(
//                   title: Text("Loading..."),
//                   subtitle: Text("Please wait"),
//                   leading: CircularProgressIndicator(),
//                 );
//               }

//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return ListTile(
//                   title: Text("Hotel not found"),
//                   subtitle: Text("This hotel may have been removed."),
//                   leading: Icon(Icons.error, color: Colors.red),
//                 );
//               }

//               final data = snapshot.data!.data() as Map<String, dynamic>;

//               return ListTile(
//                 leading: Image.network(
//                   data["imageUrl"] ?? "", // Handle potential null values
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                   errorBuilder:
//                       (context, error, stackTrace) => Icon(Icons.broken_image),
//                 ),
//                 title: Text(data["name"] ?? "Unknown"),
//                 subtitle: Text(data["location"] ?? "Location unavailable"),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
