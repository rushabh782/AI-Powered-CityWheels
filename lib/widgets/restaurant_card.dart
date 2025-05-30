// import 'package:flutter/material.dart';

// class RestaurantCard extends StatelessWidget {
//   final String documentId;
//   final String imageUrl;
//   final String name;
//   final String cuisine;
//   final double rating;
//   final bool isLiked;

//   const RestaurantCard({
//     super.key,
//     required this.documentId,
//     required this.imageUrl,
//     required this.name,
//     required this.cuisine,
//     required this.rating,
//     this.isLiked = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 5,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 // 🖼️ Load Image from Firestore URL
//                 Image.network(
//                   imageUrl,
//                   height: 150,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value:
//                             progress.expectedTotalBytes != null
//                                 ? progress.cumulativeBytesLoaded /
//                                     (progress.expectedTotalBytes ?? 1)
//                                 : null,
//                       ),
//                     );
//                   },
//                   errorBuilder:
//                       (context, error, stackTrace) =>
//                           const Icon(Icons.broken_image, size: 150),
//                 ),

//                 // ❤️ Like Button
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: GestureDetector(
//                     onTap: () {
//                       // Handle like functionality (Optional)
//                     },
//                     child: CircleAvatar(
//                       // ignore: deprecated_member_use
//                       backgroundColor: Colors.white.withOpacity(0.8),
//                       child: Icon(
//                         isLiked ? Icons.favorite : Icons.favorite_border,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // 📌 Restaurant Info
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(cuisine, style: const TextStyle(color: Colors.grey)),
//                   const SizedBox(height: 5),

//                   // ⭐ Rating + Table Booking
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // ⭐ Rating
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.star,
//                             color: Colors.orange,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             rating.toString(),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),

//                       // 📅 Table Booking Button
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           // Handle table booking
//                         },
//                         icon: const Icon(Icons.table_bar, size: 16),
//                         label: const Text("Table Booking"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           textStyle: const TextStyle(fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //restaurant_card.dart
// import 'package:flutter/material.dart';

// class RestaurantCard extends StatelessWidget {
//   final Map<String, dynamic> restaurant;
//   final bool isFavorite;
//   final VoidCallback onFavoriteToggle;
//   final VoidCallback onTap;

//   const RestaurantCard({
//     super.key,
//     required this.restaurant,
//     required this.isFavorite,
//     required this.onFavoriteToggle,
//     required this.onTap, required Future<Null> Function() onBookTable,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 5,
//         margin: const EdgeInsets.only(bottom: 16),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   // 🖼️ Load Image from Firestore URL
//                   Image.network(
//                     restaurant["image"] ?? "",
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, progress) {
//                       if (progress == null) return child;
//                       return Container(
//                         height: 150,
//                         width: double.infinity,
//                         color: Colors.grey[200],
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             value:
//                                 progress.expectedTotalBytes != null
//                                     ? progress.cumulativeBytesLoaded /
//                                         (progress.expectedTotalBytes ?? 1)
//                                     : null,
//                           ),
//                         ),
//                       );
//                     },
//                     errorBuilder:
//                         (context, error, stackTrace) => Container(
//                           height: 150,
//                           width: double.infinity,
//                           color: Colors.grey[200],
//                           child: const Icon(Icons.restaurant, size: 50),
//                         ),
//                   ),

//                   // Rating chip
//                   Positioned(
//                     top: 10,
//                     left: 10,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.star, color: Colors.white, size: 16),
//                           const SizedBox(width: 2),
//                           Text(
//                             restaurant["rating"] ?? "0.0",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // ❤️ Favorite Button
//                   // Positioned(
//                   //   top: 10,
//                   //   right: 10,
//                   //   child: GestureDetector(
//                   //     onTap: onFavoriteToggle,
//                   //     child: CircleAvatar(
//                   //       radius: 18,
//                   //       // ignore: deprecated_member_use
//                   //       backgroundColor: Colors.white.withOpacity(0.8),
//                   //       child: Icon(
//                   //         isFavorite ? Icons.favorite : Icons.favorite_border,
//                   //         color: Colors.red,
//                   //         size: 20,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),

//               // 📌 Restaurant Info
//               // Inside the Padding widget in the RestaurantCard class
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             restaurant["name"] ?? "",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             isFavorite ? Icons.favorite : Icons.favorite_border,
//                             color: Colors.red,
//                           ),
//                           onPressed: onFavoriteToggle,
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       restaurant["cuisine"] ?? "",
//                       style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       restaurant["address"] ?? "",
//                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 12),

//                     // Book Table Button
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.end,
//                     //   children: [
//                     //     ElevatedButton.icon(
//                     //       onPressed:
//                     //           onTap, // Use the same onTap function that's used for the card
//                     //       icon: const Icon(Icons.table_bar, size: 16),
//                     //       label: const Text("Book Table"),
//                     //       style: ElevatedButton.styleFrom(
//                     //         backgroundColor: Theme.of(context).primaryColor,
//                     //         foregroundColor: Colors.white,
//                     //         padding: const EdgeInsets.symmetric(
//                     //           horizontal: 12,
//                     //           vertical: 8,
//                     //         ),
//                     //         textStyle: const TextStyle(fontSize: 12),
//                     //         shape: RoundedRectangleBorder(
//                     //           borderRadius: BorderRadius.circular(8),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: ElevatedButton.icon(
//                         onPressed: onTap,
//                         icon: const Icon(Icons.table_bar, size: 18),
//                         label: const Text(
//                           "Book Table",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           elevation: 2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;
  final VoidCallback onBookTable;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
    required this.onBookTable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              child: Stack(
                children: [
                  Image.network(
                    restaurant["image"] ?? "",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        (progress.expectedTotalBytes ?? 1)
                                    : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.restaurant, size: 50),
                        ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
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
                          const Icon(Icons.star, color: Colors.white, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            restaurant["rating"] ?? "0.0",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: CircleAvatar(
                        radius: 18,
                        // ignore: deprecated_member_use
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 20,
                        ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant["name"] ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant["cuisine"] ?? "",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant["address"] ?? "",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onBookTable,
                      icon: const Icon(Icons.table_bar, size: 18),
                      label: const Text(
                        "Book Table",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
