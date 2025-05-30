// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MapScreen extends StatefulWidget {
//   final double latitude;
//   final double longitude;

//   const MapScreen({super.key, required this.latitude, required this.longitude});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late MapController _mapController;
//   late LatLng selectedLocation;
//   final TextEditingController _searchController = TextEditingController();
//   bool _isLoading = false;
//   List<Map<String, dynamic>> _suggestions = [];
//   String? _errorMessage;
//   bool _isDisposed = false;

//   List<Map<String, dynamic>> hotelList = [];

//   final List<LatLng> _home = [LatLng(19.22302046430575, 72.84087107987945)];

//   final List<LatLng> _sfit = [LatLng(19.24352668552024, 72.85575111924409)];

//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//     selectedLocation = LatLng(widget.latitude, widget.longitude);
//     _loadHotels();
//   }

//   @override
//   void dispose() {
//     _isDisposed = true;
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onMapTapped(TapPosition tapPosition, LatLng latLng) {
//     setState(() {
//       selectedLocation = latLng;
//     });
//   }

//   Future<void> _loadHotels() async {
//     List<Map<String, dynamic>> hotels = await fetchHotels();
//     setState(() {
//       hotelList = hotels;
//     });
//   }

//   Future<List<Map<String, dynamic>>> fetchHotels() async {
//     List<Map<String, dynamic>> hotels = [];

//     QuerySnapshot snapshot =
//         await FirebaseFirestore.instance.collection('hotels').get();

//     for (var doc in snapshot.docs) {
//       var data = doc.data() as Map<String, dynamic>;

//       // hotels.add({
//       //   "documentId": doc.id,
//       //   "name": data["name"],
//       //   "latitude": data["latitude"],
//       //   "longitude": data["longitude"],
//       //   "description": data["description"],
//       //   "rating": data["rating"],
//       // });

//       hotels.add({
//         "documentId": doc.id,
//         "name": data["name"],
//         "latitude": double.tryParse(data["latitude"].toString()) ?? 0.0,
//         "longitude": double.tryParse(data["longitude"].toString()) ?? 0.0,
//         "description": data["description"],
//         "rating": double.tryParse(data["rating"].toString()) ?? 0.0,
//       });
//     }

//     return hotels;
//   }

//   // Debounced function to fetch search suggestions
//   Future<void> _fetchSuggestions(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         _suggestions = [];
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     final url = Uri.parse(
//       "https://nominatim.openstreetmap.org/search?format=json&q=$query",
//     );

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'User-Agent':
//               'CityWheelsApp/1.0 (contact@citywheels.com)', // Valid User-Agent
//         },
//       );

//       if (!mounted || _isDisposed)
//         return; // Prevent setState if widget is disposed

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _suggestions =
//               data.map<Map<String, dynamic>>((place) {
//                 return {
//                   "display_name": place["display_name"],
//                   "lat": double.parse(place["lat"]),
//                   "lon": double.parse(place["lon"]),
//                 };
//               }).toList();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = "Error: ${response.statusCode}";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (!mounted || _isDisposed) return;
//       setState(() {
//         _errorMessage = "Failed to fetch data. Please check your connection.";
//         _isLoading = false;
//       });
//     }
//   }

//   // Function to select a location from suggestions
//   void _selectLocation(Map<String, dynamic> place) {
//     setState(() {
//       selectedLocation = LatLng(place["lat"], place["lon"]);
//       _mapController.move(selectedLocation, 15.0);
//       _searchController.text = place["display_name"];
//       _suggestions = []; // Hide suggestions
//     });
//   }

//   bool isNearLocation(
//     LatLng selectedLocation,
//     List<LatLng> targetLocations, {
//     double thresholdMeters = 50,
//   }) {
//     final Distance distance = Distance();

//     for (LatLng target in targetLocations) {
//       final double meters = distance(selectedLocation, target);
//       if (meters <= thresholdMeters) {
//         return true; // Location is within the threshold
//       }
//     }

//     return false; // Location is outside all defined points
//   }

//   Future<String?> _getAddressFromLatLng(LatLng latLng) async {
//     if (isNearLocation(selectedLocation, _home)) {
//       return "AHCL Homes, Near Shimpoli Metro Station, Borivali West, Mumbai-400092";
//     }

//     if (isNearLocation(selectedLocation, _sfit)) {
//       return "St. Francis Institute of Technology, Sardar Vallabhai Patel Road, Shivaji Nagar, Mumbai-400103";
//     }

//     final url = Uri.parse(
//       "https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}",
//     );

//     try {
//       final response = await http.get(
//         url,
//         headers: {'User-Agent': 'CityWheelsApp/1.0 (contact@citywheels.com)'},
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data["display_name"]; // Extract address
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   void _showHotelDetailsDialog(
//     BuildContext context,
//     Map<String, dynamic> hotel,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(hotel["name"]),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "📍 Location: (${hotel["latitude"]}, ${hotel["longitude"]})",
//               ),
//               Text("📝 Description: ${hotel["description"]}"),
//               Text("⭐ Rating: ${hotel["rating"]}"),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Location on Map")),
//       body: Stack(
//         children: [
//           // FlutterMap(
//           //   mapController: _mapController,
//           //   options: MapOptions(
//           //     initialCenter: selectedLocation,
//           //     initialZoom: 15.0,
//           //     onTap: _onMapTapped,
//           //   ),
//           //   children: [
//           //     TileLayer(
//           //       urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//           //     ),
//           //     MarkerLayer(
//           //       markers: [
//           //         Marker(
//           //           point: selectedLocation,
//           //           child: const Icon(
//           //             Icons.location_pin,
//           //             color: Colors.red,
//           //             size: 40,
//           //           ),
//           //         ),
//           //         ...hotelList.map((hotel) {
//           //           return Marker(
//           //             point: LatLng(hotel["latitude"], hotel["longitude"]),
//           //             child: GestureDetector(
//           //               onTap:
//           //                   () => _showHotelDetailsDialog(
//           //                     context,
//           //                     hotel,
//           //                   ), // Show details
//           //               child: Icon(
//           //                 Icons.hotel, // Hotel Icon
//           //                 color: Colors.blue, // Customize hotel color
//           //                 size: 40,
//           //               ),
//           //             ),
//           //           );
//           //         }).toList(),
//           //       ],
//           //     ),
//           //   ],
//           // ),
//           // FlutterMap(
//           //   mapController: _mapController,
//           //   options: MapOptions(
//           //     initialCenter: selectedLocation,
//           //     initialZoom: 15.0,
//           //     onTap: _onMapTapped,
//           //   ),
//           //   children: [
//           //     TileLayer(
//           //       urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//           //       userAgentPackageName: 'com.example.citywheels',
//           //     ),
//           //     MarkerLayer(
//           //       markers:
//           //           [
//           //             Marker(
//           //               width: 40.0,
//           //               height: 40.0,
//           //               point: selectedLocation,
//           //               child: const Icon(
//           //                 Icons.location_pin,
//           //                 color: Colors.red,
//           //                 size: 40,
//           //               ),
//           //             ),
//           //             ...hotelList
//           //                 .map((hotel) {
//           //                   // Validate coordinates before creating marker
//           //                   final lat = hotel["latitude"] as double? ?? 0.0;
//           //                   final lng = hotel["longitude"] as double? ?? 0.0;

//           //                   // Skip invalid coordinates
//           //                   if (lat == 0.0 && lng == 0.0) return null;

//           //                   return Marker(
//           //                     width: 40.0,
//           //                     height: 40.0,
//           //                     point: LatLng(lat, lng),
//           //                     child: GestureDetector(
//           //                       onTap:
//           //                           () =>
//           //                               _showHotelDetailsDialog(context, hotel),
//           //                       child: const Icon(
//           //                         Icons.hotel,
//           //                         color: Colors.blue,
//           //                         size: 40,
//           //                       ),
//           //                     ),
//           //                   );
//           //                 })
//           //                 .where((marker) => marker != null)
//           //                 .cast<Marker>()
//           //                 .toList(),
//           //           ].where((m) => m != null).cast<Marker>().toList(),
//           //     ),
//           //   ],
//           // ),
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: selectedLocation,
//               initialZoom: 15.0,
//               onTap: _onMapTapped,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//                 userAgentPackageName: 'com.example.citywheels',
//               ),
//               MarkerLayer(
//                 markers: [
//                   // Main selected location marker
//                   Marker(
//                     width: 40.0,
//                     height: 40.0,
//                     point: selectedLocation,
//                     child: const Icon(
//                       Icons.location_pin,
//                       color: Colors.red,
//                       size: 40,
//                     ),
//                   ),
//                   // Hotel markers with proper null safety
//                   ...hotelList
//                       .map((hotel) {
//                         try {
//                           final lat = (hotel["latitude"] as num?)?.toDouble();
//                           final lng = (hotel["longitude"] as num?)?.toDouble();

//                           if (lat == null || lng == null) return null;

//                           return Marker(
//                             width: 40.0,
//                             height: 40.0,
//                             point: LatLng(lat, lng),
//                             child: GestureDetector(
//                               onTap:
//                                   () => _showHotelDetailsDialog(context, hotel),
//                               child: const Icon(
//                                 Icons.hotel,
//                                 color: Colors.blue,
//                                 size: 40,
//                               ),
//                             ),
//                           );
//                         } catch (e) {
//                           debugPrint("Error creating marker for hotel: $e");
//                           return null;
//                         }
//                       })
//                       .whereType<
//                         Marker
//                       >(), // This filters out nulls and casts to Marker
//                 ],
//               ),
//             ],
//           ),
//           // Search Bar
//           Positioned(
//             top: 10,
//             left: 20,
//             right: 20,
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _searchController,
//                   onChanged: (query) {
//                     Future.delayed(const Duration(milliseconds: 500), () {
//                       _fetchSuggestions(query);
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Search for a place...",
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     suffixIcon:
//                         _isLoading
//                             ? const Padding(
//                               padding: EdgeInsets.all(10),
//                               child: CircularProgressIndicator(),
//                             )
//                             : const Icon(Icons.search),
//                   ),
//                 ),

//                 // Error Message
//                 if (_errorMessage != null)
//                   Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: Text(
//                       _errorMessage!,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),

//                 // Display Suggestions
//                 if (_suggestions.isNotEmpty)
//                   Container(
//                     margin: const EdgeInsets.only(top: 5),
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5),
//                       ],
//                     ),
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _suggestions.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(_suggestions[index]["display_name"]),
//                           onTap: () => _selectLocation(_suggestions[index]),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           // Confirm Location Button
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () async {
//                 String? address = await _getAddressFromLatLng(selectedLocation);

//                 // Return selected location along with the address
//                 // ignore: use_build_context_synchronously
//                 Navigator.pop(context, {
//                   "latitude": selectedLocation.latitude,
//                   "longitude": selectedLocation.longitude,
//                   "address": address ?? "Address not found",
//                 });
//               },
//               child: const Text("Confirm Location"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  late LatLng selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _suggestions = [];
  String? _errorMessage;
  bool _isDisposed = false;

  List<Map<String, dynamic>> hotelList = [];

  final List<LatLng> _home = [LatLng(19.22302046430575, 72.84087107987945)];
  final List<LatLng> _sfit = [LatLng(19.24352668552024, 72.85575111924409)];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    selectedLocation = LatLng(widget.latitude, widget.longitude);
    _loadHotels();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _searchController.dispose();
    super.dispose();
  }

  void _onMapTapped(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      selectedLocation = latLng;
    });
  }

  Future<void> _loadHotels() async {
    List<Map<String, dynamic>> hotels = await fetchHotels();
    setState(() {
      hotelList = hotels;
    });
  }

  Future<List<Map<String, dynamic>>> fetchHotels() async {
    List<Map<String, dynamic>> hotels = [];

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('hotels').get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        hotels.add({
          "documentId": doc.id,
          "name": data["name"]?.toString() ?? "Unknown Hotel",
          "latitude": (data["latitude"] as num?)?.toDouble() ?? 0.0,
          "longitude": (data["longitude"] as num?)?.toDouble() ?? 0.0,
          "description": data["description"]?.toString() ?? "No description",
          "rating": (data["rating"] as num?)?.toDouble() ?? 0.0,
        });
      }
    } catch (e) {
      debugPrint("Error fetching hotels: $e");
    }

    return hotels
        .where((hotel) => hotel["latitude"] != 0.0 && hotel["longitude"] != 0.0)
        .toList();
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?format=json&q=$query",
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'CityWheelsApp/1.0 (contact@citywheels.com)'},
      );

      if (!mounted || _isDisposed) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _suggestions =
              data
                  .map<Map<String, dynamic>>((place) {
                    return {
                      "display_name": place["display_name"],
                      "lat": double.tryParse(place["lat"]) ?? 0.0,
                      "lon": double.tryParse(place["lon"]) ?? 0.0,
                    };
                  })
                  .where((place) => place["lat"] != 0.0 && place["lon"] != 0.0)
                  .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted || _isDisposed) return;
      setState(() {
        _errorMessage = "Failed to fetch data. Please check your connection.";
        _isLoading = false;
      });
    }
  }

  void _selectLocation(Map<String, dynamic> place) {
    setState(() {
      selectedLocation = LatLng(place["lat"], place["lon"]);
      _mapController.move(selectedLocation, 15.0);
      _searchController.text = place["display_name"];
      _suggestions = [];
    });
  }

  bool isNearLocation(
    LatLng selectedLocation,
    List<LatLng> targetLocations, {
    double thresholdMeters = 50,
  }) {
    final Distance distance = Distance();
    for (LatLng target in targetLocations) {
      final double meters = distance(selectedLocation, target);
      if (meters <= thresholdMeters) return true;
    }
    return false;
  }

  Future<String?> _getAddressFromLatLng(LatLng latLng) async {
    if (isNearLocation(selectedLocation, _home)) {
      return "AHCL Homes, Near Shimpoli Metro Station, Borivali West, Mumbai-400092";
    }
    if (isNearLocation(selectedLocation, _sfit)) {
      return "St. Francis Institute of Technology, Sardar Vallabhai Patel Road, Shivaji Nagar, Mumbai-400103";
    }

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}",
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'CityWheelsApp/1.0 (contact@citywheels.com)'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["display_name"];
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
    return null;
  }

  // ignore: unused_element
  void _showHotelDetailsDialog(
    BuildContext context,
    Map<String, dynamic> hotel,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hotel["name"]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "📍 Location: (${hotel["latitude"]}, ${hotel["longitude"]})",
              ),
              Text("📝 Description: ${hotel["description"]}"),
              Text("⭐ Rating: ${hotel["rating"]}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location on Map")),
      body: Stack(
        children: [
          // FlutterMap(
          //   mapController: _mapController,
          //   options: MapOptions(
          //     center: selectedLocation, // Changed from initialCenter to center
          //     zoom: 15.0, // Changed from initialZoom to zoom
          //     onTap: _onMapTapped,
          //   ),
          //   children: [
          //     TileLayer(
          //       urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          //       userAgentPackageName: 'com.example.citywheels',
          //     ),
          //     MarkerLayer(
          //       markers: [
          //         Marker(
          //           width: 40.0,
          //           height: 40.0,
          //           point: selectedLocation,
          //           child: const Icon(
          //             Icons.location_pin,
          //             color: Colors.red,
          //             size: 40,
          //           ), builder: (BuildContext context) {  },
          //         ),
          //         ...hotelList.map((hotel) {
          //           final lat = hotel["latitude"] as double;
          //           final lng = hotel["longitude"] as double;
          //           return Marker(
          //             width: 40.0,
          //             height: 40.0,
          //             point: LatLng(lat, lng),
          //             child: GestureDetector(
          //               onTap: () => _showHotelDetailsDialog(context, hotel),
          //               child: const Icon(
          //                 Icons.hotel,
          //                 color: Colors.blue,
          //                 size: 40,
          //               ),
          //             ),
          //           );
          //         }).toList(),
          //       ],
          //     ),
          //   ],
          // ),
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: selectedLocation,
              zoom: 15.0,
              onTap: _onMapTapped,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.citywheels',
              ),
              // MarkerLayer(
              //   markers: [
              //     Marker(
              //       width: 40.0,
              //       height: 40.0,
              //       point: selectedLocation,
              //       child: Icon(
              //         Icons.location_pin,
              //         color: Colors.red,
              //         size: 40,
              //       ),
              //     ),
              //     ...hotelList.map((hotel) {
              //       final lat = hotel["latitude"] as double;
              //       final lng = hotel["longitude"] as double;
              //       return Marker(
              //         width: 40.0,
              //         height: 40.0,
              //         point: LatLng(lat, lng),
              //         child: Icon(Icons.hotel, color: Colors.blue, size: 40),
              //       );
              //     }).toList(),
              //   ],
              // ),
            ],
          ),
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      _fetchSuggestions(query);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search for a place...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon:
                        _isLoading
                            ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(),
                            )
                            : const Icon(Icons.search),
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (_suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_suggestions[index]["display_name"]),
                          onTap: () => _selectLocation(_suggestions[index]),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                String? address = await _getAddressFromLatLng(selectedLocation);
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.pop(context, {
                  "latitude": selectedLocation.latitude,
                  "longitude": selectedLocation.longitude,
                  "address": address ?? "Address not found",
                });
              },
              child: const Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}
