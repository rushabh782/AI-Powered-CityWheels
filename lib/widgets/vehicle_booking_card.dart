// // lib/widgets/vehicle_booking_card.dart
// import 'package:flutter/material.dart';

// class VehicleBookingCard extends StatelessWidget {
//   final String vehicleName;
//   final String imageUrl;
//   final String pickUpDate;
//   final String pickUpTime;
//   final String dropOffDate;
//   final String dropOffTime;
//   final double totalCost;

//   const VehicleBookingCard({
//     super.key,
//     required this.vehicleName,
//     required this.imageUrl,
//     required this.pickUpDate,
//     required this.pickUpTime,
//     required this.dropOffDate,
//     required this.dropOffTime,
//     required this.totalCost,
//   });

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Card(
//   //     elevation: 4,
//   //     margin: const EdgeInsets.all(8),
//   //     child: Padding(
//   //       padding: const EdgeInsets.all(12.0),
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           // Vehicle Image
//   //           ClipRRect(
//   //             borderRadius: BorderRadius.circular(8),
//   //             child: Image.network(
//   //               imageUrl,
//   //               width: double.infinity,
//   //               height: 150,
//   //               fit: BoxFit.cover,
//   //               errorBuilder:
//   //                   (context, error, stackTrace) =>
//   //                       const Icon(Icons.error, size: 150),
//   //             ),
//   //           ),
//   //           const SizedBox(height: 12),

//   //           // Vehicle Name
//   //           Text(
//   //             vehicleName,
//   //             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//   //           ),
//   //           const SizedBox(height: 8),

//   //           // Booking Details
//   //           _buildDetailRow("Pick Up", "$pickUpDate at $pickUpTime"),
//   //           _buildDetailRow("Drop Off", "$dropOffDate at $dropOffTime"),
//   //           const SizedBox(height: 8),

//   //           // Total Cost
//   //           Text(
//   //             "Total Cost: ₹$totalCost",
//   //             style: const TextStyle(
//   //               fontSize: 16,
//   //               fontWeight: FontWeight.bold,
//   //               color: Colors.green,
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

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
//             // Vehicle Image with error handling
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
//               )
//             else
//               Container(
//                 height: 150,
//                 color: Colors.grey[200],
//                 child: const Center(child: Icon(Icons.image_not_supported)),
//               ),

//             const SizedBox(height: 12),

//             // Vehicle Name
//             Text(
//               vehicleName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             // Booking Details with null checks
//             if (pickUpDate.isNotEmpty && pickUpTime.isNotEmpty)
//               _buildDetailRow("Pick Up", "$pickUpDate at $pickUpTime"),

//             if (dropOffDate.isNotEmpty && dropOffTime.isNotEmpty)
//               _buildDetailRow("Drop Off", "$dropOffDate at $dropOffTime"),

//             const SizedBox(height: 8),

//             // Total Cost
//             Text(
//               "Total Cost: ₹$totalCost",
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
// lib/widgets/vehicle_booking_card.dart
import 'package:flutter/material.dart';

// lib/widgets/vehicle_booking_card.dart
class VehicleBookingCard extends StatelessWidget {
  final String name;
  final String address;
  final String pickUpDate;
  final String pickUpTime;
  final String dropOffDate;
  final String dropOffTime;
  final double totalCost;
  final String imageUrl;

  const VehicleBookingCard({
    super.key,
    required this.name,
    required this.address,
    required this.pickUpDate,
    required this.pickUpTime,
    required this.dropOffDate,
    required this.dropOffTime,
    required this.totalCost,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image
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

            // Vehicle/Hotel Name
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Address with label
            _buildDetailRow("Address", address),

            // Pickup Details
            _buildDetailRow("Pickup", "$pickUpDate at $pickUpTime"),

            // Dropoff Details
            _buildDetailRow("Dropoff", "$dropOffDate at $dropOffTime"),
            const SizedBox(height: 8),

            // Total Cost
            Text(
              "Total Cost: ₹$totalCost",
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, softWrap: true)),
        ],
      ),
    );
  }
}
