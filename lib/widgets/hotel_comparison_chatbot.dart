// import 'package:flutter/material.dart';
// import '../services/hotel_comparison_service.dart';

// class HotelComparisonChatbot extends StatefulWidget {
//   const HotelComparisonChatbot({super.key});

//   @override
//   State<HotelComparisonChatbot> createState() => _HotelComparisonChatbotState();
// }

// class _HotelComparisonChatbotState extends State<HotelComparisonChatbot> {
//   bool _isChatVisible = false;
//   String _response = '';
//   bool _isLoading = false;

//   Future<void> _compareHotels() async {
//     // Fixed typo in method name (was _compareHotels)
//     setState(() {
//       _isLoading = true;
//       _response = '';
//     });

//     final service = HotelComparisonService();
//     final result = await service.compareHotels();

//     setState(() {
//       _response = result;
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Chat bubble
//         if (_isChatVisible)
//           Positioned(
//             bottom: 80,
//             right: 20,
//             child: Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     // ignore: deprecated_member_use
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // Header
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(12),
//                         topRight: Radius.circular(12),
//                       ), // Added missing closing parenthesis
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.compare, color: Colors.white),
//                         SizedBox(width: 8),
//                         Text(
//                           'Hotel Comparison',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Content
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child:
//                           _isLoading
//                               ? const Center(child: CircularProgressIndicator())
//                               : SingleChildScrollView(child: Text(_response)),
//                     ),
//                   ),
//                   // Button
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton(
//                       onPressed:
//                           _compareHotels, // Fixed to match corrected method name
//                       child: const Text('Compare Hotels'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         // Floating button
//         Positioned(
//           bottom: 20,
//           right: 20,
//           child: FloatingActionButton(
//             onPressed: () {
//               setState(() {
//                 _isChatVisible = !_isChatVisible;
//                 if (_isChatVisible && _response.isEmpty) {
//                   _response = 'Click "Compare Hotels" to see a comparison';
//                 }
//               });
//             },
//             // ignore: sort_child_properties_last
//             child: const Text('AI'),
//             backgroundColor: Colors.blue,
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import '../services/hotel_comparison_service.dart';

// class HotelComparisonChatbot extends StatefulWidget {
//   const HotelComparisonChatbot({super.key});

//   @override
//   State<HotelComparisonChatbot> createState() => _HotelComparisonChatbotState();
// }

// class _HotelComparisonChatbotState extends State<HotelComparisonChatbot> {
//   final HotelComparisonService _service = HotelComparisonService();
//   bool _isChatVisible = false;
//   String _response = '';
//   bool _isLoading = false;
//   List<Map<String, dynamic>> _hotels = [];
//   bool _isSelectionMode = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadHotels();
//   }

//   Future<void> _loadHotels() async {
//     setState(() {
//       _isLoading = true;
//     });
//     _hotels = await _service.getAllHotels();
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> _compareHotels() async {
//     if (_isSelectionMode) {
//       setState(() {
//         _isLoading = true;
//       });
//       final result = await _service.compareSelectedHotels();
//       setState(() {
//         _response = result;
//         _isLoading = false;
//         _isSelectionMode = false;
//       });
//     } else {
//       setState(() {
//         _isSelectionMode = true;
//         _response = 'Please select 2 hotels to compare';
//       });
//     }
//   }

//   void _toggleHotelSelection(String hotelId) {
//     setState(() {
//       _service.selectHotel(hotelId);
//       if (_service.selectedCount == 2) {
//         _response =
//             'You have selected 2 hotels. Click "Compare Hotels" to compare them.';
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         if (_isChatVisible)
//           Positioned(
//             bottom: 80,
//             right: 20,
//             child: Container(
//               width: 350,
//               height: 450,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     // ignore: deprecated_member_use
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(12),
//                         topRight: Radius.circular(12),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.compare, color: Colors.white),
//                         const SizedBox(width: 8),
//                         Text(
//                           _isSelectionMode
//                               ? 'Select 2 Hotels (${_service.selectedCount}/2)'
//                               : 'Hotel Comparison',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         if (_isSelectionMode)
//                           IconButton(
//                             icon: const Icon(Icons.close, color: Colors.white),
//                             onPressed: () {
//                               setState(() {
//                                 _service.clearSelection();
//                                 _isSelectionMode = false;
//                                 _response = '';
//                               });
//                             },
//                           ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child:
//                         _isLoading
//                             ? const Center(child: CircularProgressIndicator())
//                             : SingleChildScrollView(
//                               padding: const EdgeInsets.all(12),
//                               child: Column(
//                                 children: [
//                                   if (_response.isNotEmpty)
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                         bottom: 12,
//                                       ),
//                                       child: Text(
//                                         _response,
//                                         style: const TextStyle(fontSize: 14),
//                                       ),
//                                     ),
//                                   if (_isSelectionMode)
//                                     ..._hotels
//                                         .map(
//                                           (hotel) => ListTile(
//                                             title: Text(hotel['name']),
//                                             subtitle: Text(
//                                               '\$${hotel['price']}/night',
//                                             ),
//                                             trailing:
//                                                 _service.isHotelSelected(
//                                                       hotel['id'],
//                                                     )
//                                                     ? const Icon(
//                                                       Icons.check_circle,
//                                                       color: Colors.green,
//                                                     )
//                                                     : null,
//                                             onTap:
//                                                 () => _toggleHotelSelection(
//                                                   hotel['id'],
//                                                 ),
//                                             tileColor:
//                                                 _service.isHotelSelected(
//                                                       hotel['id'],
//                                                     )
//                                                     ? Colors.blue[50]
//                                                     : null,
//                                           ),
//                                         )
//                                         // ignore: unnecessary_to_list_in_spreads
//                                         .toList(),
//                                 ],
//                               ),
//                             ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton(
//                       onPressed: _compareHotels,
//                       child: Text(
//                         _isSelectionMode
//                             ? 'Compare Selected'
//                             : 'Compare Hotels',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         Positioned(
//           bottom: 20,
//           right: 20,
//           child: FloatingActionButton(
//             onPressed: () {
//               setState(() {
//                 _isChatVisible = !_isChatVisible;
//                 if (_isChatVisible && _hotels.isEmpty) {
//                   _loadHotels();
//                 }
//               });
//             },
//             backgroundColor: Colors.blue,
//             child: const Icon(Icons.compare),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../services/hotel_comparison_service.dart';

class HotelComparisonChatbot extends StatefulWidget {
  const HotelComparisonChatbot({super.key});

  @override
  State<HotelComparisonChatbot> createState() => _HotelComparisonChatbotState();
}

class _HotelComparisonChatbotState extends State<HotelComparisonChatbot> {
  final HotelComparisonService _service = HotelComparisonService();
  bool _isChatVisible = false;
  String _response = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> _hotels = [];
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    setState(() {
      _isLoading = true;
    });
    _hotels = await _service.getAllHotels();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _compareHotels() async {
    if (_isSelectionMode) {
      setState(() {
        _isLoading = true;
      });
      final result = await _service.compareSelectedHotels();
      // Replace $ with ₹ in the response
      final formattedResult = result.replaceAll('\$', '₹');
      setState(() {
        _response = formattedResult;
        _isLoading = false;
        _isSelectionMode = false;
      });
    } else {
      setState(() {
        _isSelectionMode = true;
        _response = 'Please select 2 hotels to compare';
      });
    }
  }

  void _toggleHotelSelection(String hotelId) {
    setState(() {
      _service.selectHotel(hotelId);
      if (_service.selectedCount == 2) {
        _response =
            'You have selected 2 hotels. Click "Compare Hotels" to compare them.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isChatVisible)
          Positioned(
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                80, // Adjust for keyboard
            right: 20,
            left: 20, // Added left position to center the chat
            child: Container(
              width: MediaQuery.of(context).size.width - 40, // Responsive width
              height:
                  MediaQuery.of(context).size.height * 0.6, // Responsive height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.compare, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          _isSelectionMode
                              ? 'Select 2 Hotels (${_service.selectedCount}/2)'
                              : 'Hotel Comparison',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isSelectionMode)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _service.clearSelection();
                                _isSelectionMode = false;
                                _response = '';
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SingleChildScrollView(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  if (_response.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        _response,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  if (_isSelectionMode)
                                    ..._hotels
                                        .map(
                                          (hotel) => ListTile(
                                            title: Text(hotel['name']),
                                            subtitle: Text(
                                              '₹${hotel['price']}/night',
                                            ), // Changed to ₹
                                            trailing:
                                                _service.isHotelSelected(
                                                      hotel['id'],
                                                    )
                                                    ? const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    )
                                                    : null,
                                            onTap:
                                                () => _toggleHotelSelection(
                                                  hotel['id'],
                                                ),
                                            tileColor:
                                                _service.isHotelSelected(
                                                      hotel['id'],
                                                    )
                                                    ? Colors.blue[50]
                                                    : null,
                                          ),
                                        )
                                        // ignore: unnecessary_to_list_in_spreads
                                        .toList(),
                                ],
                              ),
                            ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _compareHotels,
                      child: Text(
                        _isSelectionMode
                            ? 'Compare Selected'
                            : 'Compare Hotels',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isChatVisible = !_isChatVisible;
                if (_isChatVisible && _hotels.isEmpty) {
                  _loadHotels();
                }
              });
            },
            child: const Icon(Icons.compare),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}
