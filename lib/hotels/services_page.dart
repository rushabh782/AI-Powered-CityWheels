import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteHotels;

  const ServicesPage({super.key, required this.favoriteHotels});

  @override
  // ignore: library_private_types_in_public_api
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  List<Map<String, dynamic>> hotels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    try {
      setState(() {
        isLoading = true;
      });

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
              };
            }).toList();

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching hotels: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleFavorite(Map<String, dynamic> hotel) {
    setState(() {
      bool exists = widget.favoriteHotels.any(
        (favHotel) => favHotel["name"] == hotel["name"],
      );

      if (exists) {
        widget.favoriteHotels.removeWhere(
          (favHotel) => favHotel["name"] == hotel["name"],
        );
      } else {
        widget.favoriteHotels.add(hotel);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exists ? "Removed from favorites" : "Added to favorites",
          ),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Services")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
                  final isFavorite = widget.favoriteHotels.any(
                    (favHotel) => favHotel["id"] == hotel["id"],
                  );

                  return ListTile(
                    leading:
                        hotel["image"] != null
                            ? Image.network(
                              hotel["image"],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                            : Icon(Icons.hotel, size: 40),
                    title: Text(hotel["name"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hotel["location"]),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.orange),
                            Text(hotel["rating"].toString()),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(hotel["price"]),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => toggleFavorite(hotel),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}

// import 'package:flutter/material.dart';

// class ServicesPage extends StatefulWidget {
//   final List<Map<String, String>> favoriteHotels;

//   const ServicesPage({super.key, required this.favoriteHotels});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ServicesPageState createState() => _ServicesPageState();
// }

// class _ServicesPageState extends State<ServicesPage> {
//   final List<Map<String, String>> services = [
//     {
//       "name": "The Taj Lands End",
//       "location": "Jeejeebhoy Road, Mumbai",
//       "price": "₹22,000/night",
//     },
//     {
//       "name": "The Taj Mahal Palace",
//       "location": "Colaba, Mumbai",
//       "price": "₹27,000/night",
//     },
//     {
//       "name": "Novotel",
//       "location": "Western Suburbs, Mumbai",
//       "price": "₹10,999/night",
//     },
//     {
//       "name": "Trident",
//       "location": "Bandra, Mumbai",
//       "price": "₹ 11,750/night",
//     },
//   ];

//   void toggleFavorite(Map<String, String> hotel) {
//     setState(() {
//       bool exists = widget.favoriteHotels.any(
//         (favHotel) => favHotel["name"] == hotel["name"],
//       );

//       if (exists) {
//         widget.favoriteHotels.removeWhere(
//           (favHotel) => favHotel["name"] == hotel["name"],
//         );
//       } else {
//         widget.favoriteHotels.add(hotel);
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             exists ? "Removed from favorites" : "Added to favorites",
//           ),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Available Services")),
//       body: ListView.builder(
//         itemCount: services.length,
//         itemBuilder: (context, index) {
//           final hotel = services[index];
//           final isFavorite = widget.favoriteHotels.contains(hotel);

//           return ListTile(
//             title: Text(hotel["name"]!),
//             subtitle: Text(hotel["location"]!),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(hotel["price"]!),
//                 IconButton(
//                   icon: Icon(
//                     isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color: isFavorite ? Colors.red : null,
//                   ),
//                   onPressed: () => toggleFavorite(hotel),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
