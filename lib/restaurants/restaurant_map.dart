import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RestaurantMapPage extends StatelessWidget {
  final String restaurantName;
  final double latitude;
  final double longitude;

  // ignore: use_super_parameters
  const RestaurantMapPage({
    Key? key,
    required this.restaurantName,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantLocation = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FlutterMap(
        options: MapOptions(center: restaurantLocation, zoom: 15.0),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: restaurantLocation,
                builder:
                    (context) => Column(
                      children: [
                        const Icon(
                          Icons.restaurant,
                          color: Colors.red,
                          size: 40.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            restaurantName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // This is a simple action to re-center the map if needed
          // The current implementation already centers on the restaurant
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
