// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
//   final List<String> trendingImages = [
//     'assets/images/trending1.jpg',
//     'assets/images/trending2.jpg',
//     'assets/images/trending3.jpg',
//     'assets/images/trending4.jpg',
//     'assets/images/trending5.jpg',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // Get the screen dimensions
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = mediaQuery.size.width;
//     final screenHeight = mediaQuery.size.height;

//     // Calculate responsive sizes
//     final padding = mediaQuery.padding;
//     final appBarHeight = AppBar().preferredSize.height;
//     final safePadding = mediaQuery.viewPadding;

//     // Define responsive sizes
//     final double titleFontSize = screenWidth * 0.05;
//     final double subtitleFontSize = screenWidth * 0.035;
//     final double iconSize = screenWidth * 0.06;
//     final double cardPadding = screenWidth * 0.04;
//     final double gridSpacing = screenWidth * 0.03;
//     final double carouselHeight = screenHeight * 0.25;

//     return Scaffold(
//       appBar: AppBar(
//         title: FutureBuilder<String?>(
//           builder: (context, snapshot) {
//             String displayText =
//                 snapshot.hasData && snapshot.data != null
//                     ? 'Welcome ${snapshot.data}'
//                     : 'Welcome User!';
//             return Text(
//               displayText,
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: titleFontSize,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           },
//           future: null,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search, color: Colors.black, size: iconSize),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.account_circle,
//               color: Colors.black,
//               size: iconSize,
//             ),
//             onPressed: () {},
//           ),
//         ],
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: cardPadding,
//                 vertical: screenHeight * 0.01,
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     color: Colors.black,
//                     size: iconSize * 0.8,
//                   ),
//                   SizedBox(width: screenWidth * 0.02),
//                   Expanded(
//                     child: Text(
//                       'Borivali, Mumbai, Maharashtra, India',
//                       style: TextStyle(
//                         fontSize: subtitleFontSize,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: screenHeight * 0.015,
//                 horizontal: cardPadding,
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     'Trending ',
//                     style: TextStyle(
//                       fontSize: titleFontSize,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Icon(
//                     Icons.local_fire_department,
//                     color: Colors.red,
//                     size: iconSize,
//                   ),
//                 ],
//               ),
//             ),
//             CarouselSlider(
//               options: CarouselOptions(
//                 height: carouselHeight,
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _currentIndex = index;
//                   });
//                 },
//               ),
//               items:
//                   trendingImages.map((imagePath) {
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(screenWidth * 0.03),
//                       child: Image.asset(
//                         imagePath,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     );
//                   }).toList(),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children:
//                   trendingImages.map((url) {
//                     int index = trendingImages.indexOf(url);
//                     return Container(
//                       width: screenWidth * 0.02,
//                       height: screenWidth * 0.02,
//                       margin: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.01,
//                         vertical: screenHeight * 0.01,
//                       ),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color:
//                             _currentIndex == index ? Colors.black : Colors.grey,
//                       ),
//                     );
//                   }).toList(),
//             ),
//             SizedBox(height: screenHeight * 0.02),

//             // Hiremi's Features Section
//             Padding(
//               padding: EdgeInsets.only(left: cardPadding),
//               child: Text(
//                 "Hiremi's Featured",
//                 style: TextStyle(
//                   fontSize: titleFontSize,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: cardPadding),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: gridSpacing,
//                   mainAxisSpacing: gridSpacing,
//                   childAspectRatio:
//                       mediaQuery.orientation == Orientation.portrait
//                           ? 1.5
//                           : 2.5,
//                 ),
//                 itemCount: 6,
//                 itemBuilder: (context, index) {
//                   String title, description;
//                   Color startColor, endColor;
//                   String imagePath;

//                   if (index == 0) {
//                     title = 'Ask Expert';
//                     description = 'Ask Anything Get Expert Guidance';
//                     endColor = Colors.blue.shade400;
//                     startColor = Colors.lightBlue.shade100;
//                     imagePath = 'assets/images/hotel.jpg';
//                   } else if (index == 1) {
//                     title = 'Internship';
//                     description = 'Gain Practical Experience';
//                     endColor = Colors.green.shade400;
//                     startColor = Colors.lightGreen.shade100;
//                     imagePath = 'assets/images/vehiclerental.jpg';
//                   } else if (index == 2) {
//                     title = 'Status';
//                     description = 'Apply Mentorship & more';
//                     endColor = Colors.pink.shade400;
//                     startColor = Colors.pink.shade100;
//                     imagePath = 'assets/images/restuarants.jpg';
//                   } else if (index == 3) {
//                     title = 'Freshers';
//                     description = 'Gain Practical Experience';
//                     endColor = Colors.yellow.shade400;
//                     startColor = Colors.yellow.shade100;
//                     imagePath = 'assets/images/placestoVisit.jpg';
//                   } else if (index == 4) {
//                     title = 'Hiremi 360';
//                     description = 'Gain Practical Experience';
//                     endColor = Colors.orange.shade400;
//                     startColor = Colors.orange.shade100;
//                     imagePath = 'assets/hiremi_360.png';
//                   } else {
//                     title = 'Experience';
//                     description = 'Explore diverse careers';
//                     endColor = Colors.purple.shade400;
//                     startColor = Colors.purple.shade100;
//                     imagePath = 'assets/experience.png';
//                   }

//                   return GestureDetector(
//                     onTap: () {
//                       // Add your navigation logic here
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [startColor, Colors.white, endColor],
//                           stops: [0.0, 0.65, 1.0],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(screenWidth * 0.03),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(screenWidth * 0.02),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     title,
//                                     style: TextStyle(
//                                       fontSize: subtitleFontSize,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenHeight * 0.005),
//                                   Text(
//                                     description,
//                                     style: TextStyle(
//                                       fontSize: subtitleFontSize * 0.8,
//                                       fontWeight: FontWeight.w400,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Image.asset(
//                               imagePath,
//                               width: screenWidth * 0.15,
//                               height: screenWidth * 0.15,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:city_wheels/screens/ai_page.dart';
import 'package:city_wheels/screens/all_bookings_page.dart';
import 'package:city_wheels/screens/recommendations_page.dart';
import 'package:city_wheels/screens/restaurants_listings.dart';
import 'package:city_wheels/screens/vehicle_rental_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/top_bar.dart';
import '../widgets/sidebar.dart';

import '../screens/hotels_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<String> trendingImages = [
    'assets/images/trending1.jpg',
    'assets/images/trending2.jpg',
    'assets/images/trending3.jpg',
    'assets/images/trending4.jpg',
    'assets/images/trending5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions using MediaQuery
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    // final padding = mediaQuery.padding;

    // Calculate responsive sizes
    final double titleFontSize = screenWidth * 0.05;
    final double subtitleFontSize = screenWidth * 0.035;
    final double iconSize = screenWidth * 0.06;
    final double cardPadding = screenWidth * 0.04;
    final double gridSpacing = screenWidth * 0.03;
    final double carouselHeight = screenHeight * 0.25;

    return Scaffold(
      appBar: const TopBar(),
      drawer: const Sidebar(), // Use the Sidebar widget
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Row
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: screenHeight * 0.01,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.location_on,
                  //         color: Colors.black,
                  //         size: iconSize * 0.8,
                  //       ),
                  //       SizedBox(width: screenWidth * 0.02),
                  //       Expanded(
                  //         child: Text(
                  //           'Borivali, Mumbai, Maharashtra, India',
                  //           style: TextStyle(
                  //             fontSize: subtitleFontSize,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Trending Section Title
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Trending ',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                          size: iconSize,
                        ),
                      ],
                    ),
                  ),

                  // Carousel Slider
                  CarouselSlider(
                    options: CarouselOptions(
                      height: carouselHeight,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items:
                        trendingImages.map((imagePath) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.03,
                            ),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              width: constraints.maxWidth,
                            ),
                          );
                        }).toList(),
                  ),

                  // Carousel Indicators
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        trendingImages.map((url) {
                          int index = trendingImages.indexOf(url);
                          return Container(
                            width: screenWidth * 0.02,
                            height: screenWidth * 0.02,
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01,
                              vertical: screenHeight * 0.01,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _currentIndex == index
                                      ? Colors.black
                                      : Colors.grey,
                            ),
                          );
                        }).toList(),
                  ),

                  // Hiremi's Features Section
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "CityWheel's Featured",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Grid View
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: gridSpacing,
                      mainAxisSpacing: gridSpacing,
                      childAspectRatio:
                          mediaQuery.orientation == Orientation.portrait
                              ? 1.5
                              : 2.5,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          'title': 'Hotel Bookings',
                          'description': 'Find the perfect stay for your trip',
                          'startColor': Colors.lightBlue.shade100,
                          'endColor': Colors.blue.shade400,
                          'imagePath': 'assets/images/hotel1.png',
                        },
                        {
                          'title': 'Vehicle Rentals',
                          'description': 'Rent a vehicle anytime, anywhere',
                          'startColor': Colors.lightGreen.shade100,
                          'endColor': Colors.green.shade400,
                          'imagePath': 'assets/images/vehiclerental.png',
                        },
                        {
                          'title': ' Restaurant Listings',
                          'description':
                              'Discover the best dining spots in the city',
                          'startColor': Colors.pink.shade100,
                          'endColor': Colors.pink.shade400,
                          'imagePath': 'assets/images/restuarant.png',
                        },
                        {
                          'title': 'Ask Expert Chatbot',
                          'description':
                              'Instant help for all your travel queries',
                          'startColor': Colors.yellow.shade100,
                          'endColor': Colors.yellow.shade400,
                          'imagePath': 'assets/images/chatbot1.png',
                        },
                        {
                          'title': 'Places to Visit',
                          'description':
                              'Explore must-visit attractions near you.',
                          'startColor': Colors.orange.shade100,
                          'endColor': Colors.orange.shade400,
                          'imagePath': 'assets/images/placestovisit.png',
                        },
                        // {
                        //   'title': 'CityWheels360',
                        //   'description': 'Explore diverse places',
                        //   'startColor': Colors.purple.shade100,
                        //   'endColor': Colors.purple.shade400,
                        //   'imagePath': 'assets/images/placestovisit.png',
                        // },
                        {
                          'title': 'My Bookings',
                          'description': 'View all your bookings in one place',
                          'startColor': Colors.purple.shade100,
                          'endColor': Colors.purple.shade400,
                          'imagePath':
                              'assets/images/placestovisit.png', // Make sure to add this image
                        },
                      ];

                      final item = items[index];

                      return GestureDetector(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HotelsPage(),
                                ),
                              );
                              break;
                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const VehicleRentalPage(),
                                ),
                              );
                              break;
                            case 2:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const RestaurantListingsPage(),
                                ),
                              );
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AIPage(),
                                ),
                              );
                              break;
                            case 4:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const RecommendationsPage(),
                                ),
                              );
                              break;
                            case 5:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AllBookingsPage(),
                                ),
                              );
                              break;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                item['startColor'] as Color,
                                Colors.white,
                                item['endColor'] as Color,
                              ],
                              stops: const [0.0, 0.65, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.03,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['title'] as String,
                                        style: TextStyle(
                                          fontSize: subtitleFontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.005),
                                      Text(
                                        item['description'] as String,
                                        style: TextStyle(
                                          fontSize: subtitleFontSize * 0.8,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  item['imagePath'] as String,
                                  width: screenWidth * 0.15,
                                  height: screenWidth * 0.15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
