import 'package:flutter/material.dart';
import 'vehicle_details.dart';

class VehicleCard extends StatefulWidget {
  final String type;
  final String imageUrl;
  final double pricePerHour;
  final String vehicleId;
  final String name;
  final double ratings;

  const VehicleCard({
    super.key,
    required this.type,
    required this.imageUrl,
    required this.pricePerHour,
    required this.vehicleId,
    required this.name,
    required this.ratings,
  });

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  bool _showDetails = false; // Track hover/tap state

  Widget _buildGlowingText(
    String text, {
    double fontSize = 24.0,
    FontWeight fontWeight = FontWeight.normal,
    List<Color> colors = const [Colors.black, Colors.white],
  }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          shadows:
              colors.map((color) {
                return Shadow(
                  color: color,
                  offset: Offset(0, 0),
                  blurRadius: 10.0,
                );
              }).toList(),
        ),
        children: [TextSpan(text: text, style: TextStyle(color: colors.first))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontScale = screenWidth / 400;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showDetails = !_showDetails;
        });
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _showDetails = true),
        onExit: (_) => setState(() => _showDetails = false),
        child: Container(
          width: screenWidth,
          height: screenHeight * 0.25,
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.2),
                blurRadius: screenWidth * 0.02,
                spreadRadius: screenWidth * 0.005,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                child: Image.network(
                  widget.imageUrl,
                  width: screenWidth,
                  height: screenHeight * 0.25,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: screenWidth * 0.01,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.car_rental,
                        size: screenWidth * 0.2,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
              ),

              // Overlay effect (shows only when _showDetails is true)
              if (_showDetails)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        // ignore: deprecated_member_use
                        Colors.black.withOpacity(0.6),
                        // ignore: deprecated_member_use
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),

              // Details (show only when hovered/clicked)
              if (_showDetails)
                Positioned(
                  bottom: screenHeight * 0.03,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGlowingText(
                        widget.name,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        colors: [
                          Colors.white,
                          Colors.red,
                        ], // Black glow, Gold text
                      ),
                      SizedBox(height: screenHeight * 0.005),

                      // Rating Stars
                      Row(
                        children: [
                          // Text(
                          //   widget.ratings.toString(),
                          //   style: TextStyle(
                          //     fontSize: 16 * fontScale,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          _buildGlowingText(
                            widget.ratings.toString(),
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.bold,
                            colors: [
                              Colors.white,
                              Colors.blue,
                            ], // Black glow, Gold text
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                size: screenWidth * 0.05,
                                color:
                                    index < widget.ratings.floor()
                                        ? Colors.blue
                                        : (index < widget.ratings
                                            // ignore: deprecated_member_use
                                            ? Colors.blue.withOpacity(0.5)
                                            : Colors.grey),
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.005),

                      // Price & Rent Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(
                          //   'Starts from ₹${widget.pricePerHour?.toStringAsFixed(0) ?? "0"}',
                          //   style: TextStyle(
                          //     fontSize: 16 * fontScale,
                          //     color: Colors.green,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          _buildGlowingText(
                            'Starts from ₹${widget.pricePerHour.toStringAsFixed(0)}',
                            fontSize: 16 * fontScale,
                            fontWeight: FontWeight.bold,
                            colors: [Colors.green, Colors.blue],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.012,
                              ),
                              textStyle: TextStyle(fontSize: 12 * fontScale),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => VehicleDetailsPage(
                                        documentId: widget.vehicleId,
                                      ),
                                ),
                              );
                            },
                            child: _buildGlowingText(
                              'Rent Now',
                              fontSize: 12 * fontScale,
                              fontWeight: FontWeight.bold,
                              colors: [
                                Colors.white,
                                Colors.blueAccent,
                              ], // Adjust glow colors as needed
                            ),
                          ),
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
  }
}
