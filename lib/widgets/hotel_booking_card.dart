// // lib/widgets/hotel_booking_card.dart
// import 'package:flutter/material.dart';

// class HotelBookingCard extends StatelessWidget {
//   final String hotelName;
//   final String imageUrl;
//   final String firstName;
//   final String checkInDate;
//   final String checkOutDate;
//   final String checkInTime;
//   final String checkOutTime;
//   final int numberOfAdults;
//   final int numberOfChildren;
//   final int numberOfDays;
//   final int numberOfRooms;
//   final double totalPrice;

//   const HotelBookingCard({
//     super.key,
//     required this.hotelName,
//     required this.imageUrl,
//     required this.firstName,
//     required this.checkInDate,
//     required this.checkOutDate,
//     required this.checkInTime,
//     required this.checkOutTime,
//     required this.numberOfAdults,
//     required this.numberOfChildren,
//     required this.numberOfDays,
//     required this.numberOfRooms,
//     required this.totalPrice,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.all(8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hotel Image
//             if (imageUrl.isNotEmpty)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   imageUrl,
//                   width: double.infinity,
//                   height: 150,
//                   fit: BoxFit.cover,
//                   errorBuilder:
//                       (context, error, stackTrace) => Container(
//                         height: 150,
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.error),
//                       ),
//                 ),
//               ),
//             const SizedBox(height: 12),

//             // Hotel Name
//             Text(
//               hotelName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),

//             // Guest Name
//             _buildDetailRow("Guest Name", firstName),

//             // Check-in Date
//             _buildDetailRow("Check-in Date", checkInDate),

//             // Check-in Time
//             _buildDetailRow("Check-in Time", checkInTime),

//             // Check-out Date
//             _buildDetailRow("Check-out Date", checkOutDate),

//             // Check-out Time
//             _buildDetailRow("Check-out Time", checkOutTime),

//             const SizedBox(height: 8),

//             // Booking Details
//             _buildDetailRow("Adults", numberOfAdults.toString()),
//             _buildDetailRow("Children", numberOfChildren.toString()),
//             _buildDetailRow("Rooms", numberOfRooms.toString()),
//             _buildDetailRow("Duration", "$numberOfDays days"),
//             const SizedBox(height: 8),

//             // Total Price
//             Text(
//               "Total Price: ₹$totalPrice",
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(value),
//         ],
//       ),
//     );
//   }
// }
// // lib/widgets/hotel_booking_card.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class HotelBookingCard extends StatelessWidget {
//   final String hotelName;
//   final String imageUrl;
//   final String firstName;
//   final String checkInDate;
//   final String checkOutDate;
//   final String checkInTime;
//   final String checkOutTime;
//   final int numberOfAdults;
//   final int numberOfChildren;
//   final int numberOfDays;
//   final int numberOfRooms;
//   final double totalPrice;

//   const HotelBookingCard({
//     super.key,
//     required this.hotelName,
//     required this.imageUrl,
//     required this.firstName,
//     required this.checkInDate,
//     required this.checkOutDate,
//     required this.checkInTime,
//     required this.checkOutTime,
//     required this.numberOfAdults,
//     required this.numberOfChildren,
//     required this.numberOfDays,
//     required this.numberOfRooms,
//     required this.totalPrice,
//   });

//   String _formatDate(String dateString) {
//     try {
//       // Try parsing ISO format first
//       DateTime date = DateTime.parse(dateString);
//       return DateFormat('dd/MM/yyyy').format(date);
//     } catch (e) {
//       // If parsing fails, try other common formats
//       try {
//         // Try parsing "April 16, 2025 at 2:55:47 AM UTC+530" format
//         final formatsToTry = [
//           "MMMM d, y 'at' h:mm:ss a 'UTC'Z",
//           "MMMM d, y",
//           "MMM d, y",
//           "yyyy-MM-dd",
//         ];

//         for (var format in formatsToTry) {
//           try {
//             DateTime date = DateFormat(format).parse(dateString);
//             return DateFormat('dd/MM/yyyy').format(date);
//           } catch (_) {}
//         }

//         // If all parsing fails, return original string
//         return dateString;
//       } catch (_) {
//         return dateString;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final formattedCheckInDate = _formatDate(checkInDate);
//     final formattedCheckOutDate = _formatDate(checkOutDate);

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.all(8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hotel Image
//             if (imageUrl.isNotEmpty)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   imageUrl,
//                   width: double.infinity,
//                   height: 150,
//                   fit: BoxFit.cover,
//                   errorBuilder:
//                       (context, error, stackTrace) => Container(
//                         height: 150,
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.error),
//                       ),
//                 ),
//               ),
//             const SizedBox(height: 12),

//             // Hotel Name
//             Text(
//               hotelName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),

//             // Guest Name
//             _buildDetailRow("Guest Name", firstName),

//             // Check-in Date
//             _buildDetailRow("Check-in Date", formattedCheckInDate),

//             // Check-in Time
//             _buildDetailRow("Check-in Time", checkInTime),

//             // Check-out Date
//             _buildDetailRow("Check-out Date", formattedCheckOutDate),

//             // Check-out Time
//             _buildDetailRow("Check-out Time", checkOutTime),

//             const SizedBox(height: 8),

//             // Booking Details
//             _buildDetailRow("Adults", numberOfAdults.toString()),
//             _buildDetailRow("Children", numberOfChildren.toString()),
//             _buildDetailRow("Rooms", numberOfRooms.toString()),
//             _buildDetailRow("Duration", "$numberOfDays days"),
//             const SizedBox(height: 8),

//             // Total Price
//             Text(
//               "Total Price: ₹$totalPrice",
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               "$label: ",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }
// lib/widgets/hotel_booking_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotelBookingCard extends StatelessWidget {
  final String hotelName;
  final String imageUrl;
  final String firstName;
  final String checkInDate;
  final String checkOutDate;
  final String checkInTime;
  final String checkOutTime;
  final int numberOfAdults;
  final int numberOfChildren;
  final int numberOfDays;
  final int numberOfRooms;
  final double totalPrice;

  const HotelBookingCard({
    super.key,
    required this.hotelName,
    required this.imageUrl,
    required this.firstName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.numberOfAdults,
    required this.numberOfChildren,
    required this.numberOfDays,
    required this.numberOfRooms,
    required this.totalPrice,
  });

  String _formatDate(String dateString) {
    try {
      // First extract the date part before " at "
      final datePart = dateString.split(' at ').first.trim();

      // Parse the extracted date (e.g. "April 14, 2025")
      final parsedDate = DateFormat('MMMM d, y').parse(datePart);

      // Format as dd/MM/yyyy (e.g. "14/04/2025")
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedCheckInDate = _formatDate(checkInDate);
    final formattedCheckOutDate = _formatDate(checkOutDate);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image and other widgets remain the same...
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                ),
              ),
            const SizedBox(height: 12),

            Text(
              hotelName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildDetailRow("Guest Name", firstName),
            _buildDetailRow("Check-in Date", formattedCheckInDate),
            _buildDetailRow("Check-in Time", checkInTime),
            _buildDetailRow("Check-out Date", formattedCheckOutDate),
            _buildDetailRow("Check-out Time", checkOutTime),

            const SizedBox(height: 8),

            _buildDetailRow("Adults", numberOfAdults.toString()),
            _buildDetailRow("Children", numberOfChildren.toString()),
            _buildDetailRow("Rooms", numberOfRooms.toString()),
            _buildDetailRow("Duration", "$numberOfDays days"),
            const SizedBox(height: 8),

            Text(
              "Total Price: ₹$totalPrice",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
